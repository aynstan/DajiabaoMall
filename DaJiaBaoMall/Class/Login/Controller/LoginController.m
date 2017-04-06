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

@interface LoginController ()<UITextFieldDelegate>{
    UITextField *userNameFiled;
    UITextField *passwordFiled;
    UIButton *loginButton;
    UIButton *getCodeButton;
    UIView *userLine;
    UIView *wordLine;
}

@property (nonatomic, copy)   NSString *guid;

@property (nonatomic, strong) JCAlertView *alertView;

@end

@implementation LoginController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.bgView.hidden=YES;
    [self initUI];
    [self addLeftBarButton:@"关闭"];
}

- (void)leftClick:(UIButton *)btn{
    [self dismissXWModalView];
}

//界面布局
- (void)initUI{
    self.view.layer.contents=(id)[UIImage imageNamed:@"bg-blue"].CGImage;
    
    
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
    logo.image=[UIImage imageNamed:@"login-logo"];
    [contentView addSubview:logo];
    [logo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(contentView.mas_centerX);
        make.top.mas_equalTo(contentView.mas_top).offset(GetHeight(90));;
        make.width.height.mas_equalTo(GetWidth(110));
    }];
    
    UIImageView *userNameImageView=[[UIImageView alloc]init];
    userNameImageView.image=[UIImage imageNamed:@"用户"];
    userNameImageView.contentMode=UIViewContentModeScaleAspectFit;
    [contentView addSubview:userNameImageView];
    [userNameImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(contentView.mas_left).offset(GetWidth(20));
        make.top.mas_equalTo(logo.mas_bottom).offset(GetHeight(15));
        make.height.mas_equalTo(GetHeight(50));
    }];
    
    userNameFiled=[[UITextField alloc]init];
    userNameFiled.font=font15;
    userNameFiled.tintColor=[UIColor whiteColor];
    userNameFiled.textColor=[UIColor whiteColor];
    userNameFiled.delegate=self;
    NSMutableDictionary *attr = [NSMutableDictionary dictionary];
    attr[NSForegroundColorAttributeName] = colord3f2fe;
    NSMutableAttributedString *holder = [[NSMutableAttributedString alloc]initWithString:@"请输入手机号" attributes:attr];
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
    userLine.backgroundColor=colorca2e5ff;
    [contentView addSubview:userLine];
    [userLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(userNameFiled.mas_bottom);
        make.height.mas_equalTo(0.5);
        make.left.mas_equalTo(contentView.mas_left).offset(GetWidth(20));
        make.right.mas_equalTo(contentView.mas_right).offset(-GetWidth(20));
    }];
    
    UIImageView *passwordImageView=[[UIImageView alloc]init];
    passwordImageView.image=[UIImage imageNamed:@"验证码"];
    passwordImageView.contentMode=UIViewContentModeScaleAspectFit;
    [contentView addSubview:passwordImageView];
    [passwordImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(contentView.mas_left).offset(GetWidth(20));
        make.top.mas_equalTo(userLine.mas_bottom);
        make.height.mas_equalTo(GetHeight(50));
    }];
    
    getCodeButton=[UIButton buttonWithTitle:@"获取验证码" titleColor:colorffff00 font:font15 target:self action:@selector(getCode:)];
    getCodeButton.tag=100;
    [getCodeButton setTitleColor:colord3f2fe forState:UIControlStateDisabled];
    [contentView addSubview:getCodeButton];
    [getCodeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(userLine.mas_right);
        make.height.mas_equalTo(userNameFiled);
        make.top.mas_equalTo(passwordImageView.mas_top);
        make.width.mas_equalTo(GetWidth(125));
    }];
    
    UIView *codeLine=[[UIView alloc]init];
    codeLine.backgroundColor=colord3f2fe;
    [contentView addSubview:codeLine];
    [codeLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(getCodeButton.mas_left);
        make.centerY.mas_equalTo(getCodeButton.mas_centerY);
        make.width.mas_equalTo(0.5);
        make.height.mas_equalTo(GetHeight(30));
    }];
    
    
    
    passwordFiled=[[UITextField alloc]init];
    passwordFiled.font=font15;
    passwordFiled.keyboardType=UIKeyboardTypeNumberPad;
    passwordFiled.clearButtonMode=UITextFieldViewModeWhileEditing;
    passwordFiled.delegate=self;
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSForegroundColorAttributeName] = colord3f2fe;
    NSMutableAttributedString *placeHolder = [[NSMutableAttributedString alloc]initWithString:@"请输入动态验证码" attributes:attrs];
    passwordFiled.attributedPlaceholder = placeHolder;
    passwordFiled.tintColor=[UIColor whiteColor];
    passwordFiled.textColor=[UIColor whiteColor];
    [passwordFiled addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
    [contentView addSubview:passwordFiled];
    [passwordFiled mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(passwordImageView.mas_right).offset(GetWidth(12));
        make.top.mas_equalTo(passwordImageView.mas_top);
        make.right.mas_equalTo(codeLine.mas_left).offset(-GetWidth(10));
        make.height.mas_equalTo(userNameFiled);
    }];
    
    wordLine=[[UIView alloc]init];
    wordLine.backgroundColor=colorca2e5ff;
    [contentView addSubview:wordLine];
    [wordLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(passwordFiled.mas_bottom);
        make.height.mas_equalTo(0.5);
        make.left.mas_equalTo(contentView.mas_left).offset(GetWidth(20));
        make.right.mas_equalTo(contentView.mas_right).offset(-GetWidth(20));
    }];
    
    
    loginButton=[UIButton buttonWithTitle:@"" titleColor:[UIColor orangeColor] font:font17 target:self action:@selector(login:)];
    loginButton.tag=101;
    [loginButton setBackgroundImage:[UIImage imageNamed:@"bt-normal"] forState:0];
    [loginButton setBackgroundImage:[UIImage imageNamed:@"bt-forbidden"] forState:UIControlStateDisabled];
    [loginButton setBackgroundImage:[UIImage imageNamed:@"bt-click"] forState:UIControlStateHighlighted];
    loginButton.enabled=NO;
    [contentView addSubview:loginButton];
    [loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(wordLine.mas_bottom).offset(GetHeight(65));
        make.left.mas_equalTo(contentView.mas_left).offset(GetWidth(50));
        make.right.mas_equalTo(contentView.mas_right).offset(-GetWidth(50));
        make.height.mas_equalTo(GetHeight(40));
    }];
    
    
    [contentView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(loginButton.mas_bottom).offset(GetHeight(65));
    }];
    
    [self setIQKeyBorderManager];
    
    UIButton *callPhone=[UIButton buttonWithTitle:@"客服电话 400 1114 567" titleColor:colorc9e8ff font:font13 target:self action:@selector(callPhone:)];
    [callPhone setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [self.view addSubview:callPhone];
    [callPhone mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view);
        make.bottom.mas_equalTo(-GetHeight(30));
        make.height.mas_equalTo(44);
    }];
}

- (void)callPhone:(UIButton *)sender{
    UIAlertController *phoneAlert=[UIAlertController alertControllerWithTitle:@"确定拨打400-1114-567?" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *queding=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSURL *url =[NSURL URLWithString:@"tel:4001114567"];
        [[UIApplication sharedApplication] openURL:url];
    }];
    [phoneAlert addAction:cancel];
    [phoneAlert addAction:queding];
    [self presentViewController:phoneAlert animated:YES completion:nil];
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


- (void)login:(UIButton *)sender{
//    [self.view endEditing:YES];
//    if (![numberBOOL checkTelNumber:userNameFiled.text]) {
//        [MBProgressHUD ToastInformation:@"请输入正确的手机号"];
//        return;
//    }
//    if (0==passwordFiled.text.length) {
//        [MBProgressHUD ToastInformation:@"请输入正确的验证码"];
//        return;
//    }
//    if (0==self.guid.length){
//        [self getSid:sender];
//    }else{
//        [self checkPhoneCode:self.guid];
//    }
    [self beginLogin:@""];
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
        NSLog(@"获取sid失败");
        [MBProgressHUD showError:@"服务器繁忙"];
    } showHud:YES];
}


#pragma mark 有sid * 获取短信验证码 *
- (void)getSnsCode:(NSString *)sid{
    NSString *urlStr=[NSString stringWithFormat:@"%@/verify/sms",codeUrl];
    NSDictionary *dic=@{@"code":@"",@"phone":[self clearSpace:userNameFiled.text],@"smsCode":@"FXXT_API_LOGIN",@"sid":sid};
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
                [MBProgressHUD showError:errorMsg];
            });
        }
    } fail:^(NSError *error) {
        [MBProgressHUD showError:@"服务器繁忙"];
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
                [MBProgressHUD showError:errMessage];
            });
        }
    } fail:^(NSError *error) {
        [MBProgressHUD showError:@"系统繁忙"];
    } showHud:YES];
}

//短信验证码验证成功开始登录
- (void)beginLogin:(NSString *)sid{
    [UserDefaults setObject:@"1111" forKey:TOKENID];
    [UserDefaults synchronize];
    BaseTabBarController *rootVC=[[BaseTabBarController alloc]init];
    KeyWindow.rootViewController=rootVC;
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
        userLine.backgroundColor=colorca2e5ff;
    }
    if (textField==passwordFiled) {
        wordLine.backgroundColor=colorca2e5ff;
    }
}

#ifdef __IPHONE_10_0
- (void)textFieldDidEndEditing:(UITextField *)textField reason:(UITextFieldDidEndEditingReason)reason{
    if (textField==userNameFiled) {
        userLine.backgroundColor=colorca2e5ff;
    }
    if (textField==passwordFiled) {
        wordLine.backgroundColor=colorca2e5ff;
    }
}
#endif

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (BOOL)prefersStatusBarHidden{
    return YES;
}


- (void)hiddenStatusBar{
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
        [self prefersStatusBarHidden];
        [self setNeedsStatusBarAppearanceUpdate];
    }
}



@end
