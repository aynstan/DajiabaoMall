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
        make.bottom.mas_equalTo(self.view).offset(0);
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
        make.top.mas_equalTo(15);
    }];
    
    //银行卡号
    UILabel *bankInfo=[[UILabel alloc]init];
    bankInfo.textColor=[UIColor colorWithHexString:@"#282828"];
    bankInfo.font=font15;
    bankInfo.text=@"银行卡 中国建设银行（尾号4029）";
    [headView addSubview:bankInfo];
    [bankInfo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.bottom.mas_equalTo(0);
        make.left.mas_equalTo(15);
    }];
    
    UIView *middleView=[[UIView alloc]init];
    middleView.backgroundColor=[UIColor whiteColor];
    [contentView addSubview:middleView];
    [middleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(GetHeight(150));
        make.top.mas_equalTo(headView.mas_bottom).offset(15);
    }];
    
    UILabel *bglabel=[[UILabel alloc]init];
    bglabel.backgroundColor=[UIColor colorWithHexString:@"ffeed2"];
    [middleView addSubview:bglabel];
    [bglabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0);
        make.height.mas_equalTo(50);
    }];
    
    //中间部分
    UILabel *maxMney=[[UILabel alloc]init];
    maxMney.textColor=[UIColor colorWithHexString:@"ff694a"];
    maxMney.font=font15;
    maxMney.text=@"该卡本次最高可提现100.0元";
    [middleView addSubview:maxMney];
    [maxMney mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.mas_equalTo(0);
        make.left.mas_equalTo(15);
        make.height.mas_equalTo(50);
    }];
    
    UILabel *line1=[[UILabel alloc]init];
    line1.backgroundColor=RGB(231, 231, 232);
    [middleView addSubview:line1];
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(maxMney.mas_bottom);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(0);
    }];
    
    UILabel *getMoney=[[UILabel alloc]init];
    getMoney.textColor=[UIColor colorWithHexString:@"#282828"];
    getMoney.font=font15;
    getMoney.text=@"提现金额";
    [middleView addSubview:getMoney];
    [getMoney mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(line1.mas_bottom);
        make.left.mas_equalTo(15);
        make.height.mas_equalTo(50);
    }];
    
    UILabel *yuan=[[UILabel alloc]init];
    yuan.textColor=[UIColor colorWithHexString:@"#282828"];
    yuan.font=font15;
    yuan.text=@"元";
    [middleView addSubview:yuan];
    [yuan mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(getMoney);
        make.right.mas_equalTo(-15);
        make.width.mas_equalTo(15);
    }];
    
    
    UITextField *moneyFiled=[[UITextField alloc]init];
    moneyFiled.placeholder=@"请输入提现金额";
    moneyFiled.textColor=[UIColor colorWithHexString:@"#595959"];
    moneyFiled.font=font15;
    [middleView addSubview:moneyFiled];
    [moneyFiled mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(getMoney.mas_right).offset(12);
        make.top.bottom.mas_equalTo(getMoney);
        make.right.mas_equalTo(yuan.mas_left).offset(-5);
    }];
    
    
    
    UILabel *line2=[[UILabel alloc]init];
    line2.backgroundColor=[UIColor colorWithHexString:@"#dcdcdc"];
    [middleView addSubview:line2];
    [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(getMoney.mas_bottom);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(0.5);
    }];
    
    UILabel *shouxifei=[[UILabel alloc]init];
    shouxifei.textColor=[UIColor colorWithHexString:@"#282828"];
    shouxifei.font=font15;
    shouxifei.text=@"手续费";
    [middleView addSubview:shouxifei];
    [shouxifei mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(line2.mas_bottom);
        make.bottom.mas_equalTo(0);
        make.left.mas_equalTo(15);
    }];
    
    UILabel *shouxifeijine=[[UILabel alloc]init];
    shouxifeijine.textColor=[UIColor colorWithHexString:@"#595959"];
    shouxifeijine.font=font15;
    shouxifeijine.text=@"100.00";
    [middleView addSubview:shouxifeijine];
    [shouxifeijine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(shouxifei);
        make.left.mas_equalTo(moneyFiled.mas_left);
    }];
    
    //确认提现
    UIButton *buttom=[UIButton buttonWithTitle:@"确认" titleColor:[UIColor whiteColor] font:font16 target:self action:@selector(tixianBegin:)];
    [buttom setBackgroundImage:[UIImage imageNamed:@"bt-normal"] forState:UIControlStateNormal];
    [buttom setBackgroundImage:[UIImage imageNamed:@"bt-Disable"] forState:UIControlStateDisabled];
    [buttom setBackgroundImage:[UIImage imageNamed:@"bt-click"] forState:UIControlStateHighlighted];
    buttom.enabled=NO;
    [contentView addSubview:buttom];
    [buttom mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(middleView.mas_bottom).offset(95);
        make.width.mas_equalTo(215);
        make.height.mas_equalTo(40);
        make.centerX.mas_equalTo(0);
    }];

    [contentView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(buttom.mas_bottom).offset(20);
    }];
    
    
    
    
}


//开始提现
- (void)tixianBegin:(UIButton *)sender{
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
