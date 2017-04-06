//
//  ShimingRenzhengController.m
//  DaJiaBaoMall
//
//  Created by 大家保 on 2017/3/31.
//  Copyright © 2017年 大家保. All rights reserved.
//

#import "ShimingRenzhengController.h"

@interface ShimingRenzhengController ()

@end

@implementation ShimingRenzhengController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addTitle:@"实名认证"];
    [self addLeftButton];
    [self initUI];
}

//初始化ui
- (void)initUI{
    UIView *headView=[[UIView alloc]init];
    headView.backgroundColor=[UIColor clearColor];
    [self.view addSubview:headView];
    [headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(64);
        make.height.mas_equalTo(100);
    }];
    
    UIImageView *centerImageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"会员头像"]];
    [centerImageView setBackgroundColor:[UIColor redColor]];
    [headView addSubview:centerImageView];
    [centerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(0);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(1);
    }];
    
    UIImageView *leftImageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@""]];
    [leftImageView setBackgroundColor:[UIColor blueColor]];
    [headView addSubview:leftImageView];
    [leftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(40, 40));
        make.right.mas_equalTo(centerImageView.mas_left).offset(-12);
    }];

    
    UIImageView *rightImageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@""]];
    [rightImageView setBackgroundColor:[UIColor orangeColor]];
    [headView addSubview:rightImageView];
    [rightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(40, 40));
        make.left.mas_equalTo(centerImageView.mas_right).offset(12);
    }];
    
    
    UIView *middleView=[[UIView alloc]init];
    middleView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:middleView];
    [middleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(GetHeight(100));
        make.top.mas_equalTo(headView.mas_bottom);
    }];
    
    //姓名
    UILabel *peopleName=[[UILabel alloc]init];
    peopleName.textColor=[UIColor darkGrayColor];
    peopleName.font=font15;
    peopleName.text=@"姓名";
    [middleView addSubview:peopleName];
    [peopleName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(12);
        make.height.mas_equalTo(50);
    }];
    
    UITextField *nameFiled=[[UITextField alloc]init];
    nameFiled.placeholder=@"请输入真实姓名";
    nameFiled.textColor=[UIColor blackColor];
    nameFiled.font=font15;
    [middleView addSubview:nameFiled];
    [nameFiled mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(80);
        make.top.bottom.mas_equalTo(peopleName);
        make.right.mas_equalTo(-12);
    }];
    
    UILabel *line1=[[UILabel alloc]init];
    line1.backgroundColor=RGB(231, 231, 232);
    [middleView addSubview:line1];
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12);
        make.centerY.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(0.5);
    }];
    
    
    UILabel *IDCardNumber=[[UILabel alloc]init];
    IDCardNumber.textColor=[UIColor darkGrayColor];
    IDCardNumber.font=font15;
    IDCardNumber.text=@"身份证";
    [middleView addSubview:IDCardNumber];
    [IDCardNumber mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(line1.mas_bottom);
        make.left.mas_equalTo(12);
        make.bottom.mas_equalTo(0);
    }];
    
    UITextField *IDCardFiled=[[UITextField alloc]init];
    IDCardFiled.placeholder=@"与银行卡户主身份证号一致";
    IDCardFiled.textColor=[UIColor blackColor];
    IDCardFiled.font=font15;
    [middleView addSubview:IDCardFiled];
    [IDCardFiled mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(80);
        make.top.bottom.mas_equalTo(IDCardNumber);
        make.right.mas_equalTo(-12);
    }];
    
    UILabel *subLabel=[[UILabel alloc]init];
    subLabel.text=@"实名认证姓名需与绑定的银行卡户主姓名相同，届时推广费将会发至您填写的账户\n一旦提交不能修改，请您仔细填写";
    subLabel.textColor=[UIColor darkGrayColor];
    subLabel.font=font14;
    subLabel.numberOfLines=0;
    [self.view addSubview:subLabel];
    [subLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12);
        make.right.mas_equalTo(-12);
        make.top.mas_equalTo(middleView.mas_bottom).offset(10);
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
    [tixianButton setTitle:@"提交认证" forState:0];
    [tixianButton setTitleColor:[UIColor blueColor] forState:0];
    [tixianButton.titleLabel setFont:font17];
    tixianButton.layer.cornerRadius=10;
    tixianButton.layer.borderColor=[UIColor blueColor].CGColor;
    tixianButton.borderWidth=0.5;
    [tixianButton addTarget:self action:@selector(renzheng:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:tixianButton];
    [tixianButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-20);
        make.centerY.mas_equalTo(0);
        make.left.mas_equalTo(20);
    }];

}

- (void)renzheng:(UIButton *)sender{
    self.BackBlock?self.BackBlock(@"已认证"):nil;
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
