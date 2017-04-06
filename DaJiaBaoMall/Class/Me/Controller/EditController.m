//
//  EditController.m
//  DaJiaBaoMall
//
//  Created by 大家保 on 2017/3/31.
//  Copyright © 2017年 大家保. All rights reserved.
//

#import "EditController.h"

@interface EditController (){
    UITextField *field;
}

@end

@implementation EditController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addLeftButton];
    [self addRightButton:@"保存"];
    [self addTitle:self.titleStr];
    [self initUI];
}

- (void)initUI{
    UIView *WhiteView=[[UIView alloc]init];
    WhiteView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:WhiteView];
    [WhiteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(74);
        make.height.mas_equalTo(50);
    }];
    
    //输入框
    field=[[UITextField alloc]init];
    field.placeholder=self.placeHorderStr;
    field.textColor=[UIColor blackColor];
    field.font=font15;
    [field becomeFirstResponder];
    field.clearButtonMode=UITextFieldViewModeWhileEditing;
    [WhiteView addSubview:field];
    [field mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12);
        make.top.bottom.mas_equalTo(0);
        make.right.mas_equalTo(-12);
    }];
    
    UILabel *subLabel=[[UILabel alloc]init];
    subLabel.text=self.subTitleStr;
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

- (void)forward:(UIButton *)button{
    self.BackBlock?self.BackBlock(field.text):nil;
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



@end
