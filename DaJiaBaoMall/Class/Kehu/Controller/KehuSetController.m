//
//  KehuSetController.m
//  DaJiaBaoMall
//
//  Created by 大家保 on 2017/3/31.
//  Copyright © 2017年 大家保. All rights reserved.
//

#import "KehuSetController.h"

@interface KehuSetController ()

@end

@implementation KehuSetController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addTitle:@"客户设置"];
    [self addLeftButton];
    [self initUI];
}

//初始化布局
- (void)initUI{
    UIView *headView=[[UIView alloc]init];
    headView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:headView];
    [headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(74);
        make.height.mas_equalTo(150);
    }];
    
    
    UILabel *tuiguangfei=[[UILabel alloc]init];
    tuiguangfei.textColor=[UIColor blackColor];
    tuiguangfei.font=font15;
    tuiguangfei.text=@"客户阅读文章需要授权";
    [headView addSubview:tuiguangfei];
    [tuiguangfei mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(12);
        make.height.mas_equalTo(50);
    }];
    
    UISwitch *tuiguangSwitch=[[UISwitch alloc]init];
    tuiguangSwitch.on=YES;
    [headView addSubview:tuiguangSwitch];
    [tuiguangSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-12);
        make.centerY.mas_equalTo(tuiguangfei);
    }];
    
    UILabel *status=[[UILabel alloc]init];
    status.textColor=[UIColor darkGrayColor];
    status.font=font15;
    status.text=@"已开启";
    [headView addSubview:status];
    [status mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(tuiguangfei);
        make.right.mas_equalTo(tuiguangSwitch.mas_left).offset(-12);
    }];
    
    UILabel *line1=[[UILabel alloc]init];
    line1.backgroundColor=RGB(231, 231, 232);
    [headView addSubview:line1];
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12);
        make.top.mas_equalTo(tuiguangfei.mas_bottom);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(0.5);
    }];
    
    UILabel *message=[[UILabel alloc]init];
    message.textColor=[UIColor blackColor];
    message.font=font15;
    message.text=@"客户阅读产品需要授权";
    [headView addSubview:message];
    [message mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(line1.mas_bottom);
        make.height.mas_equalTo(50);
        make.left.mas_equalTo(12);
    }];
    
    UISwitch *messageSwitch=[[UISwitch alloc]init];
    messageSwitch.on=YES;
    [headView addSubview:messageSwitch];
    [messageSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-12);
        make.centerY.mas_equalTo(message);
    }];
    
    UILabel *messageStatus=[[UILabel alloc]init];
    messageStatus.textColor=[UIColor darkGrayColor];
    messageStatus.font=font15;
    messageStatus.text=@"已开启";
    [headView addSubview:messageStatus];
    [messageStatus mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(message);
        make.right.mas_equalTo(messageSwitch.mas_left).offset(-12);
    }];
    
    UILabel *line2=[[UILabel alloc]init];
    line2.backgroundColor=RGB(231, 231, 232);
    [headView addSubview:line2];
    [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12);
        make.top.mas_equalTo(message.mas_bottom);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(0.5);
    }];
    
    UILabel *zengxian=[[UILabel alloc]init];
    zengxian.textColor=[UIColor blackColor];
    zengxian.font=font15;
    zengxian.text=@"客户阅读赠险需要授权";
    [headView addSubview:zengxian];
    [zengxian mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(line2.mas_bottom);
        make.bottom.mas_equalTo(0);
        make.left.mas_equalTo(12);
    }];
    
    UISwitch *zengxianSwitch=[[UISwitch alloc]init];
    zengxianSwitch.on=YES;
    [headView addSubview:zengxianSwitch];
    [zengxianSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-12);
        make.centerY.mas_equalTo(zengxian);
    }];
    
    UILabel *zengxianStatus=[[UILabel alloc]init];
    zengxianStatus.textColor=[UIColor darkGrayColor];
    zengxianStatus.font=font15;
    zengxianStatus.text=@"已开启";
    [headView addSubview:zengxianStatus];
    [zengxianStatus mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(zengxian);
        make.right.mas_equalTo(zengxianSwitch.mas_left).offset(-12);
    }];
    
    UILabel *showLine=[[UILabel alloc]init];
    showLine.text=@"什么是授权？\n\n选择授权后，微信好友查看您的分享，您可以获得他的微信昵称。您可以通过微信昵称和客户取得联系，促成成交。\n\n如不授权，微信好友查看您的分享后，您无法获得他的微信昵称。该名客户为游客状态。但如果客户通过您分享的链接下单购买产品，您同样可以获得推广费。\n\n客户只需在首次点击您的分享时确认授权，再次阅读无需授权。您可以再客户管理页面查看对方的浏览记录，了解他感兴趣的话题或产品。";
    showLine.textColor=[UIColor lightGrayColor];
    showLine.font=font13;
    showLine.numberOfLines=0;
    [self.view addSubview:showLine];
    [showLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12);
        make.right.mas_equalTo(-12);
        make.top.mas_equalTo(headView.mas_bottom).offset(12);
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
