//
//  QMYBWebViewController.m
//  QMYB
//
//  Created by 大家保 on 2017/2/20.
//  Copyright © 2017年 大家保. All rights reserved.
//

#import "BaseWebViewController.h"
#import <WebKit/WebKit.h>
#define changeTotalTime 2.0
#define changeTotalCount 8.0

@interface BaseWebViewController ()<WKNavigationDelegate,WKUIDelegate,WKScriptMessageHandler>

@property (nonatomic,strong) WKWebView *myWebView;

@property (nonatomic,assign) BOOL netWorkError;

@property (nonatomic,strong) NSURL *currentUrl;

@end

@implementation BaseWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [UIView setIgnoreTags:@[@1000]];
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
    //config.userContentController = [[WKUserContentController alloc]init];
    //[config.userContentController addScriptMessageHandler:self name:@"JSMethod"];
    
    self.myWebView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 64.5, SCREEN_WIDTH, SCREEN_HEIGHT-64.5)  configuration:config];
    self.myWebView.navigationDelegate = self;
    self.myWebView.UIDelegate=self;
    self.myWebView.allowsBackForwardNavigationGestures = YES;
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.urlStr]];
    
//    NSLog(@"%@",[NSURL URLWithString:self.urlStr]);
    
    
    [self.myWebView loadRequest:request];
    
    [self addObservers];
    
    [self.view addSubview:self.myWebView];
    [self.view bringSubviewToFront:self.myWebView];

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
            self.titleLabel.text = self.myWebView.title;
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
    self.currentUrl=webView.URL;
    self.netWorkError=NO;
}

#pragma mark 内容返回
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation{
    self.netWorkError=NO;
};

#pragma mark 加载完成
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    self.netWorkError=NO;
    
}

#pragma mark 加载失败
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    self.netWorkError=YES;
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
#define js调用oc方法
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
//    if ([message.name isEqualToString:@"JSMethod"]) {
//        // 打印所传过来的参数，只支持NSNumber, NSString, NSDate, NSArray,NSDictionary, and NSNull类型
//        NSLog(@"%@", message.body);
//    }
};

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

#pragma mark 刷新按钮
- (IBAction)freshReload:(id)sender {
    [self.myWebView loadRequest:[NSURLRequest requestWithURL:self.currentUrl]];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
