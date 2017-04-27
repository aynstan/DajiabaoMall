//
//  SendUnUsedController.m
//  DaJiaBaoMall
//
//  Created by 大家保 on 2017/4/1.
//  Copyright © 2017年 大家保. All rights reserved.
//

#import "SendUnUsedController.h"
#import "SendUnUsedCell.h"
#import "BaseWebViewController.h"
#import "UsedProduct.h"

@interface SendUnUsedController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UITableView *myTableView;

@property (nonatomic,strong)NSMutableArray *dataSourceArray;

@property (nonatomic,assign) NSInteger maxSize;

@property (nonatomic,strong) NomessageView *noMessageView;

@end

static NSString *const tableviewContentCell=@"ContentCell";

@implementation SendUnUsedController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.bgView.hidden=YES;
    [self.myTableView.mj_header beginRefreshing];
}

//保存数据
- (void)saveData:(id)response{
    if (response) {
        NSInteger statusCode=[response integerForKey:@"code"];
        if (statusCode==0) {
            NSString *errorMsg=[response stringForKey:@"message"];
            [MBProgressHUD ToastInformation:errorMsg];
        }else if (statusCode==1){
            [self.dataSourceArray removeAllObjects];
            NSArray *dataArray=[UsedProduct mj_objectArrayWithKeyValuesArray:[response objectForKey:@"data"]];
            [self.dataSourceArray addObjectsFromArray:dataArray];
            if (self.dataSourceArray.count>0) {
                [self.noMessageView removeFromSuperview];
            }else{
                [self.myTableView addSubview:self.noMessageView];
            }
            [self.myTableView reloadData];
        }
    }
}


#pragma mark uitableview delegate;
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SendUnUsedCell *cell=[tableView dequeueReusableCellWithIdentifier:tableviewContentCell];
    UsedProduct *product=self.dataSourceArray[indexPath.section];
    [cell setModel:product];
    return cell;
}


- (CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 68;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataSourceArray.count;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UsedProduct *product=self.dataSourceArray[indexPath.section];
    BaseWebViewController *webView=[[BaseWebViewController alloc]init];
    webView.urlStr=product.url;
    webView.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:webView animated:YES];
}


#pragma mark 增加addMJ_Head
- (void)addMJheader{
    MJHeader *mjHeader=[MJHeader headerWithRefreshingBlock:^{
        NSString *url=[NSString stringWithFormat:@"%@%@",APPHOSTURL,freeinsurance_getused];
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
        _myTableView.tableFooterView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 5)];
        _myTableView.tableHeaderView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 15)];
        _myTableView.sectionFooterHeight=GetHeight(10);
        _myTableView.sectionHeaderHeight=GetHeight(0.0001);
        _myTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
        
        [_myTableView registerNib:[UINib nibWithNibName:NSStringFromClass([SendUnUsedCell class]) bundle:nil] forCellReuseIdentifier:tableviewContentCell];
        [self.view addSubview:_myTableView];
        
        _myTableView.sd_layout.topSpaceToView(self.view,0).bottomSpaceToView(self.view,0).widthIs(SCREEN_WIDTH);
        [self addMJheader];
    }
    return _myTableView;
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

- (NSMutableArray *)dataSourceArray{
    if (!_dataSourceArray) {
        _dataSourceArray=[NSMutableArray array];
    }
    return _dataSourceArray;
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
    [MobClick beginLogPageView:@"赠客产品_已使用"];
}
/**
 *  友盟统计页面关闭时间
 *
 */
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"赠客产品_已使用"];
}

@end
