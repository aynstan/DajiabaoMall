//
//  LoginController.m
//  DaJiaBaoMall
//
//  Created by 大家保 on 2017/3/27.
//  Copyright © 2017年 大家保. All rights reserved.
//

#import "LoginController.h"
#import "CodeView.h"
#import "BaseTabBarController.h"
#import "MeModel.h"
#import "WXApi.h"
#import "CheckPhoneController.h"

@interface LoginController ()<UITextFieldDelegate>{
    UITextField *userNameFiled;
    UITextField *passwordFiled;
    UIButton *loginButton;
    UIButton *getCodeButton;
    UIView *userLine;
    UIView *wordLine;
    BOOL hiddenStatusBar;
}

@property (nonatomic, copy)   NSString *guid;

@property (nonatomic, strong) JCAlertView *alertView;

@end

@implementation LoginController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.bgView.hidden=YES;
    [self initUI];
}


//界面布局
- (void)initUI{
    
    self.view.layer.contents=(id)[UIImage imageNamed:@"bg－武侠"].CGImage;
    
    UIScrollView *myScrollerView=[[UIScrollView alloc]init];
    myScrollerView.backgroundColor=[UIColor clearColor];
    [self.view addSubview:myScrollerView];
    [myScrollerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
        make.width.mas_equalTo(SCREEN_WIDTH);
    }];
    
    UIView *contentView=[[UIView alloc]init];
    contentView.backgroundColor=[UIColor clearColor];
    [myScrollerView addSubview:contentView];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(myScrollerView);
        make.width.mas_equalTo(SCREEN_WIDTH);
    }];
    
    UIImageView *logo=[[UIImageView alloc]init];
    logo.image=[UIImage imageNamed:@"logo"];
    [contentView addSubview:logo];
    [logo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(contentView.mas_centerX);
        make.top.mas_equalTo(contentView.mas_top).offset(SCREEN_WIDTH/375.0*60);;
        make.width.height.mas_equalTo(SCREEN_WIDTH/375.0*100);
    }];
    
    UIImageView *userNameImageView=[[UIImageView alloc]init];
    userNameImageView.image=[UIImage imageNamed:@"phone"];
    userNameImageView.contentMode=UIViewContentModeScaleAspectFit;
    [contentView addSubview:userNameImageView];
    [userNameImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(contentView.mas_left).offset(GetWidth(20));
        make.top.mas_equalTo(logo.mas_bottom).offset(GetHeight(15));
        make.height.mas_equalTo(GetHeight(50));
        make.width.mas_equalTo(15);
    }];
    
    userNameFiled=[[UITextField alloc]init];
    userNameFiled.font=font15;
    userNameFiled.tintColor=[UIColor whiteColor];
    userNameFiled.textColor=[UIColor whiteColor];
    userNameFiled.delegate=self;
    NSMutableDictionary *attr = [NSMutableDictionary dictionary];
    attr[NSForegroundColorAttributeName] = [UIColor colorWithHexString:@"#f9e8e5"];
    NSMutableAttributedString *holder = [[NSMutableAttributedString alloc]initWithString:@"手机号" attributes:attr];
    userNameFiled.attributedPlaceholder = holder;
    userNameFiled.keyboardType=UIKeyboardTypeNumberPad;
    userNameFiled.clearButtonMode=UITextFieldViewModeWhileEditing;
    [userNameFiled addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
    [contentView addSubview:userNameFiled];
    [userNameFiled mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(userNameImageView.mas_right).offset(GetWidth(12));
        make.top.mas_equalTo(userNameImageView.mas_top);
        make.right.mas_equalTo(contentView.mas_right).offset(-GetWidth(20));
        make.height.mas_equalTo(GetHeight(50));
    }];
    
    userLine=[[UIView alloc]init];
    userLine.backgroundColor=[UIColor colorWithHexString:@"#f9e8e5"];
    [contentView addSubview:userLine];
    [userLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(userNameFiled.mas_bottom);
        make.height.mas_equalTo(0.5);
        make.left.mas_equalTo(contentView.mas_left).offset(GetWidth(20));
        make.right.mas_equalTo(contentView.mas_right).offset(-GetWidth(20));
    }];
    
    UIImageView *passwordImageView=[[UIImageView alloc]init];
    passwordImageView.image=[UIImage imageNamed:@"key"];
    passwordImageView.contentMode=UIViewContentModeScaleAspectFit;
    [contentView addSubview:passwordImageView];
    [passwordImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(contentView.mas_left).offset(GetWidth(20));
        make.top.mas_equalTo(userLine.mas_bottom);
        make.height.mas_equalTo(GetHeight(50));
        make.width.mas_equalTo(15);
    }];
    
    getCodeButton=[[UIButton alloc]init];
    getCodeButton.tag=100;
    [getCodeButton setTitle:@"获取验证码" forState:0];
    [getCodeButton setTitleColor:[UIColor whiteColor] forState:0];
    [getCodeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
    [getCodeButton.titleLabel setFont:font15];
    [getCodeButton setBackgroundImage:[UIImage imageNamed:@"发送验证码"] forState:0];
    [getCodeButton setBackgroundImage:[UIImage imageNamed:@"60s"] forState:UIControlStateDisabled];
    [getCodeButton addTarget:self action:@selector(getCode:) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:getCodeButton];
    [getCodeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(130);
        make.right.mas_equalTo(userLine.mas_right);
        make.top.mas_equalTo(userLine.mas_bottom).offset(10);
        make.height.mas_equalTo(30);
    }];
    
    UIView *codeLine=[[UIView alloc]init];
    codeLine.backgroundColor=colord3f2fe;
    [contentView addSubview:codeLine];
    [codeLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(getCodeButton.mas_left);
        make.centerY.mas_equalTo(getCodeButton.mas_centerY);
        make.width.mas_equalTo(0);
        make.height.mas_equalTo(GetHeight(30));
    }];
    
    
    
    passwordFiled=[[UITextField alloc]init];
    passwordFiled.font=font15;
    passwordFiled.keyboardType=UIKeyboardTypeNumberPad;
    passwordFiled.clearButtonMode=UITextFieldViewModeWhileEditing;
    passwordFiled.delegate=self;
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSForegroundColorAttributeName] = [UIColor colorWithHexString:@"#f9e8e5"];
    NSMutableAttributedString *placeHolder = [[NSMutableAttributedString alloc]initWithString:@"验证码" attributes:attrs];
    passwordFiled.attributedPlaceholder = placeHolder;
    passwordFiled.tintColor=[UIColor whiteColor];
    passwordFiled.textColor=[UIColor whiteColor];
    [passwordFiled addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
    [contentView addSubview:passwordFiled];
    [passwordFiled mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(passwordImageView.mas_right).offset(GetWidth(12));
        make.top.mas_equalTo(passwordImageView.mas_top);
        make.right.mas_equalTo(codeLine.mas_left).offset(-GetWidth(15));
        make.height.mas_equalTo(userNameFiled);
    }];
    
    wordLine=[[UIView alloc]init];
    wordLine.backgroundColor=[UIColor colorWithHexString:@"#f9e8e5"];
    [contentView addSubview:wordLine];
    [wordLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(passwordFiled.mas_bottom);
        make.height.mas_equalTo(0.5);
        make.left.mas_equalTo(contentView.mas_left).offset(GetWidth(20));
        make.right.mas_equalTo(contentView.mas_right).offset(-GetWidth(20));
    }];
    
    
    loginButton=[UIButton buttonWithTitle:@"" titleColor:[UIColor clearColor] font:font17 target:self action:@selector(login:)];
    loginButton.tag=101;
    [loginButton setBackgroundImage:[UIImage imageNamed:@"bt-normal_login"] forState:0];
    [loginButton setBackgroundImage:[UIImage imageNamed:@"bt-disappeared_login"] forState:UIControlStateDisabled];
    [loginButton setBackgroundImage:[UIImage imageNamed:@"bt-click_login"] forState:UIControlStateHighlighted];
    loginButton.enabled=NO;
    [contentView addSubview:loginButton];
    [loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(wordLine.mas_bottom).offset(SCREEN_WIDTH/375.0*65);
        make.left.mas_equalTo(contentView.mas_left).offset(GetWidth(50));
        make.right.mas_equalTo(contentView.mas_right).offset(-GetWidth(50));
        make.height.mas_equalTo(GetHeight(40));
    }];
    
    
    [contentView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(loginButton.mas_bottom).offset(GetHeight(65));
    }];
    
    [self setIQKeyBorderManager];
    
    UIButton *wechtLogin=[UIButton buttonWithTitle:@"" titleColor:colorc9e8ff font:font13 target:self action:@selector(bangdingWechat)];
    [wechtLogin setImage:[UIImage imageNamed:@"微信登录"] forState:0];
    [self.view addSubview:wechtLogin];
    [wechtLogin mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.bottom.mas_equalTo(-GetHeight(30));
        make.height.mas_equalTo(44);
        make.width.mas_equalTo(300);
    }];
}

//获取短信验证码
- (void)getCode:(UIButton *)sender{
    [self.view endEditing:YES];
    if (![numberBOOL checkTelNumber:userNameFiled.text]) {
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
                [getCodeButton setTitle:@"获取验证码" forState:0];
                getCodeButton.enabled=YES;
            });
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [getCodeButton setTitle:[NSString stringWithFormat:@"%.0fs",timeout] forState:0];
                getCodeButton.enabled=NO;
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
}

//开始登录
- (void)login:(UIButton *)sender{
    [self.view endEditing:YES];
    if (![numberBOOL checkTelNumber:userNameFiled.text]) {
        [MBProgressHUD ToastInformation:@"请输入正确的手机号"];
        return;
    }
    if (0==passwordFiled.text.length) {
        [MBProgressHUD ToastInformation:@"请输入正确的验证码"];
        return;
    }
    if (0==self.guid.length){
        [self getSid:sender];
    }else{
        [self checkPhoneCode:self.guid];
    }
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
    NSDictionary *dic=@{@"code":@"",@"phone":[self clearSpace:userNameFiled.text],@"smsCode":@"TYHJ_CODE",@"sid":sid};
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
    [codeView initWithPhoneNumber:[self clearSpace:userNameFiled.text] PostId:sid okBlock:^(NSString *str, NSString *imageCode) {
        [self.alertView dismissWithCompletion:^{
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD showSuccess:@"短信已发送"];
                [self autoCodeDecler];
                [self hiddenStatusBar];
            });
        }];
    } cancelBlock:^{
        [self.alertView dismissWithCompletion:^{
            dispatch_async(dispatch_get_main_queue(), ^{
                [self hiddenStatusBar];
            });
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
    NSDictionary *dic=@{@"code":[self clearSpace:passwordFiled.text],@"phone":[self clearSpace:userNameFiled.text],@"sid":sid};
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

//短信验证码验证成功开始登录
- (void)beginLogin:(NSString *)sid{
    NSString *url=[NSString stringWithFormat:@"%@%@",APPHOSTURL,LOGINURL];
    NSDictionary *dic=@{@"verifySid":self.guid,@"mobilephone":[self clearSpace:userNameFiled.text],@"source":@"40"};
    [XWNetworking postJsonWithUrl:url params:dic success:^(id response) {
        [self saveData:response];
    } fail:^(NSError *error) {
        [MBProgressHUD ToastInformation:@"服务器开小差了"];
    } showHud:YES];
}

//登录成功保存个人数据数据
- (void)saveData:(id)response{
    NSLog(@"登录成功了======%@",response);
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
}


//绑定微信
- (void)bangdingWechat{
    if ([WXApi isWXAppInstalled]) {
        [[UMSocialManager defaultManager] getUserInfoWithPlatform:UMSocialPlatformType_WechatSession currentViewController:nil completion:^(id result, NSError *error) {
            if (error) {
            } else {
                UMSocialUserInfoResponse *resp = result;
                NSString *url=[NSString stringWithFormat:@"%@%@",APPHOSTURL,checkWechatAndPhone];
                NSDictionary *dic=@{@"wxToken":resp.uid};
                [XWNetworking postJsonWithUrl:url params:dic success:^(id response) {
                    if (response) {
                        NSInteger statusCode=[response integerForKey:@"code"];
                        if (statusCode==0) {
                            NSString *errorMsg=[response stringForKey:@"message"];
                            [MBProgressHUD ToastInformation:errorMsg];
                        }else{
                            if (statusCode==1) {
                                [self saveData:response];
                            }else{
                                CheckPhoneController *checkPhone=[[CheckPhoneController alloc]init];
                                checkPhone.wechatId=resp.uid;
                                checkPhone.wxName=resp.name;
                                checkPhone.wximage=resp.iconurl;
                                checkPhone.hidesBottomBarWhenPushed=YES;
                                [self.navigationController pushViewController:checkPhone animated:YES];
                            }
                        }
                    }
                } fail:^(NSError *error) {
                    [MBProgressHUD ToastInformation:@"服务器开小差了"];
                } showHud:YES];
            }
        }];
    }else{
        UIAlertController *alertController=[UIAlertController alertControllerWithTitle:@"提醒" message:@"您尚未安装微信客户端，暂无法绑定微信" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction=[UIAlertAction actionWithTitle:@"我知道了" style:UIAlertActionStyleCancel handler:nil];
        [alertController addAction:cancelAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}



#pragma mark - 输入框改变事件
/** 输入框内容发生改变 */
- (void)textFieldChanged:(UITextField *)textField {
    if (userNameFiled == textField || passwordFiled == textField) {
        loginButton.enabled = (userNameFiled.text.length && passwordFiled.text.length);
    }
    //  限制输入框的输入长度为11
    if (userNameFiled == textField&&textField.text.length >= 11 && textField.markedTextRange==nil ) {
        textField.text = [textField.text substringToIndex:11];
    }
    //  限制输入框的输入长度为11
    if (passwordFiled == textField  && textField.text.length >=6 && textField.markedTextRange==nil ) {
        textField.text = [textField.text substringToIndex:6];
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    if (textField==userNameFiled) {
        userLine.backgroundColor=[UIColor whiteColor];
    }
    if (textField==passwordFiled) {
        wordLine.backgroundColor=[UIColor whiteColor];
    }
};

- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField==userNameFiled) {
        userLine.backgroundColor=[UIColor colorWithHexString:@"#f9e8e5"];
    }
    if (textField==passwordFiled) {
        wordLine.backgroundColor=[UIColor colorWithHexString:@"#f9e8e5"];
    }
}

#ifdef __IPHONE_10_0
- (void)textFieldDidEndEditing:(UITextField *)textField reason:(UITextFieldDidEndEditingReason)reason{
    if (textField==userNameFiled) {
        userLine.backgroundColor=[UIColor colorWithHexString:@"#f9e8e5"];
    }
    if (textField==passwordFiled) {
        wordLine.backgroundColor=[UIColor colorWithHexString:@"#f9e8e5"];
    }
}
#endif

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (BOOL)prefersStatusBarHidden{
    return !hiddenStatusBar;
}


- (void)hiddenStatusBar{
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
        [self prefersStatusBarHidden];
        [self setNeedsStatusBarAppearanceUpdate];
    }
}

/**
 *  友盟统计页面打开开始时间
 *
 */
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"登录"];
}
/**
 *  友盟统计页面关闭时间
 *
 */
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"登录"];
}


@end
