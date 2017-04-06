//
//  MyMoneyController.m
//  DaJiaBaoMall
//
//  Created by 大家保 on 2017/3/30.
//  Copyright © 2017年 大家保. All rights reserved.
//

#import "MyMoneyController.h"
#import "MyMoneyDetailController.h"
#import "GetMoneyController.h"
#import "AddOrChangeBankController.h"

@interface MyMoneyController ()

@end

@implementation MyMoneyController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addTitle:@"我的钱包"];
    [self addLeftButton];
    [self addRightButtonWithImageName:@"会员头像"];
    [self initUI];
}

//使用说明
- (void)forward:(UIButton *)button{
    
}

//界面搭建
- (void)initUI{
    
    UIScrollView *myScroolerView=[[UIScrollView alloc]init];
    myScroolerView.showsVerticalScrollIndicator=NO;
    myScroolerView.showsHorizontalScrollIndicator=NO;
    myScroolerView.backgroundColor=[UIColor clearColor];
    [self.view addSubview:myScroolerView];
    [myScroolerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.view).offset(-70);
        make.top.mas_equalTo(self.view).offset(64);
        make.width.mas_equalTo(SCREEN_WIDTH);
    }];

    
    UIView *contentView=[[UIView alloc]init];
    contentView.backgroundColor=[UIColor clearColor];
    [myScroolerView addSubview:contentView];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.top.mas_equalTo(myScroolerView);
        make.width.mas_equalTo(SCREEN_WIDTH);
    }];
    
    UIView *headView=[[UIView alloc]init];
    headView.backgroundColor=[UIColor blueColor];
    [contentView addSubview:headView];
    [headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.height.mas_equalTo(200);
        make.width.mas_equalTo(SCREEN_WIDTH);
    }];
    
    UILabel *zhanghu=[[UILabel alloc]init];
    zhanghu.text=@"账户余额（元）";
    zhanghu.textColor=[UIColor whiteColor];
    [headView addSubview:zhanghu];
    [zhanghu mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(20);
    }];
    
    UILabel *yue=[[UILabel alloc]init];
    yue.text=@"¥10020.01";
    yue.font=font32;
    yue.textColor=[UIColor whiteColor];
    [headView addSubview:yue];
    [yue mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(zhanghu.mas_bottom).offset(20);
    }];
    
    
    UILabel *nowMonth=[[UILabel alloc]init];
    nowMonth.text=@"本月收入（元）";
    nowMonth.font=font15;
    nowMonth.textAlignment=NSTextAlignmentCenter;
    nowMonth.textColor=[UIColor whiteColor];
    [headView addSubview:nowMonth];
    [nowMonth mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(SCREEN_WIDTH/2.0);
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(yue.mas_bottom).offset(20);
    }];
    
    UILabel *nowMonthMoney=[[UILabel alloc]init];
    nowMonthMoney.text=@"¥100.01";
    nowMonthMoney.font=font15;
    nowMonthMoney.textAlignment=NSTextAlignmentCenter;
    nowMonthMoney.textColor=[UIColor whiteColor];
    [headView addSubview:nowMonthMoney];
    [nowMonthMoney mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(SCREEN_WIDTH/2.0);
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(nowMonth.mas_bottom).offset(10);
    }];
    
    UILabel *allMonth=[[UILabel alloc]init];
    allMonth.text=@"累计收入（元）";
    allMonth.font=font15;
    allMonth.textAlignment=NSTextAlignmentCenter;
    allMonth.textColor=[UIColor whiteColor];
    [headView addSubview:allMonth];
    [allMonth mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(SCREEN_WIDTH/2.0);
        make.left.mas_equalTo(SCREEN_WIDTH/2.0);
        make.top.mas_equalTo(yue.mas_bottom).offset(20);
    }];
    
    UILabel *allMonthMoney=[[UILabel alloc]init];
    allMonthMoney.text=@"¥100.01";
    allMonthMoney.font=font15;
    allMonthMoney.textAlignment=NSTextAlignmentCenter;
    allMonthMoney.textColor=[UIColor whiteColor];
    [headView addSubview:allMonthMoney];
    [allMonthMoney mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(SCREEN_WIDTH/2.0);
        make.left.mas_equalTo(SCREEN_WIDTH/2.0);
        make.top.mas_equalTo(nowMonth.mas_bottom).offset(10);
    }];
    
    
    UIButton *mingxi=[[UIButton alloc]init];
    [mingxi setTitle:@"钱包明细" forState:0];
    [mingxi addTarget:self action:@selector(detail:) forControlEvents:UIControlEventTouchUpInside];
    [mingxi setTitleColor:[UIColor blackColor] forState:0];
    [mingxi setBackgroundColor:[UIColor whiteColor]];
    [contentView addSubview:mingxi];
    [mingxi mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(50);
        make.top.mas_equalTo(headView.mas_bottom).offset(10);
    }];
    
    
    
    UIView *bankView=[[UIView alloc]init];
    [bankView setBackgroundColor:[UIColor whiteColor]];
    [contentView addSubview:bankView];
    [bankView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(mingxi.mas_bottom).offset(10);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(150);
    }];
    
    
    UIImageView *bankLogo=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"会员头像"]];
    [bankView addSubview:bankLogo];
    [bankLogo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(20);
        make.width.mas_equalTo(200);
        make.height.mas_equalTo(50);
    }];
    
    UIImageView *renzhengLogo=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"会员头像"]];
    [bankView addSubview:renzhengLogo];
    [renzhengLogo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(50);
    }];
    
    UILabel *bankNum=[[UILabel alloc]init];
    bankNum.text=@"6217 0*** **** ***4 0989";
    bankNum.font=font15;
    bankNum.textAlignment=NSTextAlignmentCenter;
    bankNum.textColor=[UIColor blackColor];
    [bankView addSubview:bankNum];
    [bankNum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(bankLogo.mas_bottom).offset(10);
    }];
    
    UILabel *seperateLine=[[UILabel alloc]init];
    seperateLine.backgroundColor=RGB(231, 231, 232);
    [bankView addSubview:seperateLine];
    [seperateLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(0.5);
        make.top.mas_equalTo(bankNum.mas_bottom).offset(20);
    }];
    
    UIButton *bankPhone=[[UIButton alloc]init];
    [bankPhone setTitle:@"银行客服电话：95533" forState:0];
    [bankPhone setTitleColor:[UIColor darkGrayColor] forState:0];
    [bankPhone.titleLabel setFont:font12];
    [bankPhone addTarget:self action:@selector(callBankPhone:) forControlEvents:UIControlEventTouchUpInside];
    [bankView addSubview:bankPhone];
    [bankPhone mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(12);
        make.top.mas_equalTo(seperateLine.mas_bottom);
        make.bottom.mas_equalTo(0);
    }];
    
    UIButton *changeBankNum=[[UIButton alloc]init];
    [changeBankNum setTitle:@"修改" forState:0];
    [changeBankNum setTitleColor:[UIColor blueColor] forState:0];
    [changeBankNum.titleLabel setFont:font12];
    [changeBankNum addTarget:self action:@selector(changeBankNum:) forControlEvents:UIControlEventTouchUpInside];
    [changeBankNum setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [bankView addSubview:changeBankNum];
    [changeBankNum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-12);
        make.top.mas_equalTo(seperateLine.mas_bottom);
        make.bottom.mas_equalTo(0);
        make.width.mas_equalTo(100);
    }];
    
    
    [contentView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(bankView.mas_bottom);
    }];
    
    
    UIView *bottomView=[[UIView alloc]init];
    bottomView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(70);
        make.bottom.mas_equalTo(0);
    }];
    
    
    UIButton *tixianButton=[[UIButton alloc]init];
    [tixianButton setTitle:@"提现" forState:0];
    [tixianButton setTitleColor:[UIColor blueColor] forState:0];
    [tixianButton.titleLabel setFont:font17];
    tixianButton.layer.cornerRadius=10;
    tixianButton.layer.borderColor=[UIColor blueColor].CGColor;
    tixianButton.borderWidth=0.5;
    [tixianButton addTarget:self action:@selector(tixian:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:tixianButton];
    [tixianButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-20);
        make.centerY.mas_equalTo(0);
        make.left.mas_equalTo(20);
    }];
}

//体现
- (void)tixian:(UIButton *)sender{
    GetMoneyController *get=[[GetMoneyController alloc]init];
    get.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:get animated:YES];
}

//银行客服电话
- (void)callBankPhone:(UIButton *)sender{
    
}

//修改银行卡号
- (void)changeBankNum:(UIButton *)sender{
    AddOrChangeBankController *addOrChange=[[AddOrChangeBankController alloc]init];
    addOrChange.titleStr=@"更改银行卡";
    addOrChange.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:addOrChange animated:YES];
}

//钱包明细
- (void)detail:(UIButton *)sender{
    MyMoneyDetailController  *detail=[[MyMoneyDetailController alloc]init];
    detail.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:detail animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
