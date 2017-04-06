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
    webView.urlStr=@"http://www.baidu.com";
    webView.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:webView animated:YES];
}

//交流反馈
- (IBAction)fankui:(id)sender {
    BaseWebViewController *webView=[[BaseWebViewController alloc]init];
    webView.urlStr=@"http://www.baidu.com";
    webView.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:webView animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



@end
