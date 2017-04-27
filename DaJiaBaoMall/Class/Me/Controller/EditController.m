//
//  EditController.m
//  DaJiaBaoMall
//
//  Created by 大家保 on 2017/3/31.
//  Copyright © 2017年 大家保. All rights reserved.
//

#import "EditController.h"
#import "MeModel.h"

@interface EditController (){
    UITextField *field;
    UIButton *save;
}

@end

@implementation EditController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addLeftButton];
    [self addTitle:self.titleStr];
    [self initUI];
}

- (void)initUI{
    UIView *WhiteView=[[UIView alloc]init];
    WhiteView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:WhiteView];
    [WhiteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(79);
        make.height.mas_equalTo(50);
    }];
    
    //输入框
    field=[[UITextField alloc]init];
    field.placeholder=self.placeHorderStr;
    field.textColor=[UIColor colorWithHexString:@"#595959"];
    field.font=font15;
    field.text=self.fieldText;
    field.clearButtonMode=UITextFieldViewModeWhileEditing;
    [field addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
    [WhiteView addSubview:field];
    [field mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.bottom.mas_equalTo(0);
        make.right.mas_equalTo(-15);
    }];
    
    UILabel *subLabel=[[UILabel alloc]init];
    subLabel.text=self.subTitleStr;
    subLabel.textColor=[UIColor colorWithHexString:@"#595959"];
    subLabel.font=font13;
    subLabel.numberOfLines=0;
    [self.view addSubview:subLabel];
    [subLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.top.mas_equalTo(WhiteView.mas_bottom).offset(8);
    }];
    
    save=[[UIButton alloc]init];
    [self.view addSubview:save];
    [save setBackgroundImage:[UIImage imageNamed:@"bt-normal"] forState:UIControlStateNormal];
    [save setBackgroundImage:[UIImage imageNamed:@"bt-Disable"] forState:UIControlStateDisabled];
    [save setBackgroundImage:[UIImage imageNamed:@"bt-click"] forState:UIControlStateHighlighted];
    save.enabled=NO;
    [save setTitle:@"保存" forState:0];
    [save setTitleColor:[UIColor whiteColor] forState:0];
    [save addTarget:self action:@selector(save:) forControlEvents:UIControlEventTouchUpInside];
    [save mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(subLabel.mas_bottom).offset(120);
        make.centerX.mas_equalTo(0);
        make.width.mas_equalTo(210);
        make.height.mas_equalTo(40);
    }];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [field becomeFirstResponder];
}

//保存修改
- (void)save:(UIButton *)button{
    MeModel *meModel=[self getMeModelMessage];
    NSString *url=[NSString stringWithFormat:@"%@%@",APPHOSTURL,changeMeInfo];
    NSDictionary *dic;
    if ([self.titleStr isEqualToString:@"名片昵称"]) {
        dic=@{@"name":[self clearSpace:field.text],@"company":meModel.company,@"position":meModel.position};
    }else if ([self.titleStr isEqualToString:@"公司"]){
        dic=@{@"name":meModel.name,@"company":[self clearSpace:field.text],@"position":meModel.position};
    }else if ([self.titleStr isEqualToString:@"职务"]){
        dic=@{@"name":meModel.name,@"company":meModel.company,@"position":[self clearSpace:field.text]};
    }
    [XWNetworking postJsonWithUrl:url params:dic success:^(id response) {
        if (response) {
            NSInteger statusCode=[response integerForKey:@"code"];
            if (statusCode==0) {
                NSString *errorMsg=[response stringForKey:@"message"];
                [MBProgressHUD ToastInformation:errorMsg];
            }else if (statusCode==1){
                if ([self.titleStr isEqualToString:@"名片昵称"]) {
                    meModel.name=[self clearSpace:field.text];
                }else if ([self.titleStr isEqualToString:@"公司"]){
                    meModel.company=[self clearSpace:field.text];
                }else if ([self.titleStr isEqualToString:@"职务"]){
                    meModel.position=[self clearSpace:field.text];
                }
                [self saveMeModelMessage:meModel];
                self.BackBlock?self.BackBlock(field.text):nil;
                [self.navigationController popViewControllerAnimated:YES];
                [MBProgressHUD showSuccess:@"修改成功"];
            }
        }
    } fail:^(NSError *error) {
        if ([XWNetworking isHaveNetwork]) {
            [MBProgressHUD ToastInformation:@"服务器开小差了"];
        }else{
            [MBProgressHUD ToastInformation:@"网络似乎已断开..."];
        }
    } showHud:YES];
}

#pragma mark - 输入框改变事件
/** 输入框内容发生改变 */
- (void)textFieldChanged:(UITextField *)textField {
    if ([self.titleStr isEqualToString:@"名片昵称"]) {
        //  限制输入框的输入长度为100
        if (textField.text.length >= 10 && textField.markedTextRange==nil ) {
            textField.text = [textField.text substringToIndex:10];
        }
    }else if ([self.titleStr isEqualToString:@"公司"]){
        //  限制输入框的输入长度为100
        if (textField.text.length >= 60 && textField.markedTextRange==nil ) {
            textField.text = [textField.text substringToIndex:60];
        }
    }else if ([self.titleStr isEqualToString:@"职务"]){
        //  限制输入框的输入长度为100
        if (textField.text.length >= 40 && textField.markedTextRange==nil ) {
            textField.text = [textField.text substringToIndex:40];
        }
    }
    
    save.enabled = ([self clearSpace:textField.text].length && [[self clearSpace:textField.text] isEqualToString:self.fieldText]==NO);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

/**
 *  友盟统计页面打开开始时间
 *
 */
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"编辑资料"];
}
/**
 *  友盟统计页面关闭时间
 *
 */
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"编辑资料"];
}



@end
