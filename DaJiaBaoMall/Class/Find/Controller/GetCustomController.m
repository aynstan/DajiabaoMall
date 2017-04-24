//
//  GetCustomController.m
//  DaJiaBaoMall
//
//  Created by 大家保 on 2017/3/27.
//  Copyright © 2017年 大家保. All rights reserved.
//

#import "GetCustomController.h"
#import "GetCustomCell.h"
#import "BaseWebViewController.h"
#import "SendProductController.h"
#import "ChaojiHuoKeController.h"
#import "OYCountDownManager.h"
#import "CustomCatogoryModel.h"

@interface GetCustomController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UITableView *myTableView;

@property (nonatomic,strong)NSMutableArray *dataSourceArray;

@property (nonatomic,strong) NomessageView *noMessageView;

@end

static NSString *const tableviewCellIndentifer=@"Cell";

@implementation GetCustomController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.bgView.hidden=YES;
    [self.myTableView.mj_header beginRefreshing];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [kCountDownManager stop];
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
            NSArray<CustomCatogoryModel *> *catogoryArr=[CustomCatogoryModel mj_objectArrayWithKeyValuesArray:response[@"data"]];
            [self.dataSourceArray addObjectsFromArray:catogoryArr];
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
    GetCustomCell *cell=[tableView dequeueReusableCellWithIdentifier:tableviewCellIndentifer];
    CustomCatogoryModel *catogory=self.dataSourceArray[indexPath.section];
    Huoke *huoke=catogory.data[indexPath.row];
    [cell setModel:huoke];
    return cell;
}


- (CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataSourceArray.count;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    CustomCatogoryModel *catogory=self.dataSourceArray[section];
    return catogory.data.count;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CustomCatogoryModel *catogory=self.dataSourceArray[indexPath.section];
    if (catogory.type==1) {
        SendProductController *send=[[SendProductController alloc]init];
        send.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:send animated:YES];
    }else if (catogory.type==2){
        ChaojiHuoKeController *huoke=[[ChaojiHuoKeController alloc]init];
        huoke.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:huoke animated:YES];
    }else{
        if (indexPath.row==0) {
            [MobClick event:@"article"];
        }else if (indexPath.row==1){
            [MobClick event:@"card"];
        }else if (indexPath.row==2){
            [MobClick event:@"talk"];
        }
        Huoke *huoke=catogory.data[indexPath.row];
        BaseWebViewController *webView=[[BaseWebViewController alloc]init];
        webView.urlStr=huoke.url;
        webView.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:webView animated:YES];
        
    }
}


#pragma mark 增加addMJ_Head
- (void)addMJheader{
    MJHeader *mjHeader=[MJHeader headerWithRefreshingBlock:^{
        NSString *url=[NSString stringWithFormat:@"%@%@",APPHOSTURL,gethuoke];
        [XWNetworking getJsonWithUrl:url params:nil success:^(id response) {
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

#pragma mark 懒加载
- (UITableView *)myTableView{
    if (!_myTableView) {
        _myTableView=[[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _myTableView.backgroundColor=[UIColor clearColor];
        _myTableView.delegate=self;
        _myTableView.dataSource=self;
        _myTableView.tableFooterView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.0001)];
        _myTableView.tableHeaderView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 15)];
        _myTableView.sectionHeaderHeight=0.0001;
        _myTableView.sectionFooterHeight=GetHeight(15);
        _myTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
        [_myTableView registerNib:[UINib nibWithNibName:NSStringFromClass([GetCustomCell class]) bundle:nil] forCellReuseIdentifier:tableviewCellIndentifer];
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
    [MobClick beginLogPageView:@"展业获客神器"];
}
/**
 *  友盟统计页面关闭时间
 *
 */
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"展业获客神器"];
}


@end
