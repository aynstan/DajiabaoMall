//
//  CheckPhoneController.m
//  DaJiaBaoMall
//
//  Created by 大家保 on 2017/3/31.
//  Copyright © 2017年 大家保. All rights reserved.
//

#import "CheckPhoneController.h"
#import "BaseTabBarController.h"
#import "CodeView.h"
#import "MeModel.h"

@interface CheckPhoneController (){
    UITextField *field;
    UITextField * codeField;
    UIButton    *codeButtom;
    UIButton    *checkCode;
}

@property (nonatomic, copy)   NSString *guid;

@property (nonatomic, strong) JCAlertView *alertView;

@end

@implementation CheckPhoneController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addTitle:@"绑定手机号"];
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
        make.top.mas_equalTo(79);
        make.height.mas_equalTo(50);
    }];
    
    //输入框
    field=[[UITextField alloc]init];
    field.placeholder=@"请输入手机号";
    field.textColor=[UIColor colorWithHexString:@"#282828"];
    field.font=font15;
    field.keyboardType=UIKeyboardTypeNumberPad;
    field.clearButtonMode=UITextFieldViewModeWhileEditing;
    [field addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
    [WhiteView addSubview:field];
    [field mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(0);
        make.right.mas_equalTo(-160);
        make.height.mas_equalTo(50);
    }];
    
    //获取验证码按钮
    codeButtom=[UIButton buttonWithTitle:@"获取验证码" titleColor:[UIColor whiteColor] font:font15 target:self action:@selector(getCode:)];
    codeButtom.tag=100;
    [codeButtom setBackgroundImage:[UIImage imageNamed:@"60s"] forState:UIControlStateDisabled];
    [codeButtom setBackgroundImage:[UIImage imageNamed:@"发送验证码"] forState:UIControlStateNormal];
    [codeButtom addTarget:self action:@selector(getCode:) forControlEvents:UIControlEventTouchUpInside];
    codeButtom.tag=100;
    [WhiteView addSubview:codeButtom];
    [codeButtom mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(field.mas_right).offset(15);
        make.width.mas_equalTo(130);
        make.height.mas_equalTo(30);
        make.top.mas_equalTo(10);
    }];
    
    
    UIView *middleView=[[UIView alloc]init];
    middleView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:middleView];
    [middleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.height.mas_equalTo(50);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(WhiteView.mas_bottom).offset(15);
    }];
    
    
    //输入框
    codeField=[[UITextField alloc]init];
    codeField.placeholder=@"请输入验证码";
    codeField.textColor=[UIColor colorWithHexString:@"#282828"];
    codeField.font=font15;
    codeField.keyboardType=UIKeyboardTypeNumberPad;
    codeField.clearButtonMode=UITextFieldViewModeWhileEditing;
    [codeField addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
    [middleView addSubview:codeField];
    [codeField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.height.mas_equalTo(50);
        make.right.mas_equalTo(-15);
        make.top.mas_equalTo(0);
    }];
    
    //开始验证
    checkCode=[UIButton buttonWithTitle:@"提交验证" titleColor:[UIColor whiteColor] font:font15 target:self action:@selector(checkCode:)];
    checkCode.tag=101;
    [checkCode setBackgroundImage:[UIImage imageNamed:@"bt-normal"] forState:UIControlStateNormal];
    [checkCode setBackgroundImage:[UIImage imageNamed:@"bt-Disable"] forState:UIControlStateDisabled];
    [checkCode setBackgroundImage:[UIImage imageNamed:@"bt-click"] forState:UIControlStateHighlighted];
    checkCode.tag=101;
    checkCode.enabled=NO;
    [self.view addSubview:checkCode];
    [checkCode mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(middleView.mas_bottom).offset(100);
        make.centerX.mas_equalTo(0);
        make.width.mas_equalTo(210);
        make.height.mas_equalTo(40);
    }];
    
}

//获取短信验证码
- (void)getCode:(UIButton *)sender{
    [self.view endEditing:YES];
    if (![numberBOOL checkTelNumber:field.text]) {
        [MBProgressHUD ToastInformation:@"请输入正确的手机号"];
        return;
    }
    if (0==self.guid.length) {
        //获取sid
        [self getSid:sender];
    }else{
        [self getSnsCode:self.guid];
    }
}

#pragma mark 验证码倒计时
- (void)autoCodeDecler{
    //验证码倒计时
    __block float timeout=60; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                [codeButtom setTitle:@"获取验证码" forState:0];
                codeButtom.enabled=YES;
            });
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [codeButtom setTitle:[NSString stringWithFormat:@"%.0fs",timeout] forState:0];
                codeButtom.enabled=NO;
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
}


//获取sid
- (void)getSid:(UIButton *)btn{
    NSString *urlStr=[NSString stringWithFormat:@"%@%@",codeUrl,@"/verify/sid?"];
    [XWNetworking getJsonWithUrl:urlStr params:nil success:^(id response) {
        NSDictionary *dic=response;
        NSInteger code=[dic integerForKey:@"code"];
        if (code==1) {
            NSDictionary *dataDic=[dic objectForKey:@"data"];
            NSString *sidStr=[dataDic objectForKey:@"sid"];
            self.guid=sidStr;
            if(btn.tag==100){
                [self getSnsCode:sidStr];
            }else if(btn.tag==101){
                [self checkPhoneCode:sidStr];
            }
        }
    } fail:^(NSError *error) {
        [MBProgressHUD ToastInformation:@"服务器开小差了"];
    } showHud:YES];
}


#pragma mark 有sid * 获取短信验证码 *
- (void)getSnsCode:(NSString *)sid{
    NSString *urlStr=[NSString stringWithFormat:@"%@/verify/sms",codeUrl];
    NSDictionary *dic=@{@"code":@"",@"phone":[self clearSpace:field.text],@"smsCode":@"TYHJ_CODE",@"sid":sid};
    [XWNetworking postJsonWithUrl:urlStr params:dic success:^(id response) {
        NSDictionary *dic=response;
        NSInteger code=[dic integerForKey:@"code"];
        if (code == -1) {
            //弹出图片输入框
            [self getImageCode:sid];
        } else if (code == 1) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD showSuccess:@"短信已发送"];
                //手机验证码发送成功
                [self autoCodeDecler];
            });
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                NSString *errorMsg=[dic objectForKey:@"message"];
                [MBProgressHUD ToastInformation:errorMsg];
            });
        }
    } fail:^(NSError *error) {
        [MBProgressHUD ToastInformation:@"服务器开小差了"];
    } showHud:YES];
}

/**
 *  需要图片验证码，弹出图片验证码
 */
- (void)getImageCode:(NSString *)sid{
    CodeView *codeView=[[CodeView alloc]init];
    [codeView initWithPhoneNumber:[self clearSpace:field.text] PostId:sid okBlock:^(NSString *str, NSString *imageCode) {
        [self.alertView dismissWithCompletion:^{
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD showSuccess:@"短信已发送"];
                [self autoCodeDecler];
            });
        }];
    } cancelBlock:^{
        [self.alertView dismissWithCompletion:^{
        }];
    }];
    self.alertView=[[JCAlertView alloc]initWithCustomView:codeView dismissWhenTouchedBackground:NO];
    [self.alertView show];
    
}

/**
 *  验证手机短信验证码
 */
- (void)checkPhoneCode:(NSString *)sid{
    NSString *urlStr=[NSString stringWithFormat:@"%@%@",codeUrl,@"/verify/checksmscode"];
    NSDictionary *dic=@{@"code":[self clearSpace:codeField.text],@"phone":[self clearSpace:field.text],@"sid":sid};
    [XWNetworking postJsonWithUrl:urlStr params:dic success:^(id response) {
        NSDictionary *dic=response;
        NSInteger code=[dic integerForKey:@"code"];
        if (code==1) {
            [self beginLogin:sid];
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                NSString  *errMessage=[dic objectForKey:@"message"];
                [MBProgressHUD ToastInformation:errMessage];
            });
        }
    } fail:^(NSError *error) {
        [MBProgressHUD ToastInformation:@"服务器开小差了"];
    } showHud:YES];
}


//开始登录
- (void)checkCode:(UIButton *)sender{
    NSLog(@"开始登录");
    [self.view endEditing:YES];
    if (![numberBOOL checkTelNumber:field.text]) {
        [MBProgressHUD ToastInformation:@"请输入正确的手机号"];
        return;
    }
    if (0==codeField.text.length) {
        [MBProgressHUD ToastInformation:@"请输入正确的验证码"];
        return;
    }
    if (0==self.guid.length){
        [self getSid:sender];
    }else{
        [self checkPhoneCode:self.guid];
    }
}

//短信验证码验证成功开始登录
- (void)beginLogin:(NSString *)sid{
    NSString *url=[NSString stringWithFormat:@"%@%@",APPHOSTURL,wechatLogin];
    NSDictionary *dic=@{@"wxToken":self.wechatId,@"wxName":self.wxName,@"wximage":self.wximage,@"verifySid":self.guid,@"mobilephone":[self clearSpace:field.text],@"source":@"40"};
    [XWNetworking postJsonWithUrl:url params:dic success:^(id response) {
        if (response) {
            NSInteger statusCode=[response integerForKey:@"code"];
            if (statusCode==0) {
                NSString *errorMsg=[response stringForKey:@"message"];
                [MBProgressHUD ToastInformation:errorMsg];
            }else{
                NSString *tokenID=response[@"data"][@"sid"];
                MeModel *me=[MeModel mj_objectWithKeyValues:response[@"data"][@"memberInfo"]];
                [UserDefaults setObject:tokenID forKey:TOKENID ];
                [self saveMeModelMessage:me];
                BaseTabBarController *rootVC=[[BaseTabBarController alloc]init];
                KeyWindow.rootViewController=rootVC;
            }
        }
    } fail:^(NSError *error) {
        [MBProgressHUD ToastInformation:@"服务器开小差了"];
    } showHud:YES];
}



#pragma mark - 输入框改变事件
/** 输入框内容发生改变 */
- (void)textFieldChanged:(UITextField *)textField {
    if (field == textField || codeField == textField) {
        checkCode.enabled = (field.text.length && codeField.text.length);
    }
    //  限制输入框的输入长度为11
    if (field == textField&&textField.text.length >= 11 && textField.markedTextRange==nil ) {
        textField.text = [textField.text substringToIndex:11];
    }
    //  限制输入框的输入长度为11
    if (codeField == textField  && textField.text.length >=6 && textField.markedTextRange==nil ) {
        textField.text = [textField.text substringToIndex:6];
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
    [MobClick beginLogPageView:@"微信登录绑定手机号"];
}
/**
 *  友盟统计页面关闭时间
 *
 */
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"微信登录绑定手机号"];
}



@end
