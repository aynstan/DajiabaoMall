//
//  GetMoneyController.m
//  DaJiaBaoMall
//
//  Created by 大家保 on 2017/3/31.
//  Copyright © 2017年 大家保. All rights reserved.
//

#import "GetMoneyController.h"

@interface GetMoneyController ()

@end

@implementation GetMoneyController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addTitle:@"提现"];
    [self addLeftButton];
    [self initUI];
}

//ui布局
- (void)initUI{
    UIScrollView *myScroolerView=[[UIScrollView alloc]init];
    myScroolerView.showsVerticalScrollIndicator=NO;
    myScroolerView.showsHorizontalScrollIndicator=NO;
    myScroolerView.backgroundColor=[UIColor clearColor];
    [self.view addSubview:myScroolerView];
    [myScroolerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.view).offset(-50);
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
    headView.backgroundColor=[UIColor whiteColor];
    [contentView addSubview:headView];
    [headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(GetHeight(50));
        make.top.mas_equalTo(10);
    }];
    
    //银行卡号
    UILabel *bankInfo=[[UILabel alloc]init];
    bankInfo.textColor=[UIColor darkGrayColor];
    bankInfo.font=font15;
    bankInfo.text=@"银行卡 中国建设银行（尾号4029）";
    [headView addSubview:bankInfo];
    [bankInfo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.bottom.mas_equalTo(0);
        make.left.mas_equalTo(12);
    }];
    
    UIView *middleView=[[UIView alloc]init];
    middleView.backgroundColor=[UIColor whiteColor];
    [contentView addSubview:middleView];
    [middleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(GetHeight(150));
        make.top.mas_equalTo(headView.mas_bottom).offset(10);
    }];
    
    //中间部分
    UILabel *maxMney=[[UILabel alloc]init];
    maxMney.textColor=[UIColor darkGrayColor];
    maxMney.font=font15;
    maxMney.text=@"该卡本次最高可提现100.0元";
    [middleView addSubview:maxMney];
    [maxMney mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.mas_equalTo(0);
        make.left.mas_equalTo(12);
        make.height.mas_equalTo(50);
    }];
    
    UILabel *line1=[[UILabel alloc]init];
    line1.backgroundColor=RGB(231, 231, 232);
    [middleView addSubview:line1];
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12);
        make.top.mas_equalTo(maxMney.mas_bottom);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(0.5);
    }];
    
    UILabel *getMoney=[[UILabel alloc]init];
    getMoney.textColor=[UIColor darkGrayColor];
    getMoney.font=font15;
    getMoney.text=@"提现金额";
    [middleView addSubview:getMoney];
    [getMoney mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(line1.mas_bottom);
        make.left.mas_equalTo(12);
        make.height.mas_equalTo(50);
    }];
    
    
    
    UITextField *moneyFiled=[[UITextField alloc]init];
    moneyFiled.placeholder=@"请输入提现金额";
    moneyFiled.textColor=[UIColor blackColor];
    moneyFiled.font=font15;
    [middleView addSubview:moneyFiled];
    [moneyFiled mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(getMoney.mas_right).offset(12);
        make.top.bottom.mas_equalTo(getMoney);
        make.width.mas_equalTo(150);
    }];
    
    UILabel *yuan=[[UILabel alloc]init];
    yuan.textColor=[UIColor darkGrayColor];
    yuan.font=font15;
    yuan.text=@"元";
    [middleView addSubview:yuan];
    [yuan mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(getMoney);
        make.left.mas_equalTo(moneyFiled.mas_right).offset(12);
    }];
    
    UILabel *line2=[[UILabel alloc]init];
    line2.backgroundColor=RGB(231, 231, 232);
    [middleView addSubview:line2];
    [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12);
        make.top.mas_equalTo(getMoney.mas_bottom);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(0.5);
    }];
    
    UILabel *shouxifei=[[UILabel alloc]init];
    shouxifei.textColor=[UIColor darkGrayColor];
    shouxifei.font=font15;
    shouxifei.text=@"手续费";
    [middleView addSubview:shouxifei];
    [shouxifei mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(line2.mas_bottom);
        make.bottom.mas_equalTo(0);
        make.left.mas_equalTo(12);
    }];
    
    UILabel *shouxifeijine=[[UILabel alloc]init];
    shouxifeijine.textColor=[UIColor blackColor];
    shouxifeijine.font=font15;
    shouxifeijine.text=@"100.00";
    [middleView addSubview:shouxifeijine];
    [shouxifeijine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(shouxifei);
        make.left.mas_equalTo(moneyFiled.mas_left);
    }];

    [contentView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(middleView.mas_bottom).offset(10);
    }];
    
    UIView *bottomView=[[UIView alloc]init];
    bottomView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(GetHeight(50));
        make.bottom.mas_equalTo(0);
    }];
    
    //确认提现
    UIButton *buttom=[UIButton buttonWithTitle:@"确认" titleColor:[UIColor blueColor] font:font17 target:self action:@selector(tixianBegin:)];
    [bottomView addSubview:buttom];
    [buttom mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
}


//开始提现
- (void)tixianBegin:(UIButton *)sender{
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
