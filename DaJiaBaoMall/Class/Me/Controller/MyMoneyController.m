//
//  MyMoneyController.m
//  DaJiaBaoMall
//
//  Created by 大家保 on 2017/3/30.
//  Copyright © 2017年 大家保. All rights reserved.
//

#import "MyMoneyController.h"
#import "MyMoneyDetailController.h"
#import "GetMoneyController.h"
#import "AddOrChangeBankController.h"
#import "LSPaoMaView.h"
#import "SendProductShow.h"
#import "MeModel.h"
#import "BaseWebViewController.h"

@interface MyMoneyController (){
    //银行信息
    UIView *bankView;
    //添加银行卡
    UIView *addBankView;
    //提现按钮
    UIButton *tixianButton;
    //内容区域
    UIView *contentView;
    //银行分割线
    UILabel *seperateLine;
    //添加银行卡按钮
    UIButton *addButom;
    //添加银行卡按钮上的右箭头
    UIImageView *rightArr;
    //明细按钮
    UIButton *mingxi;
    //余额
    UILabel *yue;
    //本月收入
    UILabel *nowMonthMoney;
    //累计收入
    UILabel *allMonthMoney;
    //银行logo
    UIImageView *bankLogo;
    //是否已认证
    UIImageView *renzhengLogo;
    //银行卡号
    UILabel *bankNum;
    //银行客服电话
    UIButton *bankPhone;
    //跑马灯
    LSPaoMaView *notiView;
}

@property (nonatomic,strong) JCAlertView *alertView;

@end

@implementation MyMoneyController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addTitle:@"我的钱包"];
    [self addLeftButton];
    [self addRightButtonWithImageName:@"question"];
    [self initUI];
}

//读取本地保存的缓存
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setBankMessage:[self getMeModelMessage]];
    [self getData];
    [MobClick beginLogPageView:@"我的钱包"];
}

//保存服务器返回数据
- (void)saveData:(id)response{
    NSLog(@"银行信息=%@",response);
    if (response) {
        NSInteger statusCode=[response integerForKey:@"code"];
        if (statusCode==0) {
            NSString *errorMsg=[response stringForKey:@"message"];
            [MBProgressHUD ToastInformation:errorMsg];
        }else if (statusCode==1){
            MeModel *meModel=[MeModel mj_objectWithKeyValues:[response objectForKey:@"data"]];
            [self saveMeModelMessage:meModel];
            [self setBankMessage:meModel];
        }
    }
}


//设置银行卡信息
- (void)setBankMessage:(MeModel *)meModelMessage{
    yue.text=[NSString stringWithFormat:@"%.2f",[meModelMessage.account doubleValue]];
    nowMonthMoney.text=[NSString stringWithFormat:@"%.2f",[meModelMessage.monthincome doubleValue]];
    allMonthMoney.text=[NSString stringWithFormat:@"%.2f",[meModelMessage.totalincome doubleValue]];
    if ([meModelMessage.frozenmoney doubleValue]>0&&meModelMessage.frozentime>0) {
        [notiView removeFromSuperview];
        //跑马灯
        notiView=[[LSPaoMaView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 25)];
        [self.view addSubview:notiView];
        notiView.showTitle=[NSString stringWithFormat:@"冻结金额：%.2f元，将于%@后解冻",[meModelMessage.frozenmoney doubleValue],[self dateTimeDifferenceWithStartTime:meModelMessage.frozentime]];
    }
    if (meModelMessage.bankAuth) {
        //已经绑定
        [addBankView removeFromSuperview];
        [self showBankView];
        [tixianButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(0);
            make.top.mas_equalTo(bankView.mas_bottom).offset(50);
            make.height.mas_equalTo(40);
            make.width.mas_equalTo(210);
        }];
        [bankLogo sd_setImageWithURL:[NSURL URLWithString:meModelMessage.banklogo] placeholderImage:[UIImage imageNamed:@"空白图"]];
        [renzhengLogo setImage:[UIImage imageNamed:@"已认证"]];
        bankNum.text=[self BankNum:meModelMessage.banknum];
        [bankPhone setTitle:[NSString stringWithFormat:@"银行客服电话：%@",meModelMessage.serviceTel] forState:0];
        
    }else{
        //未绑定
        [bankView removeFromSuperview];
        [self showAddBankButtom];
        [tixianButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(0);
            make.top.mas_equalTo(addBankView.mas_bottom).offset(50);
            make.height.mas_equalTo(40);
            make.width.mas_equalTo(210);
        }];
    }
}

//显示银行信息
- (void)showBankView{
    //银行信息(已绑定)
    bankView=[[UIView alloc]init];
    [bankView setBackgroundColor:[UIColor whiteColor]];
    [contentView addSubview:bankView];
    [bankView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(mingxi.mas_bottom).offset(15);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(130);
    }];
    
    
    bankLogo=[[UIImageView alloc]init];
    [bankView addSubview:bankLogo];
    [bankLogo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(20);
        make.width.mas_equalTo(115);
        make.height.mas_equalTo(25);
    }];
    
    renzhengLogo=[[UIImageView alloc]init];
    [bankView addSubview:renzhengLogo];
    [renzhengLogo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(40);
    }];
    
    bankNum=[[UILabel alloc]init];
    bankNum.font=font14;
    bankNum.textAlignment=NSTextAlignmentCenter;
    bankNum.textColor=[UIColor colorWithHexString:@"#282828"];
    [bankView addSubview:bankNum];
    [bankNum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(bankLogo.mas_bottom).offset(10);
    }];
    
    seperateLine=[[UILabel alloc]init];
    seperateLine.backgroundColor=[UIColor colorWithHexString:@"#dcdcdc"];
    [bankView addSubview:seperateLine];
    [seperateLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(0.5);
        make.top.mas_equalTo(bankNum.mas_bottom).offset(20);
    }];
    
    bankPhone=[[UIButton alloc]init];
    [bankPhone setImage:[UIImage imageNamed:@"电话"] forState:0];
    [bankPhone setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 3)];
    [bankPhone setTitleEdgeInsets:UIEdgeInsetsMake(0, 3, 0, 0)];
    [bankPhone setTitleColor:[UIColor colorWithHexString:@"#3b3b3b"] forState:0];
    [bankPhone.titleLabel setFont:font11];
    [bankPhone setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [bankPhone addTarget:self action:@selector(callBankPhone:) forControlEvents:UIControlEventTouchUpInside];
    [bankView addSubview:bankPhone];
    [bankPhone mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(12);
        make.top.mas_equalTo(seperateLine.mas_bottom);
        make.bottom.mas_equalTo(0);
        make.width.mas_equalTo(200);
    }];
}

//显示增加按钮
- (void)showAddBankButtom{
    //未绑定
    addBankView=[[UIView alloc]init];
    addBankView.backgroundColor=[UIColor whiteColor];
    [contentView addSubview:addBankView];
    [addBankView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(50);
        make.top.mas_equalTo(mingxi.mas_bottom).offset(15);
    }];
    
    addButom=[[UIButton alloc]init];
    [addButom setImage:[UIImage imageNamed:@"添加"] forState:0];
    [addButom setTitleColor:[UIColor colorWithHexString:@"#282828"] forState:0];
    [addButom setTitle:@"添加银行卡" forState:0];
    [addButom.titleLabel setFont:font15];
    [addButom setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [addButom setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 8)];
    [addButom setTitleEdgeInsets:UIEdgeInsetsMake(0, 8, 0, 0)];
    [addButom addTarget:self action:@selector(changeBankNum:) forControlEvents:UIControlEventTouchUpInside];
    [addBankView addSubview:addButom];
    [addButom mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(0);
        make.top.bottom.mas_equalTo(0);
    }];
    
    rightArr=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"forward"]];
    [addBankView addSubview:rightArr];
    [rightArr mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.right.mas_equalTo(-15);
    }];
}

//获取数据
- (void)getData{
    NSString *url=[NSString stringWithFormat:@"%@%@",APPHOSTURL,personinfo];
    [XWNetworking getJsonWithUrl:url params:nil responseCache:^(id responseCache) {
        if (responseCache) {
            [self saveData:responseCache];
        }
    } success:^(id response) {
        [self saveData:response];
    } fail:^(NSError *error) {
        if ([XWNetworking isHaveNetwork]) {
            [MBProgressHUD ToastInformation:@"服务器开小差了"];
        }else{
            [MBProgressHUD ToastInformation:@"网络似乎已断开..."];
        }
    } showHud:YES];
    
}

//使用说明
- (void)forward:(UIButton *)button{
    WeakSelf;
    SendProductShow *showView=[[[NSBundle mainBundle]loadNibNamed:@"SendProductShow" owner:nil options:nil]lastObject];;
    showView.frame=CGRectMake(0, 0, 280, 280*820/620.0);
    showView.imageView.image=[UIImage imageNamed:@"我的钱包-bg"];
    showView.mytextView.text=@"1）如何获取盘缠？\n收到保费且保单签发后，推广费将按照相应规则发放到您的账户中（1盘缠=1元人民币）。\n2）收到保费且保单签发满3天后，在根据《个人所得税法》扣除相应税款后（如有），即可提现。\n3）账户所有人须以本人真实姓名开立结算账户，并授权圈圈保使用指定银行结算账户用于推广费支付。如果因授权人提供的账户出现问题，而导致转账失败，圈圈保无需承担责任。";
    showView.closeBlock=^(){
        [weakSelf.alertView dismissWithCompletion:nil];
    };
    self.alertView=[[JCAlertView alloc]initWithCustomView:showView dismissWhenTouchedBackground:NO];
    [self.alertView show];
}

//界面搭建
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

    
    contentView=[[UIView alloc]init];
    contentView.backgroundColor=[UIColor clearColor];
    [myScroolerView addSubview:contentView];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.top.mas_equalTo(myScroolerView);
        make.width.mas_equalTo(SCREEN_WIDTH);
    }];
    
    //头部
    UIView *headView=[[UIView alloc]init];
    headView.backgroundColor=[UIColor clearColor];
    [contentView addSubview:headView];
    headView.layer.contents=(id)[UIImage imageNamed:@"钱包－bg"].CGImage;
    [headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.height.mas_equalTo(SCREEN_WIDTH *233/375.0);
        make.width.mas_equalTo(SCREEN_WIDTH);
    }];
    
    
    yue=[[UILabel alloc]init];
    yue.font=BoldSystemFont(40);
    yue.textColor=[UIColor whiteColor];
    [headView addSubview:yue];
    [yue mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.centerY.mas_equalTo(-(SCREEN_WIDTH/375.0*3));
    }];
    
    
    
    UILabel *zhanghu=[[UILabel alloc]init];
    zhanghu.text=@"账户余额(元)";
    zhanghu.font=font15;
    zhanghu.textColor=[UIColor whiteColor];
    [headView addSubview:zhanghu];
    [zhanghu mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.bottom.mas_equalTo(yue.mas_top).offset(-SCREEN_WIDTH/375.0*10);
    }];
    
    
    
    
    UILabel *nowMonth=[[UILabel alloc]init];
    nowMonth.text=@"本月收入(元)";
    nowMonth.font=font15;
    nowMonth.textAlignment=NSTextAlignmentCenter;
    nowMonth.textColor=[UIColor whiteColor];
    [headView addSubview:nowMonth];
    [nowMonth mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(SCREEN_WIDTH/2.0);
        make.left.mas_equalTo(0);
        make.bottom.mas_equalTo(headView.mas_bottom).offset(-SCREEN_WIDTH/375.0*45);
    }];
    
    nowMonthMoney=[[UILabel alloc]init];
    nowMonthMoney.font=font15;
    nowMonthMoney.textAlignment=NSTextAlignmentCenter;
    nowMonthMoney.textColor=[UIColor whiteColor];
    [headView addSubview:nowMonthMoney];
    [nowMonthMoney mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(SCREEN_WIDTH/2.0);
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(nowMonth.mas_bottom).offset(SCREEN_WIDTH/375.0*5);
    }];
    
    UILabel *allMonth=[[UILabel alloc]init];
    allMonth.text=@"累计收入(元)";
    allMonth.font=font15;
    allMonth.textAlignment=NSTextAlignmentCenter;
    allMonth.textColor=[UIColor whiteColor];
    [headView addSubview:allMonth];
    [allMonth mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(SCREEN_WIDTH/2.0);
        make.left.mas_equalTo(SCREEN_WIDTH/2.0);
        make.bottom.mas_equalTo(headView.mas_bottom).offset(-SCREEN_WIDTH/375.0*45);
    }];
    
    allMonthMoney=[[UILabel alloc]init];
    allMonthMoney.font=font15;
    allMonthMoney.textAlignment=NSTextAlignmentCenter;
    allMonthMoney.textColor=[UIColor whiteColor];
    [headView addSubview:allMonthMoney];
    [allMonthMoney mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(SCREEN_WIDTH/2.0);
        make.left.mas_equalTo(SCREEN_WIDTH/2.0);
        make.top.mas_equalTo(nowMonth.mas_bottom).offset(SCREEN_WIDTH/375.0*5);
    }];
    
    
    UILabel *shuLine=[[UILabel alloc]init];
    shuLine.backgroundColor=[UIColor colorWithWhite:1 alpha:0.5];
    [headView addSubview:shuLine];
    [shuLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(allMonth.mas_top);
        make.bottom.mas_equalTo(allMonthMoney.mas_bottom);
        make.centerX.mas_equalTo(0);
        make.width.mas_equalTo(0.5);
    }];
    
    //钱包明细
    mingxi=[[UIButton alloc]init];
    mingxi.frame=CGRectMake(0, SCREEN_WIDTH *233/375.0, SCREEN_WIDTH, 50);
    [mingxi setTitle:@"钱包明细" forState:0];
    [mingxi addTarget:self action:@selector(detail:) forControlEvents:UIControlEventTouchUpInside];
    [mingxi setImage:[UIImage imageNamed:@"forward－red"] forState:0];
    [mingxi layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleRight imageTitleSpace:0];
    [mingxi setTitleColor:[UIColor colorWithHexString:@"#ff693a"] forState:0];
    [mingxi.titleLabel setFont:font15];
    [mingxi setBackgroundColor:[UIColor whiteColor]];
    [contentView addSubview:mingxi];
    
    
    //提现
    tixianButton=[[UIButton alloc]init];
    [tixianButton setTitle:@"提现" forState:0];
    [tixianButton setTitleColor:[UIColor whiteColor] forState:0];
    [tixianButton setTitleColor:[UIColor colorWithHexString:@"dcdcdc"] forState:UIControlStateHighlighted];
    [tixianButton.titleLabel setFont:font17];
    tixianButton.layer.cornerRadius=20;
    tixianButton.backgroundColor=[UIColor colorWithHexString:@"#ff693a"];
    [tixianButton addTarget:self action:@selector(tixian:) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:tixianButton];
    [tixianButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(mingxi.mas_bottom).offset(50);
        make.height.mas_equalTo(40);
        make.width.mas_equalTo(210);
    }];
    
    
    [contentView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(tixianButton.mas_bottom).offset(20);
    }];
}

//体现
- (void)tixian:(UIButton *)sender{
    MeModel *me=[self getMeModelMessage];
    if (me.bankAuth) {
        NSString *urlStr=[NSString stringWithFormat:@"%@%@",H5HOSTURL,tixianUrl];
        BaseWebViewController *webView=[[BaseWebViewController alloc]init];
        webView.urlStr=urlStr;
        webView.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:webView animated:YES];
    }else{
        [MBProgressHUD ToastInformation:@"请先绑定银行卡"];
        AddOrChangeBankController *addOrChange=[[AddOrChangeBankController alloc]init];
        addOrChange.titleStr=@"更改银行卡";
        addOrChange.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:addOrChange animated:YES];
    }
}

//银行客服电话
- (void)callBankPhone:(UIButton *)sender{
    NSURL *url =[NSURL URLWithString: [NSString stringWithFormat:@"tel:%@",[self getMeModelMessage].serviceTel]];
    [[UIApplication sharedApplication] openURL:url];
}

//修改银行卡号
- (void)changeBankNum:(UIButton *)sender{
    AddOrChangeBankController *addOrChange=[[AddOrChangeBankController alloc]init];
    addOrChange.titleStr=@"更改银行卡";
    addOrChange.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:addOrChange animated:YES];
}

//钱包明细
- (void)detail:(UIButton *)sender{
    MyMoneyDetailController  *detail=[[MyMoneyDetailController alloc]init];
    detail.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:detail animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

//计算剩余天数
- (NSString *)dateTimeDifferenceWithStartTime:(long long)lostTime{
    long long value= lostTime / 1000.0;
    long long house = value / 3600 % 24;
    long long day = value / (24 * 3600);
    NSString *str;
    if (day > 0) {
        str = [NSString stringWithFormat:@"%lld天%lld小时",day,house];
    }else if (day<=0 && house > 0) {
        str = [NSString stringWithFormat:@"%lld小时",house];
    }
    return str;
}


/**
 *  友盟统计页面关闭时间
 *
 */
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"我的钱包"];
}


@end
