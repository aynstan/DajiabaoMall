//
//  AppDelegate.m
//  DaJiaBaoMall
//
//  Created by 大家保 on 2017/3/27.
//  Copyright © 2017年 大家保. All rights reserved.
//

#import "AppDelegate.h"
#import "BaseTabBarController.h"
#import "NotDismissAlertView.h"
#import "UserGuideViewController.h"
#import "BaseWebViewController.h"
#import "BaseNavigationController.h"
#import "LoginController.h"

@interface AppDelegate ()

@property (nonatomic,strong)JCAlertView *updateAlert;

@property (nonatomic,strong)UITraitCollection *traitCollection;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window=[[UIWindow alloc]initWithFrame:[[UIScreen mainScreen]bounds]];
    
    //设置rootVC
    if ([UserDefaults boolForKey:@"firstLanch"]==NO) {
        UserGuideViewController *guide=[[UserGuideViewController alloc]init];
        self.window.rootViewController=guide;
    }else{
        if ([UserDefaults objectForKey:TOKENID]!=nil) {
            BaseTabBarController *rootVC=[[BaseTabBarController alloc]init];
            self.window.rootViewController=rootVC;
        }else{
            LoginController *rootVC=[[LoginController alloc]init];
            self.window.rootViewController=[[BaseNavigationController alloc]initWithRootViewController:rootVC];
        }
    }
    //键盘
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.shouldResignOnTouchOutside = YES;
    manager.toolbarDoneBarButtonItemText=@"完成";
    manager.shouldToolbarUsesTextFieldTintColor = NO;
    manager.enableAutoToolbar=YES;
    manager.shouldShowTextFieldPlaceholder=NO;
    manager.toolbarTintColor=[UIColor darkGrayColor];
    manager.toolbarManageBehaviour =IQAutoToolbarByTag;
    
    //友盟分享
    [self umengShare];
    
    //友盟统计
    [self umengTrack];
    
    //检查更新
    //[self update];
    
    self.window.backgroundColor=[UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    return YES;
}

/**
 *  友盟分享
 */
- (void)umengShare {
    [[UMSocialManager defaultManager] setUmSocialAppkey:UMENG_APPKEY];
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:weChatId appSecret:weChatScreat redirectURL:@"http://www.dajiabao.com"];
    [[UMSocialManager defaultManager] removePlatformProviderWithPlatformTypes:@[@(UMSocialPlatformType_WechatFavorite)]];
}


/**
 *  友盟应用统计
 */
- (void)umengTrack {
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    UMConfigInstance.appKey = UMENG_APPKEY;
    UMConfigInstance.channelId = @"App Store";
    UMConfigInstance.ePolicy=BATCH;
    [MobClick setAppVersion:version];
    [MobClick startWithConfigure:UMConfigInstance];
}


//分享回掉
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url];
    if (!result) {
        // 其他如支付等SDK的回调
    }
    return result;
}

/**
 *检查更新
 *
 */
- (void)update{
    NSString * currentVersion=[[[NSBundle mainBundle] infoDictionary]objectForKey:@"CFBundleShortVersionString"];
    NSString *urlStr=[NSString stringWithFormat:@"%@%@",APPHOSTURL,updateVersion];
    NSDictionary *dic=@{@"version":currentVersion};
    [XWNetworking postJsonWithUrl:urlStr params:dic success:^(id response) {
        NSDictionary *dic =response;
        if ([dic integerForKey:@"code"]==2) {
            NSDictionary *dataDic=[dic dictionaryForKey:@"data"];
            //最新版本号
            NSString     *version=@"";
            if ([dataDic hasKey:@"version"]) {
                version =[NSString stringWithFormat:@"v%@",[dataDic stringForKey:@"version"]];}
            //更新内容
            NSString     *content=[[dataDic stringForKey:@"content"] stringByReplacingOccurrencesOfString:@"*" withString:@"\n"];
            //是否强制更新
            NSInteger    notDisMiss=0;
            if ([dataDic hasKey:@"forcedUpdating"]) {
                notDisMiss = [dataDic integerForKey:@"forcedUpdating"];
            }
            //提示框
            [self showAlertWithTitle:[NSString stringWithFormat:@"发现新版本%@", version] Message:content notDissMiss:notDisMiss];
        }
    } fail:^(NSError *error) {
        
    } showHud:NO];
}

//下载更新
- (void)toConnectAppStore{
    NSString *updateUrl = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewSoftware?id=%d",1140892295];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:updateUrl]];
}

//强制退出
- (void)exitApplication {
    exit(0);
}

//左对齐版本升级提示
- (void) showAlertWithTitle:(NSString *)title  Message:(NSString *) message  notDissMiss:(NSInteger)diss{
    NotDismissAlertView *alert=[[NotDismissAlertView alloc]initWithTitle:title content:message toUpdate:diss firstButtonClick:^(NSInteger clickInteger) {
        if (clickInteger==1) {
            [self exitApplication];
        }else{
            [self.updateAlert dismissWithCompletion:nil];
        }
    } secondButtonClick:^(NSInteger clickInteger) {
        if (clickInteger==1) {
            [self toConnectAppStore];
        }else{
            [self.updateAlert dismissWithCompletion:^{
                [self toConnectAppStore];
            }];
        }
    }];
    self.updateAlert=[[JCAlertView alloc]initWithCustomView:alert dismissWhenTouchedBackground:NO];
    [self.updateAlert show];
}


//3dtouch操作
- (void)application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void (^)(BOOL))completionHandler{
    //如果在介绍页面
    if ([UserDefaults boolForKey:@"firstLanch"]==NO) {
        NSLog(@"介绍页面，什么都不干");
    //如果未登录
    }else if([UserDefaults objectForKey:TOKENID]==nil){
        NSLog(@"登陆界面什么都不干");
    }else{
        NSLog(@"主页面，做操作");
        UIViewController *pushViewController;
        if ([KeyWindow.rootViewController isKindOfClass:[UITabBarController class]]) {
            UITabBarController *controller=(UITabBarController *)KeyWindow.rootViewController;
            pushViewController=((BaseNavigationController *)controller.selectedViewController).topViewController;
        }else{
            if ([KeyWindow.rootViewController isKindOfClass:[BaseNavigationController class]]) {
                pushViewController=((BaseNavigationController *)(KeyWindow.rootViewController)).topViewController;
            }else{
                pushViewController=KeyWindow.rootViewController;
            }
        }
        NSLog(@"%@",NSStringFromClass([pushViewController class]));
        if ([shortcutItem.type isEqualToString:@"com.dajiabao.frend"]){
            BaseWebViewController *webvView=[[BaseWebViewController alloc]init];
            webvView.urlStr=@"http://www.baidu.com";
            webvView.hidesBottomBarWhenPushed=YES;
            [pushViewController.navigationController pushViewController:webvView animated:NO];
        }else if ([shortcutItem.type isEqualToString:@"com.dajiabao.myMoney"]){
            BaseWebViewController *webvView=[[BaseWebViewController alloc]init];
            webvView.urlStr=@"http://www.sina.com";
            webvView.hidesBottomBarWhenPushed=YES;
            [pushViewController.navigationController pushViewController:webvView animated:NO];
        }else if ([shortcutItem.type isEqualToString:@"com.dajiabao.invite"]){
            BaseWebViewController *webvView=[[BaseWebViewController alloc]init];
            webvView.urlStr=@"http://www.sogou.com";
            webvView.hidesBottomBarWhenPushed=YES;
            [pushViewController.navigationController pushViewController:webvView animated:NO];
        }
    }
    completionHandler?completionHandler(YES):nil;
}





- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
