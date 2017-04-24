//
//  AppDelegate.m
//  DaJiaBaoMall
//
//  Created by 大家保 on 2017/3/27.
//  Copyright © 2017年 大家保. All rights reserved.
//

#import "AppDelegate.h"
#import "BaseTabBarController.h"
#import "UserGuideViewController.h"
#import "BaseWebViewController.h"
#import "BaseNavigationController.h"
#import "LoginController.h"
#import "MyMoneyController.h"
#import "UMessage.h"
#import "TSMessage.h"
#import "VersionManager.h"
#import <RongIMKit/RongIMKit.h>
#import "XWPersonModel.h"
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 100000
#import <UserNotifications/UserNotifications.h>
#import "ConnectServiceViewController.h"
#endif

@interface AppDelegate ()<UNUserNotificationCenterDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    //窗口初始化
    self.window=[[UIWindow alloc]initWithFrame:[[UIScreen mainScreen]bounds]];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    
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
    
    //友盟推送
    [self umpush:launchOptions];
    
    //注册融云
    [[RCIM sharedRCIM] initWithAppKey:RongCloudKey];
    
    //检查更新
     [VersionManager checkVerSion];
    
    //创建本地数据库和通讯录表
    if (![[JQFMDB shareDatabase] jq_isExistTable:@"contact"]) {
        BOOL success=[[JQFMDB shareDatabase] jq_createTable:@"contact" dicOrModel:[XWPersonModel class]];
        if (success) {
            [[JQFMDB shareDatabase] close];
        }
    }
    
    //窗口设置
    self.window.backgroundColor=[UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    //未启动状态下接收推送处理
    NSDictionary* userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if(userInfo){
        [self appUnLanch:userInfo];
    }
    
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
    UMConfigInstance.appKey = UMENG_APPKEY;
    UMConfigInstance.channelId = @"App Store";
    UMConfigInstance.ePolicy=BATCH;
    [MobClick setAppVersion:VERSION];
    [MobClick startWithConfigure:UMConfigInstance];
}

/**
 *  友盟推送
 */
- (void)umpush:(NSDictionary *)launchOptions{
    [UMessage startWithAppkey:UMPUSHKEY launchOptions:launchOptions httpsenable:YES];
    [UMessage registerForRemoteNotifications];
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 100000
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    UNAuthorizationOptions types10=UNAuthorizationOptionBadge|  UNAuthorizationOptionAlert|UNAuthorizationOptionSound;
    [center requestAuthorizationWithOptions:types10     completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (granted) {
        
        } else {
        
        }
    }];
#endif
}

//苹果回传的token
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
#pragma mark 融云通讯上传deviceToken
    NSString *token =[[[[deviceToken description] stringByReplacingOccurrencesOfString:@"<"withString:@""] stringByReplacingOccurrencesOfString:@">" withString:@""]stringByReplacingOccurrencesOfString:@" " withString:@""];
    [[RCIMClient sharedRCIMClient] setDeviceToken:token];
}

//接收通知（未启动状态下）
- (void)appUnLanch:(NSDictionary *)userInfo{
    [self pushViewController:userInfo];
}

//接收通知（前台或者后台状态下）
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    //应用处于前台时的远程推送接受，关闭U-Push自带的弹出框
    if([UIApplication sharedApplication].applicationState == UIApplicationStateActive){
        [UMessage setAutoAlert:NO];
        [UMessage didReceiveRemoteNotification:userInfo];
        //当应用是前台状态时收到的通知
        [self pushViewControllerInActive:userInfo];
    }else{
        [UMessage didReceiveRemoteNotification:userInfo];
        //当应用是后台状态时收到的通知
        [self pushViewController:userInfo];
    }
}

#pragma mark 本地推送（前台或者后台运行）
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification{
    if ([[notification.userInfo allKeys] containsObject:@"rc"]) {
        [[[notification.userInfo objectForKey:@"rc"] allKeys] containsObject:@"cType"];
        if ([[[notification.userInfo objectForKey:@"rc"] objectForKey:@"cType"] isEqualToString:@"CS"]) {
            UIViewController *pushViewController=[self getTopViewController:KeyWindow.rootViewController];
            //客服
            if (![pushViewController isMemberOfClass:[ConnectServiceViewController class]]) {
                ConnectServiceViewController *conversationVC = [[ConnectServiceViewController alloc] init];
                conversationVC.conversationType = ConversationType_CUSTOMERSERVICE;
                conversationVC.targetId =RongCloudServiceID;
                conversationVC.title =@"智能客服";
                conversationVC.hidesBottomBarWhenPushed=YES;
                [pushViewController.navigationController pushViewController:conversationVC animated:YES];
            }
        }
    }
}


//推送集中处理的地方(前台状态下)
- (void)pushViewControllerInActive:(NSDictionary *)userInfo{
    NSString *subTitle;
    if ([[[userInfo objectForKey:@"aps"] allKeys] containsObject:@"alert"]) {
        id  alert=[[userInfo objectForKey:@"aps"] objectForKey:@"alert"];
        if ([alert isKindOfClass:[NSString class]]) {
            subTitle=alert;
        }else if([alert isKindOfClass:[NSDictionary class]]){
            if ([[alert allKeys]containsObject:@"body"]) {
                subTitle=[alert objectForKey:@"body"];
            }
        }
    }
    [TSMessage showNotificationInViewController:[UIApplication sharedApplication].delegate.window.rootViewController title:NSLocalizedString(@"圈圈保", nil)
                                       subtitle:NSLocalizedString(subTitle, nil)
                                          image:[UIImage imageNamed:@"通知"]
                                           type:TSMessageNotificationTypeMessage
                                       duration:2
                                       callback:^(){
                                           [self pushViewController:userInfo];
                                       }
                                    buttonTitle:nil
                                 buttonCallback:nil
                                     atPosition:TSMessageNotificationPositionNavBarOverlay
                           canBeDismissedByUser:YES];
}


//推送集中处理的地方(后台状态下，未打开状态下)
- (void)pushViewController:(NSDictionary *)userInfo{
    UIViewController *pushViewController=[self getTopViewController:KeyWindow.rootViewController];
    if (pushViewController!=nil) {
        NSLog(@"该远程推送包含来自融云的推送服务");
        if ([[userInfo allKeys] containsObject:@"rc"]) {
            [[[userInfo objectForKey:@"rc"] allKeys] containsObject:@"cType"];
            if ([[[userInfo objectForKey:@"rc"] objectForKey:@"cType"] isEqualToString:@"CS"]) {
                //客服
                if (![pushViewController isMemberOfClass:[ConnectServiceViewController class]]) {
                    ConnectServiceViewController *conversationVC = [[ConnectServiceViewController alloc] init];
                    conversationVC.conversationType = ConversationType_CUSTOMERSERVICE;
                    conversationVC.targetId =RongCloudServiceID;
                    conversationVC.title =@"智能客服";
                    conversationVC.hidesBottomBarWhenPushed=YES;
                    [pushViewController.navigationController pushViewController:conversationVC animated:YES];
                }
                [UserDefaults setBool:YES forKey:@"haveUnredMsg"];
                [UserDefaults synchronize];
            }
        }else {
            NSLog(@"该远程推送不包含来自融云的推送服务");
            NSString *type=@"";
            NSString *content=@"";
            if ([[userInfo allKeys] containsObject:@"type"]) {
                type=[userInfo valueForKey:@"type"];
            }
            if ([[userInfo allKeys] containsObject:@"content"]) {
                content=[userInfo valueForKey:@"content"];
            }
            if (0==content.length) {
                return;
            }
            BaseWebViewController *webvView=[[BaseWebViewController alloc]init];
            webvView.urlStr=content;
            webvView.hidesBottomBarWhenPushed=YES;
            [pushViewController.navigationController pushViewController:webvView animated:YES];
        }
        [NotiCenter postNotificationName:@"haveMessage" object:nil];
    }
}



//分享回掉
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url];
    if (!result) {
        // 其他如支付等SDK的回调
    }
    return result;
}




//3dtouch操作
- (void)application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void (^)(BOOL))completionHandler{
    UIViewController *pushViewController=[self getTopViewController:KeyWindow.rootViewController];
    if (pushViewController!=nil) {
        if ([shortcutItem.type isEqualToString:@"com.dajiabao.frend"]){
            BaseWebViewController *webvView=[[BaseWebViewController alloc]init];
            NSString *urlStr=[NSString stringWithFormat:@"%@%@",H5HOSTURL,@"/sns/wap/friend/index"];
            webvView.urlStr=urlStr;
            webvView.hidesBottomBarWhenPushed=YES;
            [pushViewController.navigationController pushViewController:webvView animated:NO];
        }else if ([shortcutItem.type isEqualToString:@"com.dajiabao.myMoney"]){
            if (![pushViewController isMemberOfClass:[MyMoneyController class]]) {
                MyMoneyController *moneyController=[[MyMoneyController alloc]init];
                moneyController.hidesBottomBarWhenPushed=YES;
                [pushViewController.navigationController pushViewController:moneyController animated:NO];
            }
        }else if ([shortcutItem.type isEqualToString:@"com.dajiabao.invite"]){
            BaseWebViewController *webvView=[[BaseWebViewController alloc]init];
            NSString *urlStr=[NSString stringWithFormat:@"%@%@",H5HOSTURL,inviteFrend];
            webvView.urlStr=urlStr;
            webvView.hidesBottomBarWhenPushed=YES;
            [pushViewController.navigationController pushViewController:webvView animated:NO];
        }
    }
    completionHandler?completionHandler(YES):nil;
}

//应用的根控制器
- (UIViewController *)getTopViewController:(UIViewController *)viewController {
    if ([UserDefaults boolForKey:@"firstLanch"]==NO) {
        //在启动页面
        return  nil;
    }else if([UserDefaults objectForKey:TOKENID]==nil){
        //在登录界面
        return  nil;
    }else{
        if ([viewController isKindOfClass:[UITabBarController class]]) {
            return [self getTopViewController:[(UITabBarController *)viewController selectedViewController]];
        } else if ([viewController isKindOfClass:[UINavigationController class]]) {
            return [self getTopViewController:[(UINavigationController *)viewController topViewController]];
        } else if (viewController.presentedViewController) {
            return [self getTopViewController:viewController.presentedViewController];
        } else {
            return viewController;
        }
    }
}



- (void)applicationWillResignActive:(UIApplication *)application {
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
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
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
