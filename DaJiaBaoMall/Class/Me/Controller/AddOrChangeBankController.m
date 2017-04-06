//
//  AddOrChangeBankController.m
//  DaJiaBaoMall
//
//  Created by 大家保 on 2017/3/31.
//  Copyright © 2017年 大家保. All rights reserved.
//

#import "AddOrChangeBankController.h"
#import "BankListController.h"

@interface AddOrChangeBankController (){
    UILabel *bankNum;
}

@end

@implementation AddOrChangeBankController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addTitle:self.titleStr];
    [self addLeftButton];
    [self initUI];
}

//页面初始化
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
    
    UILabel *peopleMessage=[[UILabel alloc]init];
    peopleMessage.textColor=[UIColor blackColor];
    peopleMessage.font=font15;
    peopleMessage.text=@"持卡人信息";
    [contentView addSubview:peopleMessage];
    [peopleMessage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(12);
        make.height.mas_equalTo(50);
    }];
    
    UIView *headView=[[UIView alloc]init];
    headView.backgroundColor=[UIColor whiteColor];
    [contentView addSubview:headView];
    [headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(GetHeight(100));
        make.top.mas_equalTo(peopleMessage.mas_bottom);
    }];
    
    //姓名
    UILabel *peopleName=[[UILabel alloc]init];
    peopleName.textColor=[UIColor darkGrayColor];
    peopleName.font=font15;
    peopleName.text=@"姓名";
    [headView addSubview:peopleName];
    [peopleName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(12);
        make.height.mas_equalTo(50);
    }];
    
    UITextField *nameFiled=[[UITextField alloc]init];
    nameFiled.placeholder=@"请输入真实姓名";
    nameFiled.textColor=[UIColor blackColor];
    nameFiled.font=font15;
    [headView addSubview:nameFiled];
    [nameFiled mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(80);
        make.top.bottom.mas_equalTo(peopleName);
        make.right.mas_equalTo(-12);
    }];
    
    UILabel *lineUp=[[UILabel alloc]init];
    lineUp.backgroundColor=RGB(231, 231, 232);
    [headView addSubview:lineUp];
    [lineUp mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12);
        make.centerY.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(0.5);
    }];
    
    
    UILabel *IDCardNumber=[[UILabel alloc]init];
    IDCardNumber.textColor=[UIColor darkGrayColor];
    IDCardNumber.font=font15;
    IDCardNumber.text=@"身份证";
    [headView addSubview:IDCardNumber];
    [IDCardNumber mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(lineUp.mas_bottom);
        make.left.mas_equalTo(12);
        make.bottom.mas_equalTo(0);
    }];
    
    UITextField *IDCardFiled=[[UITextField alloc]init];
    IDCardFiled.placeholder=@"与银行卡户主身份证号一致";
    IDCardFiled.textColor=[UIColor blackColor];
    IDCardFiled.font=font15;
    [headView addSubview:IDCardFiled];
    [IDCardFiled mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(80);
        make.top.bottom.mas_equalTo(IDCardNumber);
        make.right.mas_equalTo(-12);
    }];

    
    
    
    UILabel *bankMessage=[[UILabel alloc]init];
    bankMessage.textColor=[UIColor blackColor];
    bankMessage.font=font15;
    bankMessage.text=@"银行卡信息（请务必使用与持卡人信息一致的储蓄卡）";
    [contentView addSubview:bankMessage];
    [bankMessage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(headView.mas_bottom);
        make.left.mas_equalTo(12);
        make.height.mas_equalTo(50);
    }];

    
    UIView *middleView=[[UIView alloc]init];
    middleView.backgroundColor=[UIColor whiteColor];
    [contentView addSubview:middleView];
    [middleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(GetHeight(100));
        make.top.mas_equalTo(bankMessage.mas_bottom);
    }];
    
    //银行卡信息
    UIButton *getBank=[[UIButton alloc]init];
    [getBank setTitle:@"银行" forState:0];
    [getBank setTitleColor:[UIColor darkGrayColor] forState:0];
    [getBank.titleLabel setFont:font15];
    [getBank addTarget:self action:@selector(selectedBankName:) forControlEvents:UIControlEventTouchUpInside];
    [getBank setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [getBank setContentEdgeInsets:UIEdgeInsetsMake(0, 12, 0, 0)];
    [middleView addSubview:getBank];
    [getBank mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(50);
        make.top.mas_equalTo(0);
    }];
    
    bankNum=[[UILabel alloc]init];
    bankNum.textColor=[UIColor lightGrayColor];
    bankNum.font=font15;
    bankNum.textAlignment=NSTextAlignmentLeft;
    bankNum.text=@"请选择银行";
    [getBank addSubview:bankNum];
    [bankNum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(getBank.mas_left).offset(55);
        make.right.mas_equalTo(-100);
        make.top.bottom.mas_equalTo(0);
    }];
    
    UIImageView *rigthImageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"forward"]];
    rigthImageView.contentMode=UIViewContentModeScaleAspectFit;
    [getBank addSubview:rigthImageView];
    [rigthImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.right.mas_equalTo(-12);
    }];
    
    
    UILabel *line1=[[UILabel alloc]init];
    line1.backgroundColor=RGB(231, 231, 232);
    [middleView addSubview:line1];
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12);
        make.top.mas_equalTo(getBank.mas_bottom);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(0.5);
    }];
    
    UILabel *bankNumber=[[UILabel alloc]init];
    bankNumber.textColor=[UIColor darkGrayColor];
    bankNumber.font=font15;
    bankNumber.text=@"卡号";
    [middleView addSubview:bankNumber];
    [bankNumber mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(line1.mas_bottom);
        make.left.mas_equalTo(12);
        make.bottom.mas_equalTo(0);
    }];
    
    UITextField *bankFiled=[[UITextField alloc]init];
    bankFiled.placeholder=@"请输入银行卡号";
    bankFiled.textColor=[UIColor blackColor];
    bankFiled.font=font15;
    [middleView addSubview:bankFiled];
    [bankFiled mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(bankNumber.mas_right).offset(12);
        make.top.bottom.mas_equalTo(bankNumber);
        make.right.mas_equalTo(-12);
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
    UIButton *buttom=[UIButton buttonWithTitle:@"确认" titleColor:[UIColor blueColor] font:font17 target:self action:@selector(queren:)];
    [bottomView addSubview:buttom];
    [buttom mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];

}

//选择银行
- (void)selectedBankName:(UIButton *)sender{
    BankListController *list=[[BankListController alloc]init];
    list.hidesBottomBarWhenPushed=YES;
    list.BankNameBlock=^(NSString *bankName){
        bankNum.text=bankName;
        bankNum.textColor=[UIColor blackColor];
    };
    [self.navigationController pushViewController:list animated:YES];
}

//确认
- (void)queren:(UIButton *)sender{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



@end
