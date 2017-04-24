//
//  ConnectServiceViewController.m
//  BaobiaoDog
//
//  Created by 大家保 on 16/8/8.
//  Copyright © 2016年 大家保. All rights reserved.
//

#import "ConnectServiceViewController.h"
#import "IQKeyboardManager.h"

@implementation ConnectServiceViewController{
    UIView *timeView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets=NO;
    [self initContentView];
    CGRect rect=self.conversationMessageCollectionView.frame;
    rect.origin.y=64;
    rect.size.height=rect.size.height-64;
    self.conversationMessageCollectionView.frame=rect;
    self.enableUnreadMessageIcon=YES;
    
    timeView=[[UIView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 40)];
    timeView.backgroundColor=RGBA(0, 0, 0, 0.6);
    
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(12, 0, SCREEN_WIDTH-12-40, 40)];
    label.text=@"工作时间：9:30——18:00(周一至周五)";
    label.font=SystemFont(14);
    label.textColor=[UIColor whiteColor];
    [timeView addSubview:label];
    
    UIButton *closeButton=[[UIButton alloc]initWithFrame:CGRectMake(GetViewMaxX(timeView)-40, 0, 40, 40)];
    [closeButton setImage:[UIImage imageNamed:@"矩形_关闭"] forState:0];
    [closeButton addTarget:self action:@selector(closeTimeView) forControlEvents:UIControlEventTouchUpInside];
    [timeView addSubview:closeButton];
    
    [self.view addSubview:timeView];
    
    [UserDefaults setBool:NO forKey:@"haveUnredMsg"];
    [UserDefaults synchronize];
}

- (void)closeTimeView{
    for (UIView *view in [timeView subviews]) {
        [view removeFromSuperview];
    }
    [timeView removeFromSuperview];
    timeView=nil;
}

/**
 *  界面布局
 */
- (void)initContentView{
    
    UIView *naviBarView= [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
    naviBarView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:naviBarView];
    
    UIButton *leftButton=[[UIButton alloc]initWithFrame:CGRectMake(0, 20, 44, 44)];
    [leftButton setImage:[UIImage imageNamed:@"return-arr"] forState:0];
    [leftButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:leftButton];
    
    UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(60, 20, SCREEN_WIDTH-120, 43.5)];
    titleLabel.textColor=[UIColor colorWithHexString:@"#5c5c5c"];
    titleLabel.font=[UIFont systemFontOfSize:18];
    titleLabel.text=self.title;
    titleLabel.textAlignment=NSTextAlignmentCenter;
    
    UIView *line=[[UIView alloc]initWithFrame:CGRectMake(0, 63.5, SCREEN_WIDTH, 0.5)];
    line.backgroundColor=RGB(181, 175, 168);
    [self.view addSubview:line];
    [self.view addSubview:titleLabel];
}

- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [IQKeyboardManager sharedManager].enable = NO;
    [MobClick beginLogPageView:@"我的客服"];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"我的客服"];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [IQKeyboardManager sharedManager].enable = YES;
    [NotiCenter postNotificationName:@"noMessage" object:nil];
}


@end
