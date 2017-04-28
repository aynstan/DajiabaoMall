//
//  QMYBWebViewController.m
//  QMYB
//
//  Created by 大家保 on 2017/2/20.
//  Copyright © 2017年 大家保. All rights reserved.
//

#import "BaseWebViewController.h"
#import <WebKit/WebKit.h>
#import "WXApi.h"
#import "SDPhotoBrowser.h"
#import <Photos/Photos.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "MyMessageControllerViewController.h"
#import "LoginController.h"
#import "MeModel.h"
#import "UMessage.h"
#import <RongIMKit/RongIMKit.h>
#import "BaseNavigationController.h"
#define changeTotalTime 2.0
#define changeTotalCount 8.0

@interface BaseWebViewController ()<WKNavigationDelegate,WKUIDelegate,WKScriptMessageHandler,SDPhotoBrowserDelegate>
//浏览器
@property (nonatomic,strong) WKWebView *myWebView;
//图片数组
@property (nonatomic,strong) NSArray   *imageArray;

@end

@implementation BaseWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //电池栏
    UIView *topView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 20)];
    topView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:topView];
    //关闭自动下滑
    self.automaticallyAdjustsScrollViewInsets=NO;
    [UIView setIgnoreTags:@[@1000]];
    //初始化图片数组
    self.imageArray=[NSArray array];
    //创建一个webview的配置项
    WKWebViewConfiguration *config=[[WKWebViewConfiguration alloc]init];
    // 设置偏好设置
    config.preferences=[[WKPreferences alloc]init];
    // 默认为0
    config.preferences.minimumFontSize = 10;
    // 默认认为YES
    config.preferences.javaScriptEnabled = YES;
    // 在iOS上默认为NO，表示不能自动通过窗口打开
    config.preferences.javaScriptCanOpenWindowsAutomatically = YES;
    //打开h5上的video
    config.allowsInlineMediaPlayback=YES;
    #define js调用oc方法
    //注入js对象(js通过window.webkit.messageHandlers.JSMethod.postMessage({body: '传数据'});
    config.userContentController = [[WKUserContentController alloc]init];
    //分享
    [config.userContentController addScriptMessageHandler:self name:@"share"];
    //保存字符串图片
    [config.userContentController addScriptMessageHandler:self name:@"saveimg"];
    //查看图片
    [config.userContentController addScriptMessageHandler:self name:@"lookImages"];
    //保存url图片
    [config.userContentController addScriptMessageHandler:self name:@"saveImageWithUrl"];
    //提现成功
    [config.userContentController addScriptMessageHandler:self name:@"drawMoney"];
    //编辑名片
    [config.userContentController addScriptMessageHandler:self name:@"editCard"];
    //被踢下线
    [config.userContentController addScriptMessageHandler:self name:@"loginOut"];
    //mywebview
    self.myWebView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, SCREEN_HEIGHT-20)  configuration:config];
    self.myWebView.navigationDelegate = self;
    self.myWebView.UIDelegate=self;
    self.myWebView.allowsBackForwardNavigationGestures = YES;
    if (0<self.urlStr.length) {
        if ([self.urlStr containsString:@"?"]) {
            self.urlStr=[self.urlStr stringByAppendingString:[NSString stringWithFormat:@"&sid=%@",[UserDefaults objectForKey:TOKENID]]];
        }else{
            self.urlStr=[self.urlStr stringByAppendingString:[NSString stringWithFormat:@"?sid=%@",[UserDefaults objectForKey:TOKENID]]];
        }
    }
    NSLog(@"请求地址：%@",self.urlStr);
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.urlStr]];
    [self.myWebView loadRequest:request];
    [self addObservers];
    [self.view insertSubview:self.myWebView atIndex:0];
}


#pragma mark kvo
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        if (object == self.myWebView) {
            if ([XWNetworking isHaveNetwork]) {
                self.jinduProgress.progress=self.myWebView.estimatedProgress>=1?0:self.myWebView.estimatedProgress;
                self.jinduProgress.hidden=self.myWebView.estimatedProgress>=1?YES:NO;
            }else{
                [self autoChangeProgress];
            }
        }else {
            [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        }
    }else if ([keyPath isEqualToString:@"title"]) {
        if (object == self.myWebView) {
        }else{
            [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        }
    }else if ([keyPath isEqualToString:@"canGoBack"]){
        if (object == self.myWebView) {
            self.closeButton.hidden=!self.myWebView.canGoBack;
        }else {
            [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        }
    }else if ([keyPath isEqualToString:@"loading"]){
        if (object == self.myWebView) {
           
        }else {
            [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        }
    }else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
    #define oc调用js方法
    // 加载完成
//    if (!self.myWebView.loading) {
//        // 手动调用JS代码
//        // 每次页面完成都弹出来，大家可以在测试时再打开
//        NSString *js = @"window.alert('测试')";
//        [self.myWebView evaluateJavaScript:js completionHandler:^(id _Nullable response, NSError * _Nullable error) {
//            NSLog(@"response: %@ error: %@", response, error);
//        }];
//    }
}

#pragma mark 没有网络时做个假的进度条
- (void)autoChangeProgress{
    __block float count=0.1;
    //验证码倒计时
    __block float timeout=changeTotalTime; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),changeTotalTime/changeTotalCount*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                self.jinduProgress.progress=0.9;
            });
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                count+=0.1;
                self.jinduProgress.progress=count;
            });
            timeout-=changeTotalTime/changeTotalCount;
        }
    });
    dispatch_resume(_timer);
}


#pragma mark WKNavigationDelegate
#pragma mark 页面开始加载
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    
}

#pragma mark 内容返回
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation{
    
};

#pragma mark 加载完成
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    
}

#pragma mark 加载失败
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    
}

//拨打电话
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    NSURL *URL = navigationAction.request.URL;
    NSString *scheme = [URL scheme];
    if ([scheme isEqualToString:@"tel"]) {
        NSString *resourceSpecifier = [URL resourceSpecifier];
        NSString *callPhone = [NSString stringWithFormat:@"telprompt://%@", resourceSpecifier];
        // 防止iOS 10及其之后，拨打电话系统弹出框延迟出现
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:callPhone]]) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callPhone]];
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [MBProgressHUD ToastInformation:@"您的设备不支持电话拨打"];
                });
            }
        });
    }else if ([scheme isEqualToString:@"mailto"]){
        NSString *resourceSpecifier = [URL resourceSpecifier];
        NSString *url = [NSString stringWithFormat:@"mailto://%@",resourceSpecifier];
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:url]]) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [MBProgressHUD ToastInformation:@"您的设备不支持邮件发送"];
                });
            }
        });
    }
    decisionHandler(WKNavigationActionPolicyAllow);
}



#pragma mark WKUIDelegate
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler{
    UIAlertController *controller=[UIAlertController alertControllerWithTitle:message message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();
    }];
    [controller addAction:action];
    [self presentViewController:controller animated:YES completion:nil];
}

- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler{
    UIAlertController *controller=[UIAlertController alertControllerWithTitle:message message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(true);
    }];
    UIAlertAction *cancelAction=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(false);
    }];
    [controller addAction:action];
    [controller addAction:cancelAction];
    [self presentViewController:controller animated:YES completion:nil];
}

- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * _Nullable))completionHandler{
    UIAlertController *controller=[UIAlertController alertControllerWithTitle:prompt message:defaultText preferredStyle:UIAlertControllerStyleAlert];
    [controller addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.textColor=[UIColor darkGrayColor];
    }];
    UIAlertAction *action=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(controller.textFields[0].text);
    }];
    [controller addAction:action];
    [self presentViewController:controller animated:YES completion:nil];
}

- (void)webViewDidClose:(WKWebView *)webView{
    
}

#pragma mark WKScriptMessageHandler
#pragma mark js调用oc方法,参数只支持NSNumber, NSString, NSDate, NSArray,NSDictionary, and   NSNull类型
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    //分享
    if ([message.name isEqualToString:@"share"]) {
        if ([message.body isKindOfClass:[NSDictionary class]]&&[[message.body allKeys]containsObject:@"body"]) {
            NSDictionary *contentDic=[message.body objectForKey:@"body"];
            if ([[contentDic allKeys] containsObject:@"shareType"]) {
                [self shareImageUrl:contentDic[@"shareImageUrl"] shareUrl:contentDic[@"shareUrl"] title:contentDic[@"shareTile"] subTitle:contentDic[@"subTitle"] shareType:[contentDic[@"shareType"] integerValue]];
            }
        }//保存图片
    }else if ([message.name isEqualToString:@"saveimg"]) {
        if ([message.body isKindOfClass:[NSDictionary class]]&&[[message.body allKeys]containsObject:@"body"]) {
            if ([[message.body objectForKey:@"body"] isKindOfClass:[NSString class]]) {
                NSString *contentStr=[message.body objectForKey:@"body"];
                [self saveImage:contentStr];
            }
        }//显示图片
    }else if ([message.name isEqualToString:@"lookImages"]) {
        NSLog(@"%@",message.body);
        if ([message.body isKindOfClass:[NSDictionary class]]&&[[message.body allKeys]containsObject:@"body"]) {
            if ([[message.body objectForKey:@"body"] isKindOfClass:[NSArray class]]) {
                self.imageArray=[message.body objectForKey:@"body"];
                [self showImage:self.imageArray andSlectIndex:0];
            }
        }//保存图片url
    }else if ([message.name isEqualToString:@"saveImageWithUrl"]){
        if ([message.body isKindOfClass:[NSDictionary class]]&&[[message.body allKeys]containsObject:@"body"]) {
            if ([[message.body objectForKey:@"body"] isKindOfClass:[NSString class]]) {
                NSString *urlStr=[message.body objectForKey:@"body"];
                [self saveImageWithUrl:urlStr];
            }
        }
    }else if ([message.name isEqualToString:@"drawMoney"]){
        [self.navigationController popViewControllerAnimated:YES];
        //编辑名片
    }else if ([message.name isEqualToString:@"editCard"]){
        MyMessageControllerViewController *message=[[MyMessageControllerViewController alloc]init];
        message.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:message animated:YES];
    }else if ([message.name isEqualToString:@"loginOut"]){
        //被踢下线
        [self connectToLogin];
    }
    
};

/**
 *  会话过期重新登录
 */
- (void)connectToLogin{
    if (nil!=[UserDefaults objectForKey:TOKENID]) {
        [self toastMessage:@"系统检测到您已在其它设备上登录，本地已下线，请重新登录"];
    }
    MeModel *me=[NSKeyedUnarchiver unarchiveObjectWithData:[UserDefaults valueForKey:ME]];;
    [UMessage removeAlias:me.mobilephone type:@"com.dajiabao.qqb" response:nil];
    [[RCIM sharedRCIM] logout];
    [UserDefaults setObject:nil forKey:TOKENID];
    [UserDefaults setValue:nil forKey:ME];
    [UserDefaults synchronize];
    KeyWindow.rootViewController=[[BaseNavigationController alloc]initWithRootViewController:[[LoginController alloc]init]];
}

//提示
- (void)toastMessage:(NSString *)toastMessage{
    UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"提醒" message:toastMessage preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel=[UIAlertAction actionWithTitle:@"我知道了" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alert addAction:cancel];
    [KeyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
}



//显示图片
- (void)showImage:(NSArray *)imageArr andSlectIndex:(NSInteger )index{
    SDPhotoBrowser *photoBrowser = [SDPhotoBrowser new];
    photoBrowser.delegate = self;
    photoBrowser.currentImageIndex = index;
    photoBrowser.imageCount = imageArr.count;
    photoBrowser.modalTransitionStyle=UIModalTransitionStyleCrossDissolve;
    [self presentViewController:photoBrowser animated:YES completion:nil];
}

//保存图片
- (void)saveImageWithUrl:(NSString *)urlStr{
    PHAuthorizationStatus author = [PHPhotoLibrary authorizationStatus];
    if (author == ALAuthorizationStatusRestricted || author == ALAuthorizationStatusDenied) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self alertWithMessage:@"请在iphone的“设置-隐私-照片”选项中，允许圈圈访问您的手机相册"];
        });
    }else if(author == ALAuthorizationStatusNotDetermined){
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            if (status == PHAuthorizationStatusRestricted || status == PHAuthorizationStatusDenied){
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self alertWithMessage:@"请在iphone的“设置-隐私-照片”选项中，允许圈圈访问您的手机相册"];
                });
            }else if (status == PHAuthorizationStatusAuthorized){
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self saveWithUrl:urlStr];
                });
            }
        }];
    }else if(author == ALAuthorizationStatusAuthorized){
        [self saveWithUrl:urlStr];
    }
    
}

//通过url储存图片
- (void)saveWithUrl:(NSString *)url{
    [MBProgressHUD showHUDWithTitle:@"正在保存"];
    NSData *imageData=[NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
    UIImage *saveImage=[UIImage imageWithData:imageData];
    if (saveImage) {
        UIImageWriteToSavedPhotosAlbum(saveImage, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
    }
}



//保存图片
- (void)saveImage:(NSString *)urlStr{
    PHAuthorizationStatus author = [PHPhotoLibrary authorizationStatus];
    if (author == ALAuthorizationStatusRestricted || author == ALAuthorizationStatusDenied) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self alertWithMessage:@"请在iphone的“设置-隐私-照片”选项中，允许圈圈访问您的手机相册"];
        });
    }else if(author == ALAuthorizationStatusNotDetermined){
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            if (status == PHAuthorizationStatusRestricted || status == PHAuthorizationStatusDenied){
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self alertWithMessage:@"请在iphone的“设置-隐私-照片”选项中，允许圈圈访问您的手机相册"];
                });
            }else if (status == PHAuthorizationStatusAuthorized){
                dispatch_async(dispatch_get_main_queue(), ^{
                        [self save:urlStr];
                });
            }
        }];
    }else if(author == ALAuthorizationStatusAuthorized){
        [self save:urlStr];
    }
    
}


//保存
- (void)save:(NSString *)urlStr{
    [MBProgressHUD showHUDWithTitle:@"正在保存"];
    UIImage  *saveImage=[self imageFromString:urlStr];
    if (saveImage) {
        UIImageWriteToSavedPhotosAlbum(saveImage, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
    }else{
        [MBProgressHUD ToastInformation:@"图片格式不正确"];
    }
}

//字符串转图片
- (UIImage *)imageFromString:(NSString *)string{
    // NSString --> NSData
    NSData *data=[[NSData alloc] initWithBase64EncodedString:string options:NSDataBase64DecodingIgnoreUnknownCharacters];
    // NSData --> UIImage
    UIImage *image = [UIImage imageWithData:data];
    return image;
}

//图片转字符串
- (NSString *)imageToString:(UIImage *)image{
    // UIImage --> NSData
    NSData *imageData = UIImageJPEGRepresentation(image, 1.0);
    // NSData --> NSString
    NSString *imageDataString = [imageData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
    return imageDataString;
}

//权限提醒
- (void)alertWithMessage:(NSString *)toastMessage{
    UIAlertController *phoneAlert=[UIAlertController alertControllerWithTitle:@"提醒" message:toastMessage preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel=[UIAlertAction actionWithTitle:@"我知道了" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [phoneAlert addAction:cancel];
    [self presentViewController:phoneAlert animated:YES completion:nil];
}


//保存图片回调
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    if (error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD showSuccess:@"保存失败"];
        });
    }else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD showSuccess:@"图片已保存到相册"];
        });
    }
}


#pragma mark 回退
- (IBAction)goBack:(id)sender {
    if ([self.myWebView canGoBack]) {
        [self.myWebView goBack];
    }else{
        [self goPreViewController:nil];
    }
}

#pragma mark 关闭按钮
- (IBAction)goPreViewController:(id)sender {
    [self.myWebView stopLoading];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark 刷新按钮(测试保存图片)
- (IBAction)freshReload:(id)sender {
    //[self.myWebView loadRequest:[NSURLRequest requestWithURL:self.currentUrl]];
}

#pragma mark wkwebview属性监听
- (void)addObservers {
    [self.myWebView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:NULL];
    [self.myWebView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:NULL];
    [self.myWebView addObserver:self forKeyPath:@"canGoBack" options:NSKeyValueObservingOptionNew context:nil];
    [self.myWebView addObserver:self forKeyPath:@"loading" options:NSKeyValueObservingOptionNew context:nil];
}

#pragma mark 移除wkwebview属性监听
- (void)dealloc {
    [self.myWebView removeObserver:self forKeyPath:@"estimatedProgress"];
    [self.myWebView removeObserver:self forKeyPath:@"title"];
    [self.myWebView removeObserver:self forKeyPath:@"canGoBack"];
    [self.myWebView removeObserver:self forKeyPath:@"loading"];
}


#pragma mark 分享到朋友圈
- (void)shareImageUrl:(NSString *)shareImageUrl  shareUrl:(NSString *)shareUrl  title:(NSString *)shareTile subTitle:(NSString *)subTitle shareType:(NSInteger )type{
    if ([WXApi isWXAppInstalled]) {
        WeakSelf;
        [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
            [weakSelf shareWebPageToPlatformType:platformType ImageUrl:shareImageUrl shareUrl:shareUrl title:shareTile subTitle:subTitle shareType:type] ;
        }];
    }else{
        UIAlertController *alertController=[UIAlertController alertControllerWithTitle:@"提醒" message:@"您尚未安装微信客户端，暂无法使用微信分享功能" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction=[UIAlertAction actionWithTitle:@"我知道了" style:UIAlertActionStyleCancel handler:nil];
        [alertController addAction:cancelAction];
        [KeyWindow.rootViewController presentViewController:alertController animated:NO completion:nil];
    }
}

//分享网页
- (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType ImageUrl:(NSString *)shareImageUrl  shareUrl:(NSString *)shareUrl  title:(NSString *)shareTile subTitle:(NSString *)subTitle shareType:(NSInteger )type{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    if (type==0) {
        //分享网页
        NSString* thumbURL=(0==shareImageUrl.length?@"":shareImageUrl);
        UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:(0==shareTile.length?@" ":shareTile) descr:(0==subTitle.length?@" ":subTitle) thumImage:[NSData dataWithContentsOfURL:[NSURL URLWithString:thumbURL]]];
        shareObject.webpageUrl = (0==shareUrl.length?@"":shareUrl);
        messageObject.shareObject = shareObject;
    }else if (type==1){
        //分享图片(url)
        UMShareImageObject *shareObject = [[UMShareImageObject alloc] init];
        NSData  *imageData=[NSData dataWithContentsOfURL:[NSURL URLWithString:(0==shareImageUrl.length?@"":shareImageUrl)]];
        [shareObject setShareImage:imageData];
        messageObject.shareObject = shareObject;
    }else if (type==3){
        //分享图片(base64)
        UMShareImageObject *shareObject = [[UMShareImageObject alloc] init];
        [shareObject setShareImage:[self imageFromString:shareImageUrl]];
        messageObject.shareObject = shareObject;
    }else if (type==2){
        //分享文本
        messageObject.text = shareTile;
    }
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD ToastInformation:@"分享失败"];
            });
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD ToastInformation:@"分享成功"];
            });
        }
    }];
}

#pragma mark  SDPhotoBrowserDelegate

// 返回临时占位图片（即原来的小图）
- (UIImage *)photoBrowser:(SDPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index{
    // 不建议用此种方式获取小图，这里只是为了简单实现展示而
    return [UIImage imageNamed:@"空白图"];
}


// 返回高质量图片的url
- (NSURL *)photoBrowser:(SDPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index{
    NSString *urlStr = self.imageArray[index];
    return [NSURL URLWithString:urlStr];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [IQKeyboardManager sharedManager].enable = NO;
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [IQKeyboardManager sharedManager].enable = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
