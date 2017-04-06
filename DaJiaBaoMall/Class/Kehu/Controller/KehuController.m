//
//  KehuController.m
//  DaJiaBaoMall
//
//  Created by 大家保 on 2017/3/27.
//  Copyright © 2017年 大家保. All rights reserved.
//

#import "KehuController.h"
#import "KehuContentCell.h"
#import "kehuHeadCell.h"
#import "kehuFootCell.h"
#import "KehuSetController.h"

@interface KehuController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UITableView *myTableView;

@property (nonatomic,strong)NSMutableArray *dataSourceArray;

@end

static NSString *const tableViewCellIndentifer=@"Cell";

static NSString *const tableViewHeadCellIndentifer=@"HeadCell";

static NSString *const tableViewFootCellIndentifer=@"FootCell";

@implementation KehuController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addTitle:@"客户"];
    [self addRightButtonWithImageName:@"安全设置"];
    [self.myTableView.mj_header beginRefreshing];
}

#pragma mark 右侧按钮的点击
- (void)forward:(UIButton *)button{
    KehuSetController *setVC=[[KehuSetController alloc]init];
    setVC.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:setVC animated:YES];
}


#pragma mark uitableview delegate;
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        kehuHeadCell *cell=[tableView dequeueReusableCellWithIdentifier:tableViewHeadCellIndentifer];
        return cell;
    }else if (indexPath.section==self.dataSourceArray.count-1){
        kehuFootCell *cell=[tableView dequeueReusableCellWithIdentifier:tableViewFootCellIndentifer];
        return cell;
    }else{
        KehuContentCell *cell=[tableView dequeueReusableCellWithIdentifier:tableViewCellIndentifer];
        return cell;
    }
    return nil;
}

- (CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        return 150;
    }else if (indexPath.section==1){
        return 45;
    }else if (indexPath.section==2){
        return 45;
    }
    return 0;
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
        _myTableView.tableFooterView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.0001)];
        _myTableView.sectionHeaderHeight=0.0001;
        _myTableView.sectionFooterHeight=GetHeight(10);
        //_myTableView.separatorColor=colorc3c3c3;
        _myTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
        
        [_myTableView registerNib:[UINib nibWithNibName:NSStringFromClass([KehuContentCell class]) bundle:nil] forCellReuseIdentifier:tableViewCellIndentifer];
        
        [_myTableView registerNib:[UINib nibWithNibName:NSStringFromClass([kehuHeadCell class]) bundle:nil] forCellReuseIdentifier:tableViewHeadCellIndentifer];
        
        [_myTableView registerNib:[UINib nibWithNibName:NSStringFromClass([kehuFootCell class]) bundle:nil] forCellReuseIdentifier:tableViewFootCellIndentifer];
        
        [self.view addSubview:_myTableView];
        
        _myTableView.sd_layout.leftSpaceToView(self.view,0).topSpaceToView(self.view,64).rightSpaceToView(self.view,0).bottomSpaceToView(self.view,0);
        [self addMJheader];
    }
    return _myTableView;
}

#pragma mark 数据源
- (NSMutableArray *)dataSourceArray{
    if (!_dataSourceArray) {
        _dataSourceArray=[[NSMutableArray alloc] initWithObjects:@[@"头部"],@[@[@"资讯",@"6次"],@[@"赠险",@"1次"],@[@"产品",@"1次"]],@[@"尾部"], nil];
    }
    return _dataSourceArray;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
