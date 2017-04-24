//
//  QMYBViewController.m
//  QMYB
//
//  Created by 大家保 on 2017/2/15.
//  Copyright © 2017年 大家保. All rights reserved.
//

#import "BaseTabBarController.h"
#import "BaseNavigationController.h"
#import "MainController.h"
#import "FindController.h"
#import "KehuController.h"
#import "MeController.h"
#import "LoginController.h"


@interface BaseTabBarController ()
//<UITabBarControllerDelegate>

@end

@implementation BaseTabBarController


+ (void)initialize {
    // 通过appearance统一设置所有的UIBarBarItem的文字属性
    // 后面带有UI_APPEARANCE_SELECTOR的方法，都可以用appearance对象来统一设置
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = SystemFont(10);
    attrs[NSForegroundColorAttributeName] = [UIColor colorWithHexString:@"#a4b0ab"];
    
    NSMutableDictionary *selectedAttrs = [NSMutableDictionary dictionary];
    selectedAttrs[NSFontAttributeName] = attrs[NSFontAttributeName];
    selectedAttrs[NSForegroundColorAttributeName] = [UIColor colorWithHexString:@"#ff693a"];
    
    UITabBarItem *item = [UITabBarItem appearance];
    [item setTitleTextAttributes:attrs forState:UIControlStateNormal];
    [item setTitleTextAttributes:selectedAttrs forState:UIControlStateSelected];
    
    UITabBar *bar=[UITabBar appearance];
    [bar setTintColor:[UIColor redColor]];
    [bar setBarTintColor:[UIColor whiteColor]];
    [bar setTranslucent:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //self.delegate=self;
    // 添加子控制器
    [self setupChildVc:[[MainController alloc] init] title:@"首页" image:@"首页-normal" selectedImage:@"首页-click"];
    
    [self setupChildVc:[[FindController alloc] init] title:@"获客" image:@"获客-normal-" selectedImage:@"获客-click"];
    
    [self setupChildVc:[[KehuController alloc] init] title:@"客户" image:@"客户－normal" selectedImage:@"客户-click"];
    
    [self setupChildVc:[[MeController alloc] init] title:@"额滴" image:@"my-normal-" selectedImage:@"my-click"];
}

/**
 *  初始化控制器
 */
- (void)setupChildVc:(UIViewController *)vc title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage {
    // 设置文字图片
    vc.tabBarItem.title = title;
    vc.tabBarItem.image = [[UIImage imageNamed:image] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    vc.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    vc.tabBarItem.titlePositionAdjustment=UIOffsetMake(0, 0);
    // 包装一个导航控制器，添加导航控制器为tabBarController的子控制器
    BaseNavigationController *nav = [[BaseNavigationController alloc]initWithRootViewController:vc];
    [self addChildViewController:nav];
}

//拦截tabbarController的点击事件
//- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{
//    if ([tabBarController.viewControllers indexOfObject:viewController]==2) {
//        LoginController *login=[[LoginController alloc]init];
//        [self presnetXWViewController:login withOptions:nil completion:^{
//            
//        } dissmissBlock:^{
//            
//        }];
//        return NO;
//    }else{
//        return YES;
//    }
//}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
