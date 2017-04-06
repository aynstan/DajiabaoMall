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
#define SDHEIGHT             SCREEN_WIDTH/2.0
#define COLLECTIONVIEWHEIGHT 80
#define ADVERTISEHEIGHT      40
#define SPACE_ITEM           10


@interface MainController ()<UITableViewDelegate,UITableViewDataSource,ShouyeHeadViewCell_Delegate>{
    UIView *headView;
    UILabel *titleLabel;
    UIButton *headImageButton;
    UIButton *messageButtom;
    UILabel *messageLabel;
    UILabel *moneyLabel;
}


@property (nonatomic,strong)UITableView *myTableView;

@property (nonatomic,strong)NSMutableArray *dataSourceArray;

@property (nonatomic,assign) NSInteger maxSize;

@property (nonatomic,assign) BOOL showBlackStatus;

@end

static NSString *const tableviewHeadCell=@"HeadCell";

static NSString *const tableviewContentCell=@"ContentCell";

@implementation MainController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.bgView.hidden=YES;
    [self.myTableView.mj_header beginRefreshing];
    [self addHeadView];
    
}

#pragma mark 自定义导航栏
- (void)addHeadView{
    headView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
    headView.backgroundColor=[UIColor whiteColor];
    headView.alpha=1;
    headView.hidden=NO;
    [self.view addSubview:headView];
    
    titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2.0-100, 20, 200, 44)];
    titleLabel.font=[UIFont systemFontOfSize:18];
    titleLabel.textAlignment=NSTextAlignmentCenter;
    titleLabel.textColor=[UIColor blackColor];
    titleLabel.text=@"大家保";
    [self.view addSubview:titleLabel];
    
    headImageButton=[[UIButton alloc]initWithFrame:CGRectMake(12, 27, 30, 30)];
    headImageButton.layer.cornerRadius=15;
    headImageButton.clipsToBounds=YES;
    [headImageButton addTarget:self action:@selector(toMe:) forControlEvents:UIControlEventTouchUpInside];
    [headImageButton setImage:[UIImage imageNamed:@"个人中心_black"] forState:0];
    [self.view addSubview:headImageButton];
    
    moneyLabel=[[UILabel alloc]initWithFrame:CGRectMake(headImageButton.x+headImageButton.width, headImageButton.centerY-6, 150, 12)];
    moneyLabel.textColor=[UIColor blackColor];
    moneyLabel.text=@"¥91.00";
    moneyLabel.font=font12;
    [self.view addSubview:moneyLabel];
    
    messageButtom=[[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-44-12, 20, 44, 44)];
    [messageButtom setImage:[UIImage imageNamed:@"news_black"] forState:0];
    [messageButtom addTarget:self action:@selector(toMessage:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:messageButtom];
    
    messageLabel =[[UILabel alloc]initWithFrame:CGRectMake(messageButtom.x+messageButtom.width-20, messageButtom.centerY-12, 15, 10)];
    messageLabel.font=font10;
    messageLabel.textAlignment=NSTextAlignmentCenter;
    messageLabel.text=@"5";
    messageLabel.textColor=[UIColor whiteColor];
    messageLabel.backgroundColor=[UIColor redColor];
    messageLabel.layer.cornerRadius=5;
    messageLabel.clipsToBounds=YES;
    [self.view addSubview:messageLabel];
}

#pragma mark 信息
- (void)toMessage:(UIButton *)sender{
    MessageListController *list=[[MessageListController alloc]init];
    list.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:list animated:YES];
}

#pragma mark 我的
- (void)toMe:(UIButton *)sender{
    MyMoneyController *myMoney=[[MyMoneyController alloc]init];
    myMoney.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:myMoney animated:YES];
}


#pragma mark uitableview delegate;
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        ShouyeHeadViewCell *cell=[tableView dequeueReusableCellWithIdentifier:tableviewHeadCell];
        cell.delegate=self;
        [cell setMode];
        return cell;
    }else{
        ShouyeContentCell *cell=[tableView dequeueReusableCellWithIdentifier:tableviewContentCell];
        return cell;
    }
}


- (CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        return SDHEIGHT+COLLECTIONVIEWHEIGHT+ADVERTISEHEIGHT+SPACE_ITEM;
    }
    return 340;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
        return 1;
    }else if (section==1){
        return 1;
    }
    return 3;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return [UIView new];
    }else{
        ShouyeContentHeadCell *cell=[[[NSBundle mainBundle]loadNibNamed:@"ShouyeContentHeadCell" owner:nil options:nil]lastObject];
        cell.frame=CGRectMake(0, 0, SCREEN_WIDTH, 80);
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return 0.000001;
    }else{
        return 80;
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    BaseWebViewController *webView=[[BaseWebViewController alloc]init];
    webView.urlStr=@"http://www.baidu.com";
    webView.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:webView animated:YES];
}



#pragma mark ShouyeHeadViewCell_Delegate

- (void)clickCell:(ShouyeHeadViewCell *)cell onTheBannerIndex:(NSInteger )index{
    BaseWebViewController *webView=[[BaseWebViewController alloc]init];
    webView.urlStr=@"http://www.baidu.com";
    webView.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:webView animated:YES];
};

- (void)clickCell:(ShouyeHeadViewCell *)cell onTheCollectionViewIndex:(NSInteger )index{
    if (index==0) {
        AllProductViewController *product=[[AllProductViewController alloc]init];
        product.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:product animated:YES];
    }else if (index==1){
        BaseWebViewController *webView=[[BaseWebViewController alloc]init];
        webView.urlStr=@"http://www.baidu.com";
        webView.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:webView animated:YES];
    }else if (index==2){
        BaseWebViewController *webView=[[BaseWebViewController alloc]init];
        webView.urlStr=@"http://www.baidu.com";
        webView.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:webView animated:YES];
    }
};

- (void)clickCell:(ShouyeHeadViewCell *)cell onTheAdvertiserIndex:(NSInteger )index{
    NSLog(@"点击了第%ld个通知",(long)index);
};

#pragma mark scrollerviewdelegate

//-( void )scrollViewDidScroll:( UIScrollView *)scrollView {
//    if (scrollView.contentOffset.y <0 ){
//        //下拉隐藏控件
//        [headImageButton setImage:[UIImage imageNamed:@"个人中心_white"] forState:0];
//        [messageButtom setImage:[UIImage imageNamed:@"news_white"] forState:0];
//        titleLabel.textColor=[UIColor whiteColor];
//        [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleLightContent];
//        headView.alpha=0;
//        headImageButton.hidden=YES;
//        messageButtom.hidden=YES;
//        titleLabel.hidden=YES;
//        headView.hidden=YES;
//        messageLabel.hidden=YES;
//        moneyLabel.hidden=YES;
//        self.showBlackStatus=YES;
//        [self setNeedsStatusBarAppearanceUpdate];
//    }else{
//        //上推
//        headView.hidden=NO;
//        headView.alpha=scrollView.contentOffset.y/44.0;
//        //上推改变值
//        headImageButton.hidden=NO;
//        messageButtom.hidden=NO;
//        moneyLabel.hidden=NO;
//        messageLabel.hidden=NO;
//        titleLabel.hidden=NO;
//        if (scrollView.contentOffset.y>=40) {
//            [headImageButton setImage:[UIImage imageNamed:@"个人中心_black"] forState:0];
//            [messageButtom setImage:[UIImage imageNamed:@"news_black"] forState:0];
//            titleLabel.textColor=[UIColor darkGrayColor];
//            moneyLabel.textColor=[UIColor darkGrayColor];
//            self.showBlackStatus=YES;
//            [self setNeedsStatusBarAppearanceUpdate];
//        }else{
//            [headImageButton setImage:[UIImage imageNamed:@"个人中心_white"] forState:0];
//            [messageButtom setImage:[UIImage imageNamed:@"news_white"] forState:0];
//            titleLabel.textColor=[UIColor whiteColor];
//            moneyLabel.textColor=[UIColor whiteColor];
//            self.showBlackStatus=NO;
//            [self setNeedsStatusBarAppearanceUpdate];
//        }
//    }
//}



#pragma mark 增加addMJ_Head
- (void)addMJheader{
    MJHeader *mjHeader=[MJHeader headerWithRefreshingBlock:^{
        [self endFreshAndLoadMore];
    }];
    _myTableView.mj_header=mjHeader;
}

#pragma mark 增加addMJ_Footer
- (void)addMJ_Footer{
    MJFooter *mjFooter=[MJFooter footerWithRefreshingBlock:^{
        [self endFreshAndLoadMore];
    }];
    _myTableView.mj_footer=mjFooter;
}

#pragma mark 关闭mjrefreshing
- (void)endFreshAndLoadMore{
    [_myTableView.mj_header endRefreshing];
    if (self.dataSourceArray.count>=self.maxSize) {
        [_myTableView.mj_footer endRefreshingWithNoMoreData];
    }else{
        [_myTableView.mj_footer endRefreshing];
    }
}

#pragma mark 懒加载
- (UITableView *)myTableView{
    if (!_myTableView) {
        _myTableView=[[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _myTableView.backgroundColor=[UIColor clearColor];
        _myTableView.delegate=self;
        _myTableView.dataSource=self;
        _myTableView.tableFooterView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.0001)];
        _myTableView.tableHeaderView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.0001)];
        _myTableView.sectionFooterHeight=GetHeight(10);
        //_myTableView.separatorInset=UIEdgeInsetsMake(0, 0, 0, 0);
        _myTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
        
        [_myTableView registerClass:[ShouyeHeadViewCell class] forCellReuseIdentifier:tableviewHeadCell];
        
        [_myTableView registerNib:[UINib nibWithNibName:NSStringFromClass([ShouyeContentCell class]) bundle:nil] forCellReuseIdentifier:tableviewContentCell];
        
        [self.view addSubview:_myTableView];
        _myTableView.sd_layout.leftSpaceToView(self.view,0).topSpaceToView(self.view,64).rightSpaceToView(self.view,0).bottomSpaceToView(self.view,0);
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

#pragma mark 电池栏白色
- (UIStatusBarStyle)preferredStatusBarStyle{
    return  self.showBlackStatus==NO?UIStatusBarStyleDefault:UIStatusBarStyleLightContent;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



@end
