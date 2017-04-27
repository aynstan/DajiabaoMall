//
//  MainController.m
//  DaJiaBaoMall
//
//  Created by 大家保 on 2017/3/27.
//  Copyright © 2017年 大家保. All rights reserved.
//

#import "MainController.h"
#import "ShouyeHeadViewCell.h"
#import "ShouyeContentHeadCell.h"
#import "ShouyeContentCell.h"
#import "MyMoneyController.h"
#import "MessageListController.h"
#import "AllProductViewController.h"
#import "BaseWebViewController.h"
#import "UMessage.h"
#import <RongIMKit/RongIMKit.h>
#import "TSMessage.h"
#import "ConnectServiceViewController.h"
#import "BaseNavigationController.h"
#import "MainModel.h"
#import "MeModel.h"
#import "ToSetSelfMessage.h"
#import "MyMessageControllerViewController.h"
#define SDHEIGHT             SCREEN_WIDTH*243/375.0
#define COLLECTIONVIEWHEIGHT 97
#define ADVERTISEHEIGHT      40
#define SPACE_ITEM           10


@interface MainController ()<UITableViewDelegate,UITableViewDataSource,ShouyeHeadViewCell_Delegate,RCIMUserInfoDataSource,RCIMReceiveMessageDelegate>{
    UIView *headView;
    UILabel *titleLabel;
    UIButton *headImageButton;
    UIButton *messageButtom;
    UILabel *messageLabel;
    UIButton *eyeButton;
    UILabel *line;
}


@property (nonatomic,strong)UITableView *myTableView;

@property (nonatomic,strong)NSMutableArray *dataSourceArray;

@property (nonatomic,assign) BOOL showBlackStatus;

@property (nonatomic,strong) MainModel *mainModel;

@property (nonatomic,strong) ShouyeHeadViewCell *headCell;

@property (nonatomic,strong) NomessageView *noMessageView;

@property (nonatomic,strong) JCAlertView *alertView;

@end

static NSString *const tableviewContentCell=@"ContentCell";

@implementation MainController

- (void)viewDidLoad {
    [super viewDidLoad];
    //隐藏父类的头视图
    self.bgView.hidden=YES;
    //开始请求
    [self.myTableView.mj_header beginRefreshing];
    //自定义导航栏
    [self addHeadView];
    //自动登录
    [self autoLogin];
    //添加刷新用户信息监听
    [NotiCenter addObserver:self selector:@selector(refreshUserInfo) name:@"changeUserInfor" object:nil];
    //收到新消息
    [NotiCenter addObserver:self selector:@selector(haveMessage) name:@"haveMessage" object:nil];
    //跳转设置
    [self toastToSetImage];
}

//接收新消息通知
- (void)haveMessage{
    [self checkMessageCount];
}

//跳转设置
- (void)toastToSetImage{
    MeModel *me=[self getMeModelMessage];
    if (0==me.name.length) {
        ToSetSelfMessage *setView=[[[NSBundle mainBundle] loadNibNamed:@"ToSetSelfMessage" owner:nil options:nil] lastObject];
        setView.closeBlock=^(){
            [self.alertView dismissWithCompletion:nil];
            self.showBlackStatus=NO;
            [self setNeedsStatusBarAppearanceUpdate];
        };
        setView.setBlock=^(){
            [self.alertView dismissWithCompletion:^{
                MyMessageControllerViewController *set=[[MyMessageControllerViewController alloc]init];
                set.hidesBottomBarWhenPushed=YES;
                [self.navigationController pushViewController:set animated:YES];
                self.showBlackStatus=NO;
                [self setNeedsStatusBarAppearanceUpdate];
            }];
        };
        self.alertView=[[JCAlertView alloc]initWithCustomView:setView dismissWhenTouchedBackground:NO];
        [self.alertView show];
    }
}

//检查消息数目
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [headImageButton setTitle:[NSString stringWithFormat:@"%.2f",[[self getMeModelMessage].account doubleValue]] forState:0];
    [self checkMessageCount];
}


//获取消息数目
- (void)checkMessageCount{
    NSString *url=[NSString stringWithFormat:@"%@%@",APPHOSTURL,getAllMessage];
    [XWNetworking getJsonWithUrl:url params:nil success:^(id response) {
        NSLog(@"返回消息数据：%@",response);
        if (response) {
            NSInteger statusCode=[response integerForKey:@"code"];
            if (statusCode==0) {
                
            }else{
                NSInteger messageCount=[(response[@"data"][@"messagesKhdt"][@"size"]) integerValue]+[(response[@"data"][@"messagesXtxx"][@"size"]) integerValue]+[(response[@"data"][@"messagesYqtz"][@"size"]) integerValue]+[(response[@"data"][@"messagesZc"][@"size"]) integerValue];
                if ([UserDefaults boolForKey:@"haveUnredMsg"]||messageCount>0) {
                    messageLabel.hidden=NO;
                }else{
                    messageLabel.hidden=YES;
                }
            }
        }
    } fail:^(NSError *error) {
    } showHud:NO];
}

//自动登录
- (void)autoLogin{
    NSString *url=[NSString stringWithFormat:@"%@%@",APPHOSTURL,AUTOLOGINURL];
    [XWNetworking postJsonWithUrl:url params:nil success:^(id response) {
        [self saveLoginData:response];
    } fail:^(NSError *error) {
    } showHud:NO];
}


//保存自动登录数据
- (void)saveLoginData:(id)response{
    if (response) {
        NSInteger statusCode=[response integerForKey:@"code"];
        if (statusCode==0) {
        }else{
            NSLog(@"主页自动登录返回的个人数据：%@",response);
            NSString *tokenID=response[@"data"][@"sid"];
            MeModel *me=[MeModel mj_objectWithKeyValues:response[@"data"][@"memberInfo"]];
            [UserDefaults setObject:tokenID forKey:TOKENID ];
            [self saveMeModelMessage:me];
        }
    }
}



//主页产品数据
- (void)saveData:(id)response{
    if (response) {
        NSInteger statusCode=[response integerForKey:@"code"];
        if (statusCode==0) {
            NSString *errorMsg=[response stringForKey:@"message"];
            [MBProgressHUD ToastInformation:errorMsg];
        }else if (statusCode==1){
            self.mainModel=[MainModel mj_objectWithKeyValues:response[@"data"]];
            if (self.mainModel.productList.count>0) {
                [self.headCell setModel:self.mainModel.head];
                self.myTableView.tableHeaderView=self.headCell;
                [self.noMessageView removeFromSuperview];
            }else{
                [self.myTableView addSubview:self.noMessageView];
            }
            [self.myTableView reloadData];
        }
    }
}


#pragma mark 自定义导航栏
- (void)addHeadView{
    headView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
    headView.backgroundColor=[UIColor colorWithHexString:@"#ffffff"];
    headView.alpha=0;
    headView.hidden=NO;
    [self.view addSubview:headView];
    
    titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2.0-100, 20, 200, 44)];
    titleLabel.font=SystemFont(18);
    titleLabel.textAlignment=NSTextAlignmentCenter;
    titleLabel.textColor=[UIColor whiteColor];
    titleLabel.text=@"圈圈保";
    [self.view addSubview:titleLabel];
    
    MeModel *me=[self getMeModelMessage];
    headImageButton=[[UIButton alloc]init];
    [headImageButton addTarget:self action:@selector(toMe:) forControlEvents:UIControlEventTouchUpInside];
    [headImageButton setTitleColor:[UIColor whiteColor] forState:0];
    [headImageButton.titleLabel setFont:SystemFont(15)];
    [headImageButton setImage:[UIImage imageNamed:@"money"] forState:0];
    [headImageButton setTitle:[NSString stringWithFormat:@"%.2f",[me.account doubleValue]] forState:0];
    [headImageButton layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleLeft imageTitleSpace:7];
    [self.view addSubview:headImageButton];
    [headImageButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(20);
        make.height.mas_equalTo(44);
    }];
    
    
    messageButtom=[[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-44-3, 20, 44, 44)];
    [messageButtom setImage:[UIImage imageNamed:@"message"] forState:0];
    [messageButtom addTarget:self action:@selector(toMessage:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:messageButtom];
    
    messageLabel =[[UILabel alloc]initWithFrame:CGRectMake(messageButtom.x+messageButtom.width-15, messageButtom.centerY-12, 10, 10)];
    messageLabel.font=font10;
    messageLabel.hidden=YES;
    messageLabel.textAlignment=NSTextAlignmentCenter;
    messageLabel.textColor=[UIColor whiteColor];
    messageLabel.backgroundColor=[UIColor redColor];
    messageLabel.layer.cornerRadius=5;
    messageLabel.clipsToBounds=YES;
    [self.view addSubview:messageLabel];
    
    
    eyeButton=[[UIButton alloc]init];
    [eyeButton setImage:[UIImage imageNamed:@"close－白"] forState:0];
    [eyeButton setImage:[UIImage imageNamed:@"open－白"] forState:UIControlStateSelected];
    eyeButton.selected=[UserDefaults boolForKey:@"openMoney"];
    [eyeButton addTarget:self action:@selector(eye:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:eyeButton];
    [eyeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(20);
        make.right.mas_equalTo(messageButtom.mas_left).offset(0);
        make.height.mas_equalTo(44);
    }];
    
    line=[[UILabel alloc]init];
    line.backgroundColor=[UIColor colorWithHexString:@"#dcdcdc"];
    line.alpha=0;
    [self.view addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(63.5);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(0.5);
    }];
    
}

//隐藏/显示价钱
- (void)eye:(UIButton *)sender{
    sender.selected=!sender.selected;
    [UserDefaults setBool:sender.selected forKey:@"openMoney"];
    [UserDefaults synchronize];
    [self.myTableView reloadData];
}



#pragma mark 信息
- (void)toMessage:(UIButton *)sender{
    MessageListController *list=[[MessageListController alloc]init];
    list.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:list animated:YES];
}

#pragma mark 我的
- (void)toMe:(UIButton *)sender{
    [MobClick event:@"money"];
    MyMoneyController *myMoney=[[MyMoneyController alloc]init];
    myMoney.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:myMoney animated:YES];
}


#pragma mark uitableview delegate;
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ShouyeContentCell *cell=[tableView dequeueReusableCellWithIdentifier:tableviewContentCell];
    ProductModel *productModel=self.mainModel.productList[indexPath.section];
    ProductContentModel *content=productModel.product[indexPath.row];
    [cell setModel:content];
    return cell;
}


- (CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return (SCREEN_WIDTH-30)*286/690.0+117;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.mainModel.productList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    ProductModel *content=self.mainModel.productList[section];
    NSArray *contentArray=content.product;
    return contentArray.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    ShouyeContentHeadCell *cell=[[[NSBundle mainBundle]loadNibNamed:@"ShouyeContentHeadCell" owner:nil options:nil]lastObject];
    ProductModel *productModel=self.mainModel.productList[section];
    [cell.titleButtom setTitle:productModel.category forState:0];
    cell.frame=CGRectMake(0, 0, SCREEN_WIDTH, 55);
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 55;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section==self.mainModel.productList.count-1) {
        UIView *bottomView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
        bottomView.backgroundColor=[UIColor clearColor];
        UIImageView *dixian=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"底线"]];
        dixian.size=CGSizeMake(177, 15);
        dixian.center=bottomView.center;
        [bottomView addSubview:dixian];
        return bottomView;
    }else{
        return [UIView new];
    }
}

- (CGFloat )tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section==self.mainModel.productList.count-1) {
        return 50;
    }
    return 15;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row==0) {
        [MobClick event:@"productM"];
    }else if (indexPath.row==1){
        [MobClick event:@"productB"];
    }
    ProductModel *productModel=self.mainModel.productList[indexPath.section];
    ProductContentModel *content=productModel.product[indexPath.row];
    BaseWebViewController *webView=[[BaseWebViewController alloc]init];
    webView.urlStr=content.url;
    webView.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:webView animated:YES];
}



#pragma mark ShouyeHeadViewCell_Delegate
- (void)clickCell:(ShouyeHeadViewCell *)cell onTheBannerIndex:(NSInteger )index{
    MainHeadModel *headModel=self.mainModel.head;
    NSArray<ADModel *> *adArr=headModel.ads;
    ADModel *ad=adArr[index];
    BaseWebViewController *webView=[[BaseWebViewController alloc]init];
    webView.urlStr=ad.url;
    webView.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:webView animated:YES];
};


- (void)clickCell:(ShouyeHeadViewCell *)cell onTheCollectionViewIndex:(NSInteger )index{
    MainHeadModel *headModel=self.mainModel.head;
    NSArray<SubIconModel *> *iconArr=headModel.subIcon;
    SubIconModel *icon=iconArr[index];
    if (index==0) {
        [MobClick event:@"productA"];
    }else if (index==1){
        [MobClick event:@"friendQ"];
    }else if (index==2){
        [MobClick event:@"giftT"];
    }
    NSString     *url=icon.url;
    if (0<[self clearSpace:url].length) {
        BaseWebViewController *webView=[[BaseWebViewController alloc]init];
        webView.urlStr=url;
        webView.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:webView animated:YES];
    }else{
        AllProductViewController *product=[[AllProductViewController alloc]init];
        product.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:product animated:YES];
    }
};



#pragma mark scrollerviewdelegate

-( void )scrollViewDidScroll:( UIScrollView *)scrollView {
    if (scrollView.contentOffset.y <0 ){
        //下拉隐藏控件
        headView.alpha=0;
        headImageButton.hidden=YES;
        messageButtom.hidden=YES;
        titleLabel.hidden=YES;
        headView.hidden=YES;
        messageLabel.hidden=YES;
        eyeButton.hidden=YES;
        line.hidden=YES;
        headView.alpha=0;
        line.alpha=0;
        //白色图标
        titleLabel.textColor=[UIColor whiteColor];
        [headImageButton setImage:[UIImage imageNamed:@"money"] forState:0];
        [headImageButton setTitleColor:[UIColor whiteColor] forState:0];
        [messageButtom setImage:[UIImage imageNamed:@"message"] forState:0];
        [eyeButton setImage:[UIImage imageNamed:@"close－白"] forState:0];
        [eyeButton setImage:[UIImage imageNamed:@"open－白"] forState:UIControlStateSelected];
        self.showBlackStatus=NO;
        [self setNeedsStatusBarAppearanceUpdate];
    }else{
        if (scrollView.contentOffset.y<=(SDHEIGHT*0.5)) {
            titleLabel.textColor=[UIColor whiteColor];
            [headImageButton setImage:[UIImage imageNamed:@"money"] forState:0];
            [headImageButton setTitleColor:[UIColor whiteColor] forState:0];
            [messageButtom setImage:[UIImage imageNamed:@"message"] forState:0];
            [eyeButton setImage:[UIImage imageNamed:@"close－白"] forState:0];
            [eyeButton setImage:[UIImage imageNamed:@"open－白"] forState:UIControlStateSelected];
            self.showBlackStatus=NO;
            [self setNeedsStatusBarAppearanceUpdate];
        }else{
            titleLabel.textColor=[UIColor blackColor];
            [headImageButton setImage:[UIImage imageNamed:@"money-black"] forState:0];
            [headImageButton setTitleColor:[UIColor blackColor] forState:0];
            [messageButtom setImage:[UIImage imageNamed:@"message-black"] forState:0];
            [eyeButton setImage:[UIImage imageNamed:@"close"] forState:0];
            [eyeButton setImage:[UIImage imageNamed:@"open"] forState:UIControlStateSelected];
            self.showBlackStatus=YES;
            [self setNeedsStatusBarAppearanceUpdate];
        }
        line.alpha=(scrollView.contentOffset.y/SDHEIGHT>=0.94?0.94:scrollView.contentOffset.y/SDHEIGHT);
        headView.alpha=(scrollView.contentOffset.y/SDHEIGHT>=0.94?0.94:scrollView.contentOffset.y/SDHEIGHT);
        //上推
        headView.hidden=NO;
        //上推改变值
        headImageButton.hidden=NO;
        messageButtom.hidden=NO;
        if ([UserDefaults boolForKey:@"haveUnredMsg"]) {
            messageLabel.hidden=NO;
        }else{
            messageLabel.hidden=YES;
        }
        titleLabel.hidden=NO;
        eyeButton.hidden=NO;
        line.hidden=NO;
    }
}



#pragma mark 增加addMJ_Head
- (void)addMJheader{
    MJHeader *mjHeader=[MJHeader headerWithRefreshingBlock:^{
        NSString *url=[NSString stringWithFormat:@"%@%@",APPHOSTURL,getconfig];
        [XWNetworking getJsonWithUrl:url params:nil responseCache:^(id responseCache) {
            if (responseCache) {
                [self saveData:responseCache];
            }
        } success:^(id response) {
            [self saveData:response];
            [self endFreshAndLoadMore];
        } fail:^(NSError *error) {
            if ([XWNetworking isHaveNetwork]) {
                [MBProgressHUD ToastInformation:@"服务器开小差了"];
            }else{
                [MBProgressHUD ToastInformation:@"网络似乎已断开..."];
            }
            [self endFreshAndLoadMore];
        } showHud:NO];
    }];
    _myTableView.mj_header=mjHeader;
}

#pragma mark 关闭mjrefreshing
- (void)endFreshAndLoadMore{
    [_myTableView.mj_header endRefreshing];
}

#pragma mark 懒加载
- (UITableView *)myTableView{
    if (!_myTableView) {
        _myTableView=[[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _myTableView.backgroundColor=[UIColor clearColor];
        _myTableView.delegate=self;
        _myTableView.dataSource=self;
        _myTableView.sectionFooterHeight=GetHeight(15);
        _myTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
        [_myTableView registerNib:[UINib nibWithNibName:NSStringFromClass([ShouyeContentCell class]) bundle:nil] forCellReuseIdentifier:tableviewContentCell];
        [self.view addSubview:_myTableView];
        _myTableView.sd_layout.topSpaceToView(self.view,0).bottomSpaceToView(self.view,0).widthIs(SCREEN_WIDTH);
        [self addMJheader];
    }
    return _myTableView;
}

- (NSMutableArray *)dataSourceArray{
    if (!_dataSourceArray) {
        _dataSourceArray=[NSMutableArray array];
    }
    return _dataSourceArray;
}


- (ShouyeHeadViewCell *)headCell{
    if (!_headCell) {
        _headCell=[[ShouyeHeadViewCell alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SDHEIGHT+COLLECTIONVIEWHEIGHT+ADVERTISEHEIGHT+15)];
        _headCell.delegate=self;
    }
    return _headCell;
}

- (void)dealloc{
    [NotiCenter removeObserver:self];
}

#pragma mark 电池栏白色
- (UIStatusBarStyle)preferredStatusBarStyle{
    return  self.showBlackStatus?UIStatusBarStyleDefault:UIStatusBarStyleLightContent;
}

//缺省页
- (NomessageView *)noMessageView{
    if (!_noMessageView) {
        _noMessageView=[[NomessageView alloc]init];
        _noMessageView.frame=CGRectMake(0, SCREEN_WIDTH/375.0*90, SCREEN_WIDTH, 180);
        _noMessageView.buttomTitle=@"暂无相关内容";
        _noMessageView.clickBlock=^(){
            
        };
    }
    return _noMessageView;
}

//设置推送别名
- (void)setPushAlias{
    MeModel *me=[self getMeModelMessage];
    [UMessage setAlias:me.mobilephone type:@"com.dajiabao.qqb" response:^(id responseObject, NSError *error) {
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void)alertWithMessage:(NSString *)toastMessage{
    UIAlertController *phoneAlert=[UIAlertController alertControllerWithTitle:@"提醒" message:toastMessage preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel=[UIAlertAction actionWithTitle:@"我知道了" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [phoneAlert addAction:cancel];
    [KeyWindow.rootViewController presentViewController:phoneAlert animated:YES completion:nil];
}


//初始化
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //设置推送别名
    [self setPushAlias];
    //通知banner
    [NotiCenter postNotificationName:@"baner" object:nil];
    RCConnectionStatus status=[[RCIM sharedRCIM] getConnectionStatus];
    if (status==ConnectionStatus_KICKED_OFFLINE_BY_OTHER_CLIENT||status==ConnectionStatus_Unconnected||status==ConnectionStatus_SignUp||status==ConnectionStatus_TOKEN_INCORRECT) {
            [self connectRongyun];
    }
    [MobClick beginLogPageView:@"主页"];
}

/**
 *  连接融云
 */
- (void)connectRongyun{
    MeModel *meModel=[self getMeModelMessage];
    NSLog(@"%@",meModel.ryToken);
    //连接融云
    [[RCIM sharedRCIM] connectWithToken:meModel.ryToken success:^(NSString *userId){
        [UserDefaults setObject:userId forKey:@"myRongyunId"];
        [UserDefaults synchronize];
    } error:^(RCConnectErrorCode status) {
        if (status==RC_CONN_TOKEN_INCORRECT||status==RC_CONN_NOT_AUTHRORIZED||status==RC_INVALID_ARGUMENT) {
            [self getUserToken];
        }
    } tokenIncorrect:^{
        [self getUserToken];
    }];
    [RCIM sharedRCIM].userInfoDataSource = self;
    [RCIM sharedRCIM].receiveMessageDelegate=self;
    [RCIM sharedRCIM].globalNavigationBarTintColor=[UIColor darkGrayColor];
    [RCIM sharedRCIM].globalMessageAvatarStyle=RC_USER_AVATAR_CYCLE;
}

/**
 *  token错误重新获取
 *
 */
- (void)getUserToken{
    NSString *urlStr=[NSString stringWithFormat:@"%@%@",APPHOSTURL,refreshRcToken];
    [XWNetworking postJsonWithUrl:urlStr params:nil success:^(id response) {
        if (response) {
            NSInteger statusCode=[response integerForKey:@"code"];
            if (statusCode==0) {
            }else{
                MeModel  *me=[self getMeModelMessage];
                NSString *rcToken=response[@"data"][@"rytoken"];
                me.ryToken=rcToken;
                [self saveMeModelMessage:me];
                [self connectRongyun];
            }
        }
        if (response) {
            
        }
    } fail:^(NSError *error) {
        
    } showHud:NO];
}


//收到消息
-(BOOL)onRCIMCustomAlertSound:(RCMessage*)message{
    UIViewController *presentController=[self getTopViewController:KeyWindow.rootViewController];
    if (![presentController isMemberOfClass:[ConnectServiceViewController class]]) {
        dispatch_sync(dispatch_get_main_queue(), ^{
            NSString *toastMessage;
            RCMessageContent *content = message.content;
            if ([content isKindOfClass:[RCInformationNotificationMessage class]]) {        

            }else{
                //聊天消息
                if([content isKindOfClass:[RCTextMessage class]]) {
                    RCTextMessage *txtMsg = (RCTextMessage*)content;
                    toastMessage=txtMsg.content;
                }else{
                    toastMessage=@"[图片]";
                }
                [TSMessage showNotificationInViewController:[UIApplication sharedApplication].delegate.window.rootViewController
                                                      title:NSLocalizedString(@"圈圈保客服", nil)
                                                   subtitle:NSLocalizedString(toastMessage, nil)
                                                      image:[UIImage imageNamed:@"通知"]
                                                       type:TSMessageNotificationTypeMessage
                                                   duration:2
                                                   callback:^(){
                                                       ConnectServiceViewController *conversationVC = [[ConnectServiceViewController alloc] init];
                                                       conversationVC.conversationType = ConversationType_CUSTOMERSERVICE;
                                                       conversationVC.targetId =RongCloudServiceID;
                                                       conversationVC.title =@"智能客服";
                                                       conversationVC.hidesBottomBarWhenPushed=YES;
                                                       [presentController.navigationController pushViewController:conversationVC animated:YES];
                                                   }
                                                buttonTitle:nil
                                             buttonCallback:nil
                                                 atPosition:TSMessageNotificationPositionNavBarOverlay
                                       canBeDismissedByUser:YES];
                [UserDefaults setBool:YES forKey:@"haveUnredMsg"];
                [UserDefaults synchronize];
                messageLabel.hidden=NO;
                [NotiCenter postNotificationName:@"haveMessage" object:nil];
            }
        });
    }
    return NO;
}



//获取当前的uiviewController
- (UIViewController *)getTopViewController:(UIViewController *)viewController {
    if ([UserDefaults boolForKey:@"firstLanch"]==NO) {
        //在启动页面
        return  nil;
    }else if([UserDefaults objectForKey:TOKENID]==nil){
        //在登录界面
        return  nil;
    }else{
        if ([viewController isKindOfClass:[UITabBarController class]]) {
            return [self getTopViewController:[(UITabBarController *)viewController selectedViewController]];
        } else if ([viewController isKindOfClass:[UINavigationController class]]) {
            return [self getTopViewController:[(UINavigationController *)viewController topViewController]];
        } else if (viewController.presentedViewController) {
            return [self getTopViewController:viewController.presentedViewController];
        } else {
            return viewController;
        }
    }
}



/**
 *  刷新用户信息
 */
- (void)refreshUserInfo{
    MeModel    *me=[self getMeModelMessage];
    RCUserInfo *user = [[RCUserInfo alloc]init];
    user.userId =[UserDefaults objectForKey:@"myRongyunId"];
    user.name=me.name;
    user.portraitUri =me.picture;
    [[RCIM sharedRCIM] refreshUserInfoCache:user withUserId:[UserDefaults objectForKey:@"myRongyunId"]];
}


/**
 *  信息提供者
 *
 */
- (void)getUserInfoWithUserId:(NSString *)userId completion:(void (^)(RCUserInfo *userInfo))completion{
    NSString *myRongyunId= [UserDefaults objectForKey:@"myRongyunId"];
    if ([myRongyunId isEqual:userId]) {
        MeModel    *me=[self getMeModelMessage];
        RCUserInfo *user = [[RCUserInfo alloc]init];
        user.userId = myRongyunId;
        user.name=me.name;
        user.portraitUri =me.picture;
        return completion(user);
    }
    return completion(nil);
};

/**
 *  融云未读消息
 *
 */
- (void)onRCIMReceiveMessage:(RCMessage *)message left:(int)left{
//    int unread=[[RCIMClient sharedRCIMClient]getUnreadCount:@[@(ConversationType_CUSTOMERSERVICE)]];
//    if (unread>0) {
//        dispatch_sync(dispatch_get_main_queue(), ^{
//            [UserDefaults setBool:YES forKey:@"haveUnredMsg"];
//            [UserDefaults synchronize];
//            [NotiCenter postNotificationName:@"havaUnredMsg" object:nil];
//        });
//    }else{
//        dispatch_sync(dispatch_get_main_queue(), ^{
//            [UserDefaults setBool:NO forKey:@"haveUnredMsg"];
//            [UserDefaults synchronize];
//            [NotiCenter postNotificationName:@"noMessage" object:nil];
//        });
//    }
}


/**
 *  友盟统计页面关闭时间
 *
 */
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"主页"];
}



@end
