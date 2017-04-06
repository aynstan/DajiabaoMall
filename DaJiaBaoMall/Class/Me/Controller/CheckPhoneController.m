//
//  CheckPhoneController.m
//  DaJiaBaoMall
//
//  Created by 大家保 on 2017/3/31.
//  Copyright © 2017年 大家保. All rights reserved.
//

#import "CheckPhoneController.h"

@interface CheckPhoneController (){
    UITextField *field;
}

@end

@implementation CheckPhoneController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addTitle:@"手机号"];
    [self addLeftButton];
    [self initUI];
}

//初始化ui
- (void)initUI{
    UIView *WhiteView=[[UIView alloc]init];
    WhiteView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:WhiteView];
    [WhiteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(74);
        make.height.mas_equalTo(100);
    }];
    
    //输入框
    field=[[UITextField alloc]init];
    field.placeholder=@"请输入手机号";
    field.textColor=[UIColor blackColor];
    field.font=font15;
    [field becomeFirstResponder];
    field.clearButtonMode=UITextFieldViewModeWhileEditing;
    [WhiteView addSubview:field];
    [field mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12);
        make.top.mas_equalTo(0);
        make.right.mas_equalTo(-SCREEN_WIDTH/3.0);
        make.height.mas_equalTo(50);
    }];
    
    
    
    UIButton *codeButtom=[UIButton buttonWithTitle:@"获取验证码" titleColor:[UIColor whiteColor] font:font15 target:self action:@selector(getCode:)];
    [codeButtom setBackgroundColor:RGB(231, 231, 232)];
    [WhiteView addSubview:codeButtom];
    [codeButtom mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(field.mas_right).offset(12);
        make.right.mas_equalTo(-12);
        make.top.mas_equalTo(field).offset(10);
        make.bottom.mas_equalTo(field).offset(-10);
    }];
    
    UILabel *line=[[UILabel alloc]init];
    line.backgroundColor=RGB(231, 231, 232);
    [WhiteView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12);
        make.right.mas_equalTo(0);
        make.centerY.mas_equalTo(0);
        make.height.mas_equalTo(0.5);
    }];
    
    
    //输入框
    UITextField * codeField=[[UITextField alloc]init];
    codeField.placeholder=@"请输入验证码";
    codeField.textColor=[UIColor blackColor];
    codeField.font=font15;
    codeField.clearButtonMode=UITextFieldViewModeWhileEditing;
    [WhiteView addSubview:codeField];
    [codeField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12);
        make.bottom.mas_equalTo(0);
        make.right.mas_equalTo(-SCREEN_WIDTH/3.0);
        make.top.mas_equalTo(field.mas_bottom);
    }];
    
    UIButton *checkCode=[UIButton buttonWithTitle:@"提交验证" titleColor:[UIColor whiteColor] font:font15 target:self action:@selector(checkCode:)];
    [checkCode setBackgroundColor:[UIColor yellowColor]];
    [WhiteView addSubview:checkCode];
    [checkCode mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(codeField.mas_right).offset(12);
        make.right.mas_equalTo(-12);
        make.top.mas_equalTo(codeField).offset(10);
        make.bottom.mas_equalTo(codeField).offset(-10);
    }];
    
    UILabel *subLabel=[[UILabel alloc]init];
    subLabel.text=@"用户将通过此号码联系到您";
    subLabel.textColor=[UIColor darkGrayColor];
    subLabel.font=font14;
    subLabel.numberOfLines=0;
    [self.view addSubview:subLabel];
    [subLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12);
        make.right.mas_equalTo(-12);
        make.top.mas_equalTo(WhiteView.mas_bottom).offset(10);
    }];

}

//获取验证码
- (void)getCode:(UIButton *)sender{
}

//校验验证码
- (void)checkCode:(UIButton *)sender{
    self.BackBlock?self.BackBlock(field.text):nil;
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
