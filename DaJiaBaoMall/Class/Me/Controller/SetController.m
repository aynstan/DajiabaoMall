//
//  SetController.m
//  DaJiaBaoMall
//
//  Created by 大家保 on 2017/3/31.
//  Copyright © 2017年 大家保. All rights reserved.
//

#import "SetController.h"

@interface SetController ()

@end

@implementation SetController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self  addTitle:@"设置"];
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
        make.height.mas_equalTo(100);
    }];
    
    
    UILabel *tuiguangfei=[[UILabel alloc]init];
    tuiguangfei.textColor=[UIColor blackColor];
    tuiguangfei.font=font15;
    tuiguangfei.text=@"推广费显示";
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
    message.text=@"消息显示";
    [headView addSubview:message];
    [message mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(line1.mas_bottom);
        make.bottom.mas_equalTo(0);
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
    
    
    UIButton *exiteButtom=[UIButton buttonWithTitle:@"退出登录" titleColor:[UIColor blueColor] font:font17 target:self action:@selector(exit:)];
    [exiteButtom setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:exiteButtom];
    [exiteButtom mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(headView.mas_bottom).offset(10);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(50);
    }];
}

//退出登录
- (void)exit:(UIButton *)sender{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



@end
