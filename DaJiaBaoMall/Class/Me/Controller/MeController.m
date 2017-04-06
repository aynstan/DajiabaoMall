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
#define HEADHEIGHT  SCREEN_WIDTH*445/750.0

@interface MeController ()<UITableViewDelegate,UITableViewDataSource,MeHeadCell_Delegate>{
    UIView *headView;
    UILabel *titleLabel;
    UIImageView *headImage;
    UIButton *setButtom;
}

@property (nonatomic,strong)UITableView *myTableView;

@property (nonatomic,strong)NSMutableArray *dataSourceArray;

@end

static NSString *const tableViewCellIndentifer=@"HeadCell";

static NSString *const tableviewContentCell=@"ContentCell";

@implementation MeController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.bgView.hidden=YES;
    [self.myTableView.mj_header beginRefreshing];
    [self addHeadView];
}

#pragma mark 自定义导航栏
- (void)addHeadView{
    headView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
    headView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"渐变"]];
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
    headImage.image=[UIImage imageNamed:@"会员头像"];
    [self.view addSubview:headImage];
    
    setButtom=[[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-44-12, 20, 44, 44)];
    [setButtom setImage:[UIImage imageNamed:@"安全设置"] forState:0];
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
        return cell;
    }else{
        MeContentCell *cell=[tableView dequeueReusableCellWithIdentifier:tableviewContentCell];
        NSArray *arr=self.dataSourceArray[indexPath.section];
        cell.contentTitle.text=arr[indexPath.row][0];
        cell.isHot.hidden=![arr[indexPath.row][1] integerValue];
        return cell;
    }
}

- (CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        return HEADHEIGHT+50;
    }
    return 45;
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
            NSString *urlStr=@"http://www.sina.com";
            BaseWebViewController *webView=[[BaseWebViewController alloc]init];
            webView.urlStr=urlStr;
            webView.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:webView animated:YES];
        }
    }else if(indexPath.section==2){
        //绑定微信
        [self bangdingWechat];
    }else if (indexPath.section==self.dataSourceArray.count-1) {
        if (indexPath.row==1) {
            //关于我们
            AboutUsController *about=[[AboutUsController alloc]init];
            about.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:about animated:YES];
        }else if (indexPath.row==0){
            //常见问题
            BaseWebViewController *webView=[[BaseWebViewController alloc]init];
            webView.urlStr=@"http://www.baidu.com";
            webView.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:webView animated:YES];
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
                // 授权信息
                NSLog(@"Wechat uid: %@", resp.uid);
                NSLog(@"Wechat openid: %@", resp.openid);
                NSLog(@"Wechat accessToken: %@", resp.accessToken);
                NSLog(@"Wechat refreshToken: %@", resp.refreshToken);
                NSLog(@"Wechat expiration: %@", resp.expiration);
                // 用户信息
                NSLog(@"Wechat name: %@", resp.name);
                NSLog(@"Wechat iconurl: %@", resp.iconurl);
                NSLog(@"Wechat gender: %@", resp.gender);
                // 第三方平台SDK源数据
                NSLog(@"Wechat originalResponse: %@", resp.originalResponse);
            }
        }];
    }else{
        UIAlertController *alertController=[UIAlertController alertControllerWithTitle:@"提醒" message:@"您尚未安装微信客户端，暂无法绑定微信" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction=[UIAlertAction actionWithTitle:@"我知道了" style:UIAlertActionStyleCancel handler:nil];
        [alertController addAction:cancelAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

#pragma mark 增加addMJ_Head
- (void)addMJheader{
    MJHeader *mjHeader=[MJHeader headerWithRefreshingBlock:^{
        [self endFreshAndLoadMore];
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
        _myTableView.sectionFooterHeight=GetHeight(10);
        //_myTableView.separatorColor=colorc3c3c3;
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
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,70*SCREEN_HEIGHT/667.0)];
    view.backgroundColor=[UIColor clearColor];
    
    UIButton *phoneButtom=[[UIButton alloc]init];
    [phoneButtom setTitle:@"客服电话：400-111-4567" forState:0];
    [phoneButtom setTitleColor:[UIColor darkGrayColor] forState:0];
    [phoneButtom.titleLabel setFont:font13];
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
        _dataSourceArray=[[NSMutableArray alloc] initWithObjects:@[@"头部"],@[@[@"我的邀请",@"0"],@[@"邀请朋友一起赚",@"1"]],@[@[@"绑定微信",@"0"]],@[@[@"常见问题",@"0"],@[@"关于我们",@"0"]], nil];
    }
    return _dataSourceArray;
}

#pragma mark 电池栏白色
- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



@end
