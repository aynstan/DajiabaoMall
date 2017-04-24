//
//  MeController.m
//  DaJiaBaoMall
//
//  Created by 大家保 on 2017/3/27.
//  Copyright © 2017年 大家保. All rights reserved.
//

#import "MeController.h"
#import "MeHeadCell.h"
#import "MeContentCell.h"
#import "AboutUsController.h"
#import "BaseWebViewController.h"
#import "MyMessageControllerViewController.h"
#import "WXApi.h"
#import "MyMoneyController.h"
#import "SetController.h"
#import "MyOrderListController.h"
#import "MyInViteListController.h"
#import "MeModel.h"
#define HEADHEIGHT  SCREEN_WIDTH*318/750.0

@interface MeController ()<UITableViewDelegate,UITableViewDataSource,MeHeadCell_Delegate>{
    UIView *headView;
    UILabel *titleLabel;
    UIImageView *headImage;
    UIButton *setButtom;
}

@property (nonatomic,strong)UITableView *myTableView;

@property (nonatomic,strong)NSMutableArray *dataSourceArray;

@property (nonatomic,strong) MeModel *meModel;

@end

static NSString *const tableViewCellIndentifer=@"HeadCell";

static NSString *const tableviewContentCell=@"ContentCell";

@implementation MeController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.bgView.hidden=YES;
    self.meModel=[self getMeModelMessage];
    [self.myTableView.mj_header beginRefreshing];
    [self addHeadView];
    //添加更改头像通知
    [NotiCenter addObserver:self selector:@selector(changeHeadImage) name:@"changeUserInfor" object:nil];
}

//保存数据
- (void)saveData:(id)response{
    if (response) {
        NSInteger statusCode=[response integerForKey:@"code"];
        if (statusCode==0) {
            NSString *errorMsg=[response stringForKey:@"message"];
            [MBProgressHUD ToastInformation:errorMsg];
        }else if (statusCode==1){
            WeakSelf;
            weakSelf.meModel=[MeModel mj_objectWithKeyValues:[response objectForKey:@"data"]];
            [weakSelf saveMeModelMessage:self.meModel];
            [headImage sd_setImageWithURL:[NSURL URLWithString:self.meModel.picture] placeholderImage:[UIImage imageNamed:@"head-portrait-big"]];
            [weakSelf.myTableView reloadData];
        }
    }
}

//更改头像
- (void)changeHeadImage{
    WeakSelf;
    weakSelf.meModel=[self getMeModelMessage];
    [headImage sd_setImageWithURL:[NSURL URLWithString:weakSelf.meModel.picture] placeholderImage:[UIImage imageNamed:@"head-portrait-big"]];
    [weakSelf.myTableView reloadData];
}


#pragma mark 自定义导航栏
- (void)addHeadView{
    headView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
    headView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg"]];
    headView.alpha=0;
    headView.hidden=YES;
    [self.view addSubview:headView];
    
    titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(64, 20, SCREEN_WIDTH-128, 44)];
    titleLabel.font=[UIFont systemFontOfSize:18];
    titleLabel.textAlignment=NSTextAlignmentCenter;
    titleLabel.textColor=[UIColor whiteColor];
    titleLabel.text=@"我的";
    titleLabel.hidden=YES;
    [self.view addSubview:titleLabel];
    
    headImage=[[UIImageView alloc]initWithFrame:CGRectMake(12, 27, 30, 30)];
    headImage.layer.cornerRadius=15;
    headImage.clipsToBounds=YES;
    headImage.hidden=YES;
    [headImage sd_setImageWithURL:[NSURL URLWithString:self.meModel.picture] placeholderImage:[UIImage imageNamed:@"head-portrait-big"]];
    [self.view addSubview:headImage];
    
    setButtom=[[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-44-12, 20, 44, 44)];
    [setButtom setImage:[UIImage imageNamed:@"设置"] forState:0];
    [setButtom addTarget:self action:@selector(toSet) forControlEvents:UIControlEventTouchUpInside];
    setButtom.hidden=NO;
    [self.view addSubview:setButtom];
}

#pragma mark 跳转设置界面
- (void)toSet{
    SetController *set=[[SetController alloc]init];
    set.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:set animated:YES];
}

#pragma mark 拨打电话
- (void)toCall:(UIButton *)sender{
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

#pragma mark uitableview delegate;
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        MeHeadCell *cell=[tableView dequeueReusableCellWithIdentifier:tableViewCellIndentifer];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        cell.delegate=self;
        [cell setModel:self.meModel];
        return cell;
    }else{
        MeContentCell *cell=[tableView dequeueReusableCellWithIdentifier:tableviewContentCell];
        NSArray *arr=self.dataSourceArray[indexPath.section];
        cell.contentTitle.text=arr[indexPath.row][0];
        cell.isHot.hidden=![arr[indexPath.row][1] integerValue];
        cell.hadImage.image=[UIImage imageNamed:arr[indexPath.row][2]];
        if (indexPath.row==2) {
            cell.subTile.text=self.meModel.weixinauth==false?@"未绑定":@"已绑定";
            cell.forwarImage.hidden=(self.meModel.weixinauth==false?NO:YES);
            cell.widthConstens.constant=(self.meModel.weixinauth==false?7:0);
            cell.heithConstens.constant=(self.meModel.weixinauth==false?12:0);
            cell.rightContents.constant=(self.meModel.weixinauth==false?15:0);
            cell.selectionStyle=self.meModel.weixinauth==false?UITableViewCellSelectionStyleDefault:UITableViewCellSelectionStyleNone;
        }
        return cell;
    }
}

- (CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        return HEADHEIGHT+90;
    }
    return 50;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataSourceArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *arr=self.dataSourceArray[section];
    return arr.count;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section==1) {
        if (indexPath.row==0) {
            //我的邀请
            MyInViteListController *invite=[[MyInViteListController alloc]init];
            invite.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:invite animated:YES];
        }else if (indexPath.row==1){
            //邀请好友一起赚
            NSString *urlStr=[NSString stringWithFormat:@"%@%@",H5HOSTURL,inviteFrend];
            //NSString *urlStr=@"http://sns.wap.yulin.dev.dajiabao.com/sns/wap/zengxian/success?memberId=71";
            BaseWebViewController *webView=[[BaseWebViewController alloc]init];
            webView.urlStr=urlStr;
            webView.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:webView animated:YES];
        }else if (indexPath.row==2){
            //绑定微信
            if (self.meModel.weixinauth==false) {
                [self bangdingWechat];
            }
        }else if (indexPath.row==3){
            //常见问题
            BaseWebViewController *webView=[[BaseWebViewController alloc]init];
            webView.urlStr=[NSString stringWithFormat:@"%@%@",H5HOSTURL,qa];;
            webView.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:webView animated:YES];
        }else if (indexPath.row==4){
            //关于我们
            AboutUsController *about=[[AboutUsController alloc]init];
            about.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:about animated:YES];
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
                NSString *url=[NSString stringWithFormat:@"%@%@",APPHOSTURL,wechatInLine];
                NSDictionary *dic=@{@"wxToken":resp.uid,@"wxName":resp.name,@"wximage":resp.iconurl};
                [XWNetworking postJsonWithUrl:url params:dic success:^(id response) {
                    if (response) {
                        WeakSelf;
                        NSInteger statusCode=[response integerForKey:@"code"];
                        if (statusCode==0) {
                            NSString *errorMsg=[response stringForKey:@"message"];
                            [MBProgressHUD ToastInformation:errorMsg];
                        }else{
                            [weakSelf saveData:response];
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
        WeakSelf;
        [weakSelf presentViewController:alertController animated:YES completion:nil];
    }
}

#pragma mark 增加addMJ_Head
- (void)addMJheader{
    MJHeader *mjHeader=[MJHeader headerWithRefreshingBlock:^{
        NSString *url=[NSString stringWithFormat:@"%@%@",APPHOSTURL,personinfo];
        [XWNetworking getJsonWithUrl:url params:nil responseCache:^(id responseCache) {
            if (responseCache) {
                [self saveData:responseCache];
            }
        } success:^(id response) {
            [self saveData:response];
            [self endFreshAndLoadMore];
        } fail:^(NSError *error) {
            [MBProgressHUD ToastInformation:@"服务器开小差了"];
            [self endFreshAndLoadMore];
        } showHud:NO];
    }];
    _myTableView.mj_header=mjHeader;
}


#pragma mark 关闭mjrefreshing
- (void)endFreshAndLoadMore{
    [_myTableView.mj_header endRefreshing];
}

#pragma mark 懒加载tableView
- (UITableView *)myTableView{
    if (!_myTableView) {
        _myTableView=[[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _myTableView.backgroundColor=[UIColor clearColor];
        _myTableView.delegate=self;
        _myTableView.dataSource=self;
        _myTableView.tableHeaderView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.0001)];
        _myTableView.tableFooterView=[self tableViewFootView];
        _myTableView.sectionHeaderHeight=0.0001;
        _myTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
        
        [_myTableView registerNib:[UINib nibWithNibName:NSStringFromClass([MeHeadCell class]) bundle:nil] forCellReuseIdentifier:tableViewCellIndentifer];
        
        [_myTableView registerNib:[UINib nibWithNibName:NSStringFromClass([MeContentCell class]) bundle:nil] forCellReuseIdentifier:tableviewContentCell];
        
        [self.view addSubview:_myTableView];
        
        _myTableView.sd_layout.leftSpaceToView(self.view,0).topSpaceToView(self.view,0).rightSpaceToView(self.view,0).bottomSpaceToView(self.view,0);
        [self addMJheader];
    }
    return _myTableView;
}

#pragma mark 头视图的代理方法
- (void)clickIncell:(MeHeadCell *)cell onTheChangeButtom:(UIButton *)sender{
    MyMessageControllerViewController *myMessage=[[MyMessageControllerViewController alloc]init];
    myMessage.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:myMessage animated:YES];
};

//我的订单
- (void)clickIncell:(MeHeadCell *)cell onTheMyOrderButtom:(UIButton *)sender{
    MyOrderListController *list=[[MyOrderListController alloc]init];
    list.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:list animated:YES];
};

//我的钱包
- (void)clickIncell:(MeHeadCell *)cell onTheMyMoneyButtom:(UIButton *)sender{
    MyMoneyController *money=[[MyMoneyController alloc]init];
    money.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:money animated:YES];
};



#pragma mark 客服电话
- (UIView *)tableViewFootView{
    
    UIView *view=[[UIView alloc]init];
    if (SCREEN_WIDTH>375) {
        view.frame=CGRectMake(0, 0, SCREEN_WIDTH,115*SCREEN_HEIGHT/667.0);
    }else{
        view.frame=CGRectMake(0, 0, SCREEN_WIDTH,80*SCREEN_HEIGHT/667.0);
    }
    view.backgroundColor=[UIColor clearColor];
    
    UIButton *phoneButtom=[[UIButton alloc]init];
    [phoneButtom setTitle:@"客服电话：400-111-4567" forState:0];
    [phoneButtom setTitleColor:[UIColor colorWithHexString:@"9d9d9d"] forState:0];
    [phoneButtom.titleLabel setFont:font12];
    [phoneButtom addTarget:self action:@selector(toCall:) forControlEvents:UIControlEventTouchUpInside];
    phoneButtom.backgroundColor=[UIColor clearColor];
    [view addSubview:phoneButtom];
    [phoneButtom mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(35);
        make.centerX.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
    return view;
}

#pragma mark scrollerviewdelegate
-( void )scrollViewDidScroll:( UIScrollView *)scrollView {
    if (scrollView==_myTableView&&scrollView.contentOffset.y <0 ){
        //下拉隐藏控件
        headView.alpha=0;
        headView.hidden=YES;
        titleLabel.hidden=YES;
        headImage.hidden=YES;
        setButtom.hidden=YES;
    }else if(scrollView==_myTableView&&scrollView.contentOffset.y >=0){
        setButtom.hidden=NO;
        if (scrollView.contentOffset.y>=HEADHEIGHT-64-20) {
            titleLabel.hidden=NO;
            headImage.hidden=NO;
        }else {
            titleLabel.hidden=YES;
            headImage.hidden=YES;
        }
        headView.hidden=NO;
        headView.alpha=scrollView.contentOffset.y/(HEADHEIGHT-64);
    }
}


#pragma mark 数据源
- (NSMutableArray *)dataSourceArray{
    if (!_dataSourceArray) {
        _dataSourceArray=[[NSMutableArray alloc] initWithObjects:@[@"头部"],@[@[@"我的邀请",@"0",@"我的邀请"],@[@"邀请朋友一起赚",@"1",@"邀请朋友一起赚"],@[@"绑定微信",@"0",@"绑定"],@[@"常见问题",@"0",@"常见问题"],@[@"关于我们",@"0",@"关于我们"]], nil];
    }
    return _dataSourceArray;
}

#pragma mark 电池栏白色
- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

//移除通知
- (void)dealloc{
    [NotiCenter removeObserver:self];
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
    [MobClick beginLogPageView:@"我的"];
}
/**
 *  友盟统计页面关闭时间
 *
 */
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"我的"];
}



@end
