//
//  BankListController.m
//  DaJiaBaoMall
//
//  Created by 大家保 on 2017/3/31.
//  Copyright © 2017年 大家保. All rights reserved.
//

#import "BankListController.h"
#import "BankListCell.h"
#import "BankModel.h"

@interface BankListController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UITableView *myTableView;

@property (nonatomic,strong)NSMutableArray *dataSourceArray;

@property (nonatomic,strong) NomessageView *noMessageView;

@end

static NSString *const tableviewCellIndentifer=@"Cell";

@implementation BankListController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addTitle:@"银行"];
    [self addLeftButton];
    [self.myTableView.mj_header beginRefreshing];
}

//保存数据
- (void)saveData:(id)response{
    if (response) {
        NSLog(@"银行=%@",response);
        NSInteger statusCode=[response integerForKey:@"code"];
        if (statusCode==0) {
            NSString *errorMsg=[response stringForKey:@"message"];
            [MBProgressHUD ToastInformation:errorMsg];
        }else if (statusCode==1){
            [self.dataSourceArray removeAllObjects];
            NSArray<BankModel *> *array=[BankModel mj_objectArrayWithKeyValuesArray:response[@"data"]];
            self.dataSourceArray=[NSMutableArray arrayWithArray:array];
            if (self.dataSourceArray.count>0) {
                [self.noMessageView removeFromSuperview];
            }else{
                [self.myTableView addSubview:self.noMessageView];
            }
            [self.myTableView reloadData];
            [self.myTableView reloadData];
        }
    }
}

#pragma mark uitableview delegate;
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BankListCell *cell=[tableView dequeueReusableCellWithIdentifier:tableviewCellIndentifer];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    BankModel *bankeModel=self.dataSourceArray[indexPath.row];
    [cell setModel:bankeModel];
    cell.line.hidden=indexPath.row==self.dataSourceArray.count-1;
    return cell;
}


- (CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSourceArray.count;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    BankModel *bankModel=self.dataSourceArray[indexPath.row];
    self.BankNameBlock?self.BankNameBlock(bankModel.name,bankModel.type):nil;
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark 增加addMJ_Head
- (void)addMJheader{
    MJHeader *mjHeader=[MJHeader headerWithRefreshingBlock:^{
        NSString *url=[NSString stringWithFormat:@"%@%@",APPHOSTURL,bankList];
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
        _myTableView.tableFooterView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.0001)];
        _myTableView.tableHeaderView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 15)];
        _myTableView.sectionHeaderHeight=15;
        _myTableView.sectionFooterHeight=0.001;
        _myTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
        
        [_myTableView registerNib:[UINib nibWithNibName:NSStringFromClass([BankListCell class]) bundle:nil] forCellReuseIdentifier:tableviewCellIndentifer];
        [self.view addSubview:_myTableView];
        _myTableView.sd_layout.topSpaceToView(self.view,64).bottomSpaceToView(self.view,0).widthIs(SCREEN_WIDTH);
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
    [MobClick beginLogPageView:@"银行列表"];
}
/**
 *  友盟统计页面关闭时间
 *
 */
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"银行列表"];
}



@end
