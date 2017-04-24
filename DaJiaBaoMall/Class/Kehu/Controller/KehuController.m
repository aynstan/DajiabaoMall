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
#import "VisitCountModel.h"
#import "myMoneyShow.h"
#import "BaseWebViewController.h"
#import "MyOrderListController.h"

@interface KehuController ()<UITableViewDelegate,UITableViewDataSource,kehuHeadCellDelegate,kehuFootCellDelegate>

@property (nonatomic,strong)UITableView *myTableView;

@property (nonatomic,strong)VisitCountModel *visitCountModel;

@property (nonatomic,strong) JCAlertView *alertView;

@end

static NSString *const tableViewCellIndentifer=@"Cell";

static NSString *const tableViewHeadCellIndentifer=@"HeadCell";

static NSString *const tableViewFootCellIndentifer=@"FootCell";

@implementation KehuController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addTitle:@"客户"];
    [self addRightButtonWithImageName:@"question"];
    [self.myTableView.mj_header beginRefreshing];
}

//保存数据
- (void)saveData:(id)response{
    NSLog(@"客户=%@",response);
    if (response) {
        NSInteger statusCode=[response integerForKey:@"code"];
        if (statusCode==0) {
            NSString *errorMsg=[response stringForKey:@"message"];
            [MBProgressHUD ToastInformation:errorMsg];
        }else if (statusCode==1){
            self.visitCountModel=[VisitCountModel mj_objectWithKeyValues:[response objectForKey:@"data"]];
            [self.myTableView reloadData];
        }
    }

}

#pragma mark 右侧按钮的点击
- (void)forward:(UIButton *)button{
    WeakSelf;
    myMoneyShow *showView=[[[NSBundle mainBundle]loadNibNamed:@"myMoneyShow" owner:nil options:nil]lastObject];;
    showView.frame=CGRectMake(0, 0, 280, 280*794/618.0);
    showView.imageView.image=[UIImage imageNamed:@"客户-弹窗"];
    showView.closeBlock=^(){
        [weakSelf.alertView dismissWithCompletion:nil];
    };
    self.alertView=[[JCAlertView alloc]initWithCustomView:showView dismissWhenTouchedBackground:NO];
    [self.alertView show];
}


#pragma mark uitableview delegate;
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        kehuHeadCell *cell=[tableView dequeueReusableCellWithIdentifier:tableViewHeadCellIndentifer];
        cell.delegate=self;
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        [cell.toDayButtom setTitle:[NSString stringWithFormat:@"%ld次",(long)self.visitCountModel.todayCount] forState:0];
        [cell.allButtom setTitle:[NSString stringWithFormat:@"%ld人",(long)self.visitCountModel.totalCount] forState:0];
        return cell;
    }else if (indexPath.section==2){
        kehuFootCell *cell=[tableView dequeueReusableCellWithIdentifier:tableViewFootCellIndentifer];
        cell.delegate=self;
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        [cell.noPayButtom setTitle:[NSString stringWithFormat:@"未支付订单：%ld单",(long)self.visitCountModel.unpayOrder] forState:0];
        [cell.alReadyButton setTitle:[NSString stringWithFormat:@"已支付订单：%ld单",(long)self.visitCountModel.payOrder] forState:0];
        return cell;
    }else if (indexPath.section==1){
        KehuContentCell *cell=[tableView dequeueReusableCellWithIdentifier:tableViewCellIndentifer];
        if (indexPath.row==0) {
            cell.titleLabel.text=@"文章";
            [cell.imageViewHead setImage:[UIImage imageNamed:@"文章－1"]];
            cell.subTitleLabel.text=[NSString stringWithFormat:@"%ld次",(long)self.visitCountModel.articleCount];
        }else if (indexPath.row==1) {
            cell.titleLabel.text=@"赠险";
            [cell.imageViewHead setImage:[UIImage imageNamed:@"礼物"]];
            cell.subTitleLabel.text=[NSString stringWithFormat:@"%ld次",(long)self.visitCountModel.zengCount];
        }else if (indexPath.row==2) {
            cell.titleLabel.text=@"产品";
            [cell.imageViewHead setImage:[UIImage imageNamed:@"产品"]];
            cell.subTitleLabel.text=[NSString stringWithFormat:@"%ld次",(long)self.visitCountModel.productCount];
        }
        return cell;
    }
    return nil;
}

- (CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        return 80;
    }else if (indexPath.section==1){
        return 50;
    }else if (indexPath.section==2){
        return 50;
    }
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
        return 1;
    }else if (section==1){
        return 3;
    }else if (section==2){
        return 1;
    }
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section==0) {
        
    }else if (indexPath.section==1) {
        NSString *contentUrl;
        if (indexPath.row==0) {
            contentUrl=self.visitCountModel.articleUrl;
        }else if (indexPath.row==1){
            contentUrl=self.visitCountModel.zengUrl;
        }else if (indexPath.row==2){
            contentUrl=self.visitCountModel.productUrl;
        }
        BaseWebViewController *webView=[[BaseWebViewController alloc]init];
        webView.urlStr=contentUrl;
        webView.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:webView animated:YES];
    }else if (indexPath.section==2){
        
    }
}

- (void)clickInHeadCell:(kehuHeadCell *)cell withTodayButtom:(UIButton *)btn{
    BaseWebViewController *webView=[[BaseWebViewController alloc]init];
    webView.urlStr=self.visitCountModel.todayUrl;
    webView.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:webView animated:YES];
};

- (void)clickInHeadCell:(kehuHeadCell *)cell withAllButtom:(UIButton *)btn{
    BaseWebViewController *webView=[[BaseWebViewController alloc]init];
    webView.urlStr=self.visitCountModel.totalUrl;
    webView.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:webView animated:YES];
};

- (void)clickInHeadCell:(kehuFootCell *)cell withLoadPayButtom:(UIButton *)btn{
    MyOrderListController *orderList=[[MyOrderListController alloc]init];
    orderList.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:orderList animated:YES];
};

- (void)clickInHeadCell:(kehuFootCell *)cell withCompletePayButtom:(UIButton *)btn{
    MyOrderListController *orderList=[[MyOrderListController alloc]init];
    orderList.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:orderList animated:YES];
};

#pragma mark 增加addMJ_Head
- (void)addMJheader{
    MJHeader *mjHeader=[MJHeader headerWithRefreshingBlock:^{
        NSString *url=[NSString stringWithFormat:@"%@%@",APPHOSTURL,customer];
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
        _myTableView.tableFooterView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.0001)];
        _myTableView.sectionHeaderHeight=0.0001;
        _myTableView.sectionFooterHeight=GetHeight(15);
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

/**
 *  友盟统计页面打开开始时间
 *
 */
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"客户"];
}
/**
 *  友盟统计页面关闭时间
 *
 */
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"客户"];
}



@end
