//
//  CurrentInviteController.m
//  DaJiaBaoMall
//
//  Created by 大家保 on 2017/3/31.
//  Copyright © 2017年 大家保. All rights reserved.
//

#import "CurrentInviteController.h"
#import "InviteCell.h"
#import "InviteHeadView.h"
#import "InviteModel.h"
#import "BaseWebViewController.h"

@interface CurrentInviteController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UITableView *myTableView;

@property (nonatomic,strong)NSMutableArray *dataSourceArray;

@property (nonatomic,strong) InviteModel *inviteModel;

@property (nonatomic,strong) NomessageView *noMessageView;

@end

static NSString *const tableviewCellIndentifer=@"Cell";

@implementation CurrentInviteController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.bgView.hidden=YES;
    [self.myTableView.mj_header beginRefreshing];
}

#pragma mark 下拉刷新
- (void)savelist:(id)response{
    NSLog(@"%@",response);
    if (response) {
        NSInteger statusCode=[response integerForKey:@"code"];
        if (statusCode==0) {
            NSString *errorMsg=[response stringForKey:@"msg"];
            [MBProgressHUD ToastInformation:errorMsg];
        }else{
            [self.dataSourceArray removeAllObjects];
            self.inviteModel=[InviteModel mj_objectWithKeyValues:response[@"data"]];
            [self.dataSourceArray addObjectsFromArray:self.inviteModel.data];
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
    InviteCell *cell=[tableView dequeueReusableCellWithIdentifier:tableviewCellIndentifer];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    InvitePersonModel *personModel=self.inviteModel.data[indexPath.row];
    cell.type=0;
    [cell setModel:personModel];
    return cell;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (self.dataSourceArray.count>0){
        UIView *clearView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 70)];
        clearView.backgroundColor=[UIColor clearColor];
        InviteHeadView *headView=[[[NSBundle mainBundle]loadNibNamed:@"InviteHeadView" owner:nil options:nil]lastObject];
        headView.frame=CGRectMake(0, 0, SCREEN_WIDTH, 70);
        [headView setModel:self.inviteModel];
        [clearView addSubview:headView];
        return clearView;
    }else{
        return [UIView new];
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (self.dataSourceArray.count>0) {
        return 70;
    }else{
        return 0.001;
    }
}


- (CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 64;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.inviteModel.data.count;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    InvitePersonModel *personModel=self.inviteModel.data[indexPath.row];
    if (0<personModel.url.length) {
        BaseWebViewController *webView=[[BaseWebViewController alloc]init];
        webView.urlStr=personModel.url;
        webView.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:webView animated:YES];
    }
}


#pragma mark 增加addMJ_Head
- (void)addMJheader{
    MJHeader *mjHeader=[MJHeader headerWithRefreshingBlock:^{
         NSString *url=[NSString stringWithFormat:@"%@%@",APPHOSTURL,monthInvite];
         [XWNetworking getJsonWithUrl:url params:nil responseCache:^(id responseCache) {
          if (responseCache) {
                [self savelist:responseCache];
            }
         } success:^(id response) {
            [self savelist:response];
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
        _myTableView.tableFooterView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.0001)];
        _myTableView.tableHeaderView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 15)];
        _myTableView.sectionFooterHeight=0.001;
        _myTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
        
        [_myTableView registerNib:[UINib nibWithNibName:NSStringFromClass([InviteCell class]) bundle:nil] forCellReuseIdentifier:tableviewCellIndentifer];
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
    [MobClick beginLogPageView:@"我的邀请-当月邀请"];
}
/**
 *  友盟统计页面关闭时间
 *
 */
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"我的邀请-当月邀请"];
}



@end
