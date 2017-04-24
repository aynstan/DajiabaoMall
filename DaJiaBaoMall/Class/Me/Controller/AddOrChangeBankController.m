//
//  AddOrChangeBankController.m
//  DaJiaBaoMall
//
//  Created by 大家保 on 2017/3/31.
//  Copyright © 2017年 大家保. All rights reserved.
//

#import "AddOrChangeBankController.h"
#import "BankListController.h"
#import "MeModel.h"

@interface AddOrChangeBankController ()<UITextFieldDelegate>{
    //银行名称
    UILabel *bankName;
    //银行卡号
    UITextField *bankNumFiled;
    //姓名
    UITextField *nameFiled;
    //身份证
    UITextField *IDCardFiled;
    //提现按钮
    UIButton *buttom;
    //银行type
    NSInteger bankType;
}
@end

@implementation AddOrChangeBankController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addTitle:self.titleStr];
    [self addLeftButton];
    [self initUI];
    //获取实名认证信息
    [self getShimingMsg];
    
}

//获取实名认证信息
- (void)getShimingMsg{
    NSString *url=[NSString stringWithFormat:@"%@%@",APPHOSTURL,shimingrenzhengMsg];
    [XWNetworking getJsonWithUrl:url params:nil  success:^(id response) {
        if (response) {
            nameFiled.text=response[@"data"][@"name"];
            IDCardFiled.text=response[@"data"][@"idcard"];
        }
    }fail:^(NSError *error) {
        
    } showHud:NO];
}


//页面初始化
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
    
    UIView *headBg=[[UIView alloc]init];
    headBg.backgroundColor=RGB(178, 178, 178);
    [contentView addSubview:headBg];
    [headBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(50);
    }];
    
    UILabel *peopleMessage=[[UILabel alloc]init];
    peopleMessage.textColor=[UIColor colorWithHexString:@"#282828"];
    peopleMessage.font=font15;
    peopleMessage.text=@"持卡人信息";
    [contentView addSubview:peopleMessage];
    [peopleMessage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(15);
        make.height.mas_equalTo(50);
    }];
    
    UILabel *peopleMessageDetail=[[UILabel alloc]init];
    peopleMessageDetail.textColor=[UIColor colorWithHexString:@"#282828"];
    peopleMessageDetail.font=font11;
    peopleMessageDetail.text=@"（届时推广费将会发至您填写的账户，请仔细填写）";
    [contentView addSubview:peopleMessageDetail];
    [peopleMessageDetail mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(peopleMessage.mas_right);
        make.centerY.mas_equalTo(peopleMessage.mas_centerY).offset(2);
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
    peopleName.textColor=[UIColor colorWithHexString:@"#282828"];
    peopleName.font=font15;
    peopleName.text=@"姓名";
    [headView addSubview:peopleName];
    [peopleName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(15);
        make.height.mas_equalTo(50);
    }];
    
    nameFiled=[[UITextField alloc]init];
    nameFiled.placeholder=@"请输入真实姓名";
    nameFiled.textColor=[UIColor colorWithHexString:@"#595959"];
    nameFiled.font=font15;
    nameFiled.delegate=self;
    nameFiled.clearButtonMode=UITextFieldViewModeWhileEditing;
    [nameFiled addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
    [headView addSubview:nameFiled];
    [nameFiled mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(80);
        make.top.bottom.mas_equalTo(peopleName);
        make.right.mas_equalTo(-15);
    }];
    
    UILabel *lineUp=[[UILabel alloc]init];
    lineUp.backgroundColor=[UIColor colorWithHexString:@"dcdcdc"];
    [headView addSubview:lineUp];
    [lineUp mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.centerY.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(0.5);
    }];
    
    
    UILabel *IDCardNumber=[[UILabel alloc]init];
    IDCardNumber.textColor=[UIColor colorWithHexString:@"#282828"];
    IDCardNumber.font=font15;
    IDCardNumber.text=@"身份证";
    [headView addSubview:IDCardNumber];
    [IDCardNumber mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(lineUp.mas_bottom);
        make.left.mas_equalTo(15);
        make.bottom.mas_equalTo(0);
    }];
    
    IDCardFiled=[[UITextField alloc]init];
    IDCardFiled.placeholder=@"与银行卡户主身份证号一致";
    IDCardFiled.textColor=[UIColor colorWithHexString:@"#595959"];
    IDCardFiled.font=font15;
    IDCardFiled.delegate=self;
    IDCardFiled.clearButtonMode=UITextFieldViewModeWhileEditing;
    [IDCardFiled addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
    [headView addSubview:IDCardFiled];
    [IDCardFiled mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(80);
        make.top.bottom.mas_equalTo(IDCardNumber);
        make.right.mas_equalTo(-15);
    }];

    
    UILabel *bankBg=[[UILabel alloc]init];
    bankBg.backgroundColor=RGB(178, 178, 178);
    [contentView addSubview:bankBg];
    [bankBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(headView.mas_bottom);
        make.left.mas_equalTo(0);
        make.height.mas_equalTo(50);
        make.right.mas_equalTo(0);
    }];
    
    UILabel *bankMessage=[[UILabel alloc]init];
    bankMessage.textColor=[UIColor colorWithHexString:@"#282828"];
    bankMessage.font=font15;
    bankMessage.text=@"银行卡信息";
    [contentView addSubview:bankMessage];
    [bankMessage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(headView.mas_bottom);
        make.left.mas_equalTo(15);
        make.height.mas_equalTo(50);
    }];
    
    UILabel *bankMessageDetail=[[UILabel alloc]init];
    bankMessageDetail.textColor=[UIColor colorWithHexString:@"#282828"];
    bankMessageDetail.font=font11;
    bankMessageDetail.text=@"（请务必使用与持卡人信息一致的储蓄卡）";
    [contentView addSubview:bankMessageDetail];
    [bankMessageDetail mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(headView.mas_bottom);
        make.left.mas_equalTo(bankMessage.mas_right);
        make.centerY.mas_equalTo(bankMessage.mas_centerY).offset(2);
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
    [getBank setTitleColor:[UIColor colorWithHexString:@"#282828"] forState:0];
    [getBank.titleLabel setFont:font15];
    [getBank addTarget:self action:@selector(selectedBankName:) forControlEvents:UIControlEventTouchUpInside];
    [getBank setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [getBank setContentEdgeInsets:UIEdgeInsetsMake(0, 15, 0, 0)];
    [middleView addSubview:getBank];
    [getBank mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(50);
        make.top.mas_equalTo(0);
    }];
    
    bankName=[[UILabel alloc]init];
    bankName.textColor=[UIColor colorWithHexString:@"595959"];
    bankName.font=font15;
    bankName.textAlignment=NSTextAlignmentLeft;
    bankName.text=@"请选择银行";
    [getBank addSubview:bankName];
    [bankName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(getBank.mas_left).offset(80);
        make.right.mas_equalTo(-30);
        make.top.bottom.mas_equalTo(0);
    }];
    
    UIImageView *rigthImageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"forward"]];
    rigthImageView.contentMode=UIViewContentModeScaleAspectFit;
    [getBank addSubview:rigthImageView];
    [rigthImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.right.mas_equalTo(-15);
    }];
    
    
    UILabel *line1=[[UILabel alloc]init];
    line1.backgroundColor=[UIColor colorWithHexString:@"dcdcdc"];
    [middleView addSubview:line1];
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(getBank.mas_bottom);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(0.5);
    }];
    
    UILabel *bankNumber=[[UILabel alloc]init];
    bankNumber.textColor=[UIColor colorWithHexString:@"#282828"];
    bankNumber.font=font15;
    bankNumber.text=@"卡号";
    [middleView addSubview:bankNumber];
    [bankNumber mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(line1.mas_bottom);
        make.left.mas_equalTo(15);
        make.bottom.mas_equalTo(0);
    }];
    
    bankNumFiled=[[UITextField alloc]init];
    bankNumFiled.placeholder=@"请输入银行卡号";
    bankNumFiled.textColor=[UIColor colorWithHexString:@"#595959"];;
    bankNumFiled.font=font15;
    bankNumFiled.delegate=self;
    bankNumFiled.keyboardType=UIKeyboardTypeNumberPad;
    bankNumFiled.clearButtonMode=UITextFieldViewModeWhileEditing;
    [bankNumFiled addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
    [middleView addSubview:bankNumFiled];
    [bankNumFiled mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(bankName.mas_left);
        make.top.bottom.mas_equalTo(bankNumber);
        make.right.mas_equalTo(-15);
    }];
    
    
    //确认提现
    buttom=[UIButton buttonWithTitle:@"确认" titleColor:[UIColor whiteColor] font:font15 target:self action:@selector(queren:)];
    [contentView addSubview:buttom];
    [buttom setBackgroundImage:[UIImage imageNamed:@"bt-normal"] forState:UIControlStateNormal];
    [buttom setBackgroundImage:[UIImage imageNamed:@"bt-Disable"] forState:UIControlStateDisabled];
    [buttom setBackgroundImage:[UIImage imageNamed:@"bt-click"] forState:UIControlStateHighlighted];
    buttom.enabled=NO;
    [buttom mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(middleView.mas_bottom).offset(95);
        make.width.mas_equalTo(215);
        make.height.mas_equalTo(40);
        make.centerX.mas_equalTo(0);
    }];
    
    [contentView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(buttom.mas_bottom).offset(20);
    }];
    
    [self setIQKeyBorderManager];


}

//选择银行
- (void)selectedBankName:(UIButton *)sender{
    BankListController *list=[[BankListController alloc]init];
    list.hidesBottomBarWhenPushed=YES;
    list.BankNameBlock=^(NSString *name,NSInteger type){
        bankName.text=name;
        bankType=type;
        bankName.textColor=[UIColor blackColor];
    };
    [self.navigationController pushViewController:list animated:YES];
}

//确认
- (void)queren:(UIButton *)sender{
    if ([[self clearSpace:bankName.text] isEqualToString:@"请选择银行"]) {
        [MBProgressHUD ToastInformation:@"请先选择银行"];
        return;
    }
    if ([numberBOOL checkUserIdCard:[self clearSpace:IDCardFiled.text]]==NO) {
        [MBProgressHUD ToastInformation:@"请输入正确的身份证号"];
        return;
    }
    NSString *url=[NSString stringWithFormat:@"%@%@",APPHOSTURL,bangdingBank];
    NSDictionary *dic=@{@"name":[self clearSpace:nameFiled.text],@"idcard":[self clearSpace:IDCardFiled.text],@"banktype":@(bankType),@"bankcard":[self clearSpace:bankNumFiled.text]};
    [XWNetworking postJsonWithUrl:url params:dic success:^(id response) {
        if (response) {
            NSInteger statusCode=[response integerForKey:@"code"];
            if (statusCode==0) {
                NSString *errorMsg=[response stringForKey:@"message"];
                [MBProgressHUD ToastInformation:errorMsg];
            }else if (statusCode==1){
                MeModel *me=[MeModel mj_objectWithKeyValues:response[@"data"]];
                [self saveMeModelMessage:me];
                [self.navigationController popViewControllerAnimated:YES];
             }
        }
    } fail:^(NSError *error) {
        [MBProgressHUD ToastInformation:@"服务器开小差了"];
    } showHud:NO];
    
    
}


#pragma mark - 输入框改变事件
/** 输入框内容发生改变 */
- (void)textFieldChanged:(UITextField *)textField {
    if (nameFiled == textField || IDCardFiled == textField|| bankNumFiled == textField) {
        buttom.enabled = (nameFiled.text.length && IDCardFiled.text.length&& bankNumFiled.text.length);
    }
}


-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField==bankNumFiled) {
        if (range.location==24) {
            return NO;
        }
        if ([string isEqualToString:@""]) {
            if ((textField.text.length - 2) % 5 == 0) {
                textField.text = [textField.text substringToIndex:textField.text.length - 1];
            }
            return YES;
        } else {
            if (textField.text.length % 5 == 0) {
                textField.text = [NSString stringWithFormat:@"%@ ", textField.text];
            }
        }
        return YES;
    }else if(textField==nameFiled){
        if (range.location==20) {
            return NO;
        }
        return YES;
    }else if(textField==IDCardFiled){
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
    [MobClick beginLogPageView:@"绑定银行卡"];
}
/**
 *  友盟统计页面关闭时间
 *
 */
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"绑定银行卡"];
}


@end
