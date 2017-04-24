//
//  AboutUsController.m
//  DaJiaBaoMall
//
//  Created by 大家保 on 2017/3/30.
//  Copyright © 2017年 大家保. All rights reserved.
//

#import "AboutUsController.h"
#import "BaseWebViewController.h"

@interface AboutUsController ()

@end

@implementation AboutUsController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addTitle:@"关于我们"];
    [self addLeftButton];
    self.version.text=[NSString stringWithFormat:@"v%@",VERSION];
}

//大家保介绍
- (IBAction)jieshao:(id)sender {
    BaseWebViewController *webView=[[BaseWebViewController alloc]init];
    webView.urlStr=[NSString stringWithFormat:@"%@%@",H5HOSTURL,aboutus];
    webView.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:webView animated:YES];
}

//交流反馈
- (IBAction)fankui:(id)sender {
    BaseWebViewController *webView=[[BaseWebViewController alloc]init];
    webView.urlStr=[NSString stringWithFormat:@"%@%@",H5HOSTURL,aboutalk];
    webView.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:webView animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


/**
 *  友盟统计页面打开开始时间
 *
 */
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"关于我们"];
}
/**
 *  友盟统计页面关闭时间
 *
 */
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"关于我们"];
}


@end
