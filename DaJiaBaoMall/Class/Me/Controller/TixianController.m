//
//  TixianController.m
//  DaJiaBaoMall
//
//  Created by 大家保 on 2017/3/31.
//  Copyright © 2017年 大家保. All rights reserved.
//

#import "TixianController.h"
#import "TixianCell.h"

@interface TixianController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UITableView *myTableView;

@property (nonatomic,strong)NSMutableArray *dataSourceArray;

@property (nonatomic,assign) NSInteger maxSize;


@end

@implementation TixianController

static NSString *const tableviewCellIndentifer=@"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.bgView.hidden=YES;
    [self.myTableView.mj_header beginRefreshing];
}

#pragma mark uitableview delegate;
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TixianCell *cell=[tableView dequeueReusableCellWithIdentifier:tableviewCellIndentifer];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}


- (CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}


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
        _myTableView.tableHeaderView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
        _myTableView.sectionHeaderHeight=10;
        _myTableView.sectionFooterHeight=0.001;
        _myTableView.separatorInset=UIEdgeInsetsMake(0, 0, 0, 0);
        _myTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
        
        [_myTableView registerNib:[UINib nibWithNibName:NSStringFromClass([TixianCell class]) bundle:nil] forCellReuseIdentifier:tableviewCellIndentifer];
        [self.view addSubview:_myTableView];
        
        _myTableView.sd_layout.leftSpaceToView(self.view,0).topSpaceToView(self.view,0).rightSpaceToView(self.view,0).bottomSpaceToView(self.view,0);
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}




@end
