//
//  ClassRoomController.m
//  DaJiaBaoMall
//
//  Created by 大家保 on 2017/3/27.
//  Copyright © 2017年 大家保. All rights reserved.
//

#import "ClassRoomController.h"
#import "ClassRoomCell.h"
#import "TitleViewCell.h"
#import "BaseWebViewController.h"
#import "ClassRoomFooterCell.h"
#import "ClassModel.h"
#import "ClassContentModel.h"

@interface ClassRoomController ()<UITableViewDelegate,UITableViewDataSource,TitleViewCell_Delegate,ClassRoomFooterCell_Delegate>

@property (nonatomic,strong)UITableView *myTableView;

@property (nonatomic,strong)NSMutableArray *dataSourceArray;

@property (nonatomic,strong) NomessageView *noMessageView;

@end

static NSString *const tableviewCellIndentifer=@"Cell";

static NSString *const tableviewBottomCellIndentifer=@"BottomCell";

@implementation ClassRoomController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.bgView.hidden=YES;
    [self.myTableView.mj_header beginRefreshing];
}

//保存数据
- (void)saveData:(id)response{
    NSLog(@"=====%@",response);
    if (response) {
        NSInteger statusCode=[response integerForKey:@"code"];
        if (statusCode==0) {
            NSString *errorMsg=[response stringForKey:@"message"];
            [MBProgressHUD ToastInformation:errorMsg];
        }else if (statusCode==1){
            [self.dataSourceArray removeAllObjects];
            NSArray<ClassModel *> *catogoryArr=[ClassModel mj_objectArrayWithKeyValuesArray:response[@"data"]];
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
    ClassModel *model=self.dataSourceArray[indexPath.section];
    if (model.type==3) {
        ClassRoomFooterCell *cell=[tableView dequeueReusableCellWithIdentifier:tableviewBottomCellIndentifer];
        cell.delegate=self;
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        [cell setModelArray:model.data];
        return cell;
    }else{
        ClassRoomCell *cell=[tableView dequeueReusableCellWithIdentifier:tableviewCellIndentifer];
        ClassContentModel *contentModel=model.data[indexPath.row];
        [cell setModel:contentModel];
        return cell;
    }
}


- (CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    ClassModel *model=self.dataSourceArray[indexPath.section];
    if (model.type==3) {
        return (SCREEN_WIDTH-30)/2*199/165.0*((model.data.count+1)/2)+((model.data.count+1)/2-1)*10+40;
    }else{
        return 103;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataSourceArray.count;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    ClassModel *model=self.dataSourceArray[section];
    if (model.type==3) {
        return 1;
    }else{
        return model.data.count;
    }
}

// 配置分组头视图
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    ClassModel *model=self.dataSourceArray[section];
    TitleViewCell *moreView =[[[NSBundle mainBundle]loadNibNamed:@"TitleViewCell" owner:nil options:nil]lastObject];
    moreView.frame=CGRectMake(0, 0, SCREEN_WIDTH, 45);
    moreView.delegate=self;
    [moreView setModel:model];
    moreView.clickTag=section;
    return moreView;
 }

// 设置头高
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return  35;
}


//点击具体内容
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ClassModel *model=self.dataSourceArray[indexPath.section];
    if (model.type==3) {
        
    }else{
        ClassContentModel *contentModel=model.data[indexPath.row];
        BaseWebViewController *webView=[[BaseWebViewController alloc]init];
        webView.urlStr=contentModel.url;
        webView.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:webView animated:YES];
    }
}

//点击头部
- (void)clickCell:(TitleViewCell *)cell withTag:(NSInteger)tag{
    ClassModel *model=self.dataSourceArray[tag];
    BaseWebViewController *webView=[[BaseWebViewController alloc]init];
    webView.urlStr=model.url;
    webView.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:webView animated:YES];
};

//点击资讯item
- (void)clickCell:(ClassRoomFooterCell *)cell onTheCollectionViewIndex:(NSInteger )index{
    NSArray *arr=cell.modelArray;
    ClassContentModel *contentModel=arr[index];
    BaseWebViewController *webView=[[BaseWebViewController alloc]init];
    webView.urlStr=contentModel.url;
    webView.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:webView animated:YES];
};


#pragma mark 增加addMJ_Head
- (void)addMJheader{
    MJHeader *mjHeader=[MJHeader headerWithRefreshingBlock:^{
        NSString *url=[NSString stringWithFormat:@"%@%@",APPHOSTURL,getClass];
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
        _myTableView.sectionFooterHeight=GetHeight(15);
        _myTableView.separatorInset=UIEdgeInsetsMake(0, 0, 0, 0);
        _myTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
        
        [_myTableView registerNib:[UINib nibWithNibName:NSStringFromClass([ClassRoomCell class]) bundle:nil] forCellReuseIdentifier:tableviewCellIndentifer];
        
        [_myTableView registerClass:[ClassRoomFooterCell class] forCellReuseIdentifier:tableviewBottomCellIndentifer];
        
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
    [MobClick beginLogPageView:@"产品课堂"];
}
/**
 *  友盟统计页面关闭时间
 *
 */
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"产品课堂"];
}


@end
