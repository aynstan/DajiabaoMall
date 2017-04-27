//
//  SendUsedController.m
//  DaJiaBaoMall
//
//  Created by 大家保 on 2017/4/1.
//  Copyright © 2017年 大家保. All rights reserved.
//

#import "SendUsedController.h"
#import "WXApi.h"
#import "SendUsedCell.h"
#import "BaseWebViewController.h"
#import "FressProduct.h"
#import "ShareModel.h"
#import "OYCountDownManager.h"
#define IMAGEHEIGHT (SCREEN_WIDTH-30)*286/690.0

@interface SendUsedController ()<UITableViewDelegate,UITableViewDataSource,SendUsedCell_Delegate>

@property (nonatomic,strong)UITableView *myTableView;

@property (nonatomic,strong)NSMutableArray *dataSourceArray;

@property (nonatomic,assign) NSInteger maxSize;

@property (nonatomic,strong) NomessageView *noMessageView;

@end

@implementation SendUsedController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.bgView.hidden=YES;
    [kCountDownManager start];
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
            NSArray *dataArray=[FressProduct mj_objectArrayWithKeyValuesArray:[response objectForKey:@"data"]];
            [self.dataSourceArray addObjectsFromArray:dataArray];
            if (self.dataSourceArray.count>0) {
                [self.noMessageView removeFromSuperview];
            }else{
                [self.myTableView addSubview:self.noMessageView];
            }
            [kCountDownManager reload];
            [self.myTableView reloadData];
        }
    }
}



#pragma mark uitableview delegate;
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SendUsedCell *cell=[[[NSBundle mainBundle]loadNibNamed:@"SendUsedCell" owner:nil options:nil] lastObject];
    cell.delegate=self;
    cell.buttomTag=indexPath.section;
    FressProduct *product=self.dataSourceArray[indexPath.section];
    [cell setModel:product];
    return cell;
}


- (CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return IMAGEHEIGHT+120;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataSourceArray.count;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    FressProduct *product=self.dataSourceArray[indexPath.section];
    ShareModel   *share=product.productInfo;
    BaseWebViewController *webView=[[BaseWebViewController alloc]init];
    webView.urlStr=share.url;
    webView.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:webView animated:YES];
}

//点击了分享按钮
- (void)clickCell:(SendUsedCell *)cell onTheShareIndex:(NSInteger )index{
    FressProduct *product=self.dataSourceArray[index];
    ShareModel   *share=product.productInfo;
    [self touch:share];
};

//点击了立即购买按钮
- (void)clickCell:(SendUsedCell *)cell onTheBuyIndex:(NSInteger )index{
    FressProduct *product=self.dataSourceArray[index];
    ShareModel   *share=product.productInfo;
    BaseWebViewController *webView=[[BaseWebViewController alloc]init];
    webView.urlStr=share.url;
    webView.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:webView animated:YES];
};

#pragma mark 分享到朋友圈
- (void)touch:(ShareModel *)model{
    if ([WXApi isWXAppInstalled]) {
        WeakSelf;
        [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
            [weakSelf shareWebPageToPlatformType:platformType withModel:model] ;
        }];
    }else{
        UIAlertController *alertController=[UIAlertController alertControllerWithTitle:@"提醒" message:@"您尚未安装微信客户端，暂无法使用微信分享功能" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction=[UIAlertAction actionWithTitle:@"我知道了" style:UIAlertActionStyleCancel handler:nil];
        [alertController addAction:cancelAction];
        [KeyWindow.rootViewController presentViewController:alertController animated:YES completion:nil];
    }
}

- (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType withModel:(ShareModel *)shareModel{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    //创建网页内容对象
    NSString* thumbURL =  shareModel.image;
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:shareModel.title descr:shareModel.intro thumImage:[NSData dataWithContentsOfURL:[NSURL URLWithString:thumbURL]]];
    //设置网页地址
    shareObject.webpageUrl = shareModel.url;
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        if (error) {
            [MBProgressHUD ToastInformation:@"分享失败"];
        }else{
            [MBProgressHUD ToastInformation:@"分享成功"];
        }
    }];
}


#pragma mark 增加addMJ_Head
- (void)addMJheader{
    MJHeader *mjHeader=[MJHeader headerWithRefreshingBlock:^{
        NSString *url=[NSString stringWithFormat:@"%@%@",APPHOSTURL,freeinsurance];
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
        _myTableView.tableFooterView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 5)];
        _myTableView.tableHeaderView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 15)];
        _myTableView.sectionFooterHeight=GetHeight(10);
        _myTableView.sectionHeaderHeight=GetHeight(0.0001);
        _myTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
        
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
    [MobClick beginLogPageView:@"赠客产品_未使用"];
}
/**
 *  友盟统计页面关闭时间
 *
 */
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"赠客产品_未使用"];
}


@end
