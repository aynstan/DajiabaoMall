//
//  ShimingRenzhengController.m
//  DaJiaBaoMall
//
//  Created by 大家保 on 2017/3/31.
//  Copyright © 2017年 大家保. All rights reserved.
//

#import "ShimingRenzhengController.h"
#import "MeModel.h"

@interface ShimingRenzhengController ()<UITextFieldDelegate>{
    UITextField *nameFiled;
    UITextField *IDCardFiled;
    UIButton *tixianButton;
}

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
    
    UIImageView *centerImageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"实名认证－bg"]];
    [centerImageView setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:centerImageView];
    [centerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(64);
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.height.mas_equalTo(SCREEN_WIDTH/375.0*75);
    }];
    
    
    
    UIView *middleView=[[UIView alloc]init];
    middleView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:middleView];
    [middleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(GetHeight(100));
        make.top.mas_equalTo(centerImageView.mas_bottom);
    }];
    
    //姓名
    UILabel *peopleName=[[UILabel alloc]init];
    peopleName.textColor=[UIColor colorWithHexString:@"#282828"];
    peopleName.font=font15;
    peopleName.text=@"姓名";
    [middleView addSubview:peopleName];
    [peopleName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(15);
        make.height.mas_equalTo(50);
    }];
    
    nameFiled=[[UITextField alloc]init];
    nameFiled.placeholder=@"请输入真实姓名";
    [nameFiled addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
    nameFiled.clearButtonMode=UITextFieldViewModeWhileEditing;
    nameFiled.textColor=[UIColor colorWithHexString:@"#595959"];
    nameFiled.font=font15;
    nameFiled.delegate=self;
    [middleView addSubview:nameFiled];
    [nameFiled mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(83);
        make.top.bottom.mas_equalTo(peopleName);
        make.right.mas_equalTo(-15);
    }];
    
    UILabel *line1=[[UILabel alloc]init];
    line1.backgroundColor=[UIColor colorWithHexString:@"dcdcdc"];
    [middleView addSubview:line1];
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.centerY.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(0.5);
    }];
    
    
    UILabel *IDCardNumber=[[UILabel alloc]init];
    IDCardNumber.textColor=[UIColor colorWithHexString:@"#282828"];
    IDCardNumber.font=font15;
    IDCardNumber.text=@"身份证";
    [middleView addSubview:IDCardNumber];
    [IDCardNumber mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(line1.mas_bottom);
        make.left.mas_equalTo(15);
        make.bottom.mas_equalTo(0);
    }];
    
    IDCardFiled=[[UITextField alloc]init];
    IDCardFiled.placeholder=@"与银行卡户主身份证号一致";
    IDCardFiled.textColor=[UIColor colorWithHexString:@"#595959"];
    IDCardFiled.font=font15;
    IDCardFiled.delegate=self;
    [IDCardFiled addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
    IDCardFiled.clearButtonMode=UITextFieldViewModeWhileEditing;
    [middleView addSubview:IDCardFiled];
    [IDCardFiled mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(83);
        make.top.bottom.mas_equalTo(IDCardNumber);
        make.right.mas_equalTo(-15);
    }];
    
    UILabel *subLabel=[[UILabel alloc]init];
    subLabel.text=@"实名认证姓名需与绑定的银行卡户主姓名相同，届时推广费将会发至您填写的账户\n一旦提交不能修改，请您仔细填写\n如信息有误，请致电400-111-4567";
    subLabel.textColor=[UIColor colorWithHexString:@"#595959"];
    subLabel.font=font12;
    subLabel.numberOfLines=0;
    [self.view addSubview:subLabel];
    [subLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.top.mas_equalTo(middleView.mas_bottom).offset(10);
    }];

    
    
    tixianButton=[[UIButton alloc]init];
    [tixianButton setTitle:@"提交认证" forState:0];
    [tixianButton setBackgroundImage:[UIImage imageNamed:@"bt-normal"] forState:UIControlStateNormal];
    [tixianButton setBackgroundImage:[UIImage imageNamed:@"bt-Disable"] forState:UIControlStateDisabled];
    [tixianButton setBackgroundImage:[UIImage imageNamed:@"bt-click"] forState:UIControlStateHighlighted];
    [tixianButton addTarget:self action:@selector(renzheng:) forControlEvents:UIControlEventTouchUpInside];
    tixianButton.enabled=NO;
    [self.view addSubview:tixianButton];
    [tixianButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(subLabel.mas_bottom).offset(45);
        make.centerX.mas_equalTo(0);
        make.width.mas_equalTo(210);
        make.height.mas_equalTo(40);
    }];
    
    [self setIQKeyBorderManager];

}

//认证
- (void)renzheng:(UIButton *)sender{
    if (0==[self clearSpace:nameFiled.text].length) {
        [MBProgressHUD ToastInformation:@"姓名不能为空"];
        return;
    }
    if ([numberBOOL checkUserIdCard:[self clearSpace:IDCardFiled.text]]==NO) {
        [MBProgressHUD ToastInformation:@"请输入有效的身份证号"];
        return;
    }
    MeModel *meModel=[self getMeModelMessage];
    NSString *url=[NSString stringWithFormat:@"%@%@",APPHOSTURL,person_auth];
    NSDictionary *dic=@{@"realname":[self clearSpace:nameFiled.text],@"idcard":[self clearSpace:IDCardFiled.text]};
    [XWNetworking postJsonWithUrl:url params:dic success:^(id response) {
        if (response) {
            NSInteger statusCode=[response integerForKey:@"code"];
            if (statusCode==0) {
                NSString *errorMsg=[response stringForKey:@"message"];
                [MBProgressHUD ToastInformation:errorMsg];
            }else if (statusCode==1){
                meModel.isauth=YES;
                [self saveMeModelMessage:meModel];
                self.BackBlock?self.BackBlock(@"已认证"):nil;
                [NotiCenter postNotificationName:@"changeUserInfor" object:nil];
                [self.navigationController popViewControllerAnimated:YES];
                [MBProgressHUD showSuccess:@"认证成功"];
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
    if (nameFiled == textField || IDCardFiled == textField) {
        tixianButton.enabled = (nameFiled.text.length && IDCardFiled.text.length);
    }
    if (nameFiled == textField &&textField.text.length >= 10 && textField.markedTextRange==nil ) {
        textField.text = [textField.text substringToIndex:10];
    }
}


-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if(IDCardFiled == textField) {
        if (range.location==18) {
            return NO;
        }
        NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789Xx"] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        BOOL basicTest = [string isEqualToString:filtered];
        if (!basicTest) {
            return NO;
        }
        return YES;
    }else if(nameFiled == textField){
        if (range.location==20) {
            return NO;
        }
        return YES;
    }else{
        return YES;
    }
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
    [MobClick beginLogPageView:@"实名认证"];
}
/**
 *  友盟统计页面关闭时间
 *
 */
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"实名认证"];
}

@end
