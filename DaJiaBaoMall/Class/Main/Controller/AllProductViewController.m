//
//  AllProductViewController.m
//  DaJiaBaoMall
//
//  Created by 大家保 on 2017/4/1.
//  Copyright © 2017年 大家保. All rights reserved.
//

#import "AllProductViewController.h"
#import "AllProductHeadCell.h"
#import "AllProductContentCell.h"
#import "BaseWebViewController.h"
#import "WXApi.h"
#define SDHEIGHT SCREEN_WIDTH/2.0

@interface AllProductViewController ()<UITableViewDelegate,UITableViewDataSource,AllProductHeadCell_Delegate,AllProductContentCell_Delegate>

@property (nonatomic,strong)UITableView *myTableView;

@property (nonatomic,strong)NSMutableArray *dataSourceArray;

@property (nonatomic,assign) NSInteger maxSize;

@end

static NSString *const tableviewHeadCell=@"HeadCell";

static NSString *const tableviewContentCell=@"ContentCell";

@implementation AllProductViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addTitle:@"全部产品"];
    [self addLeftButton];
    [self addRightButtonWithImageName:@"会员头像"];
    [self.myTableView.mj_header beginRefreshing];
}

#pragma mark uitableview delegate;
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        AllProductHeadCell *cell=[tableView dequeueReusableCellWithIdentifier:tableviewHeadCell];
        cell.delegate=self;
        [cell setMode];
        return cell;
    }else{
        AllProductContentCell *cell=[tableView dequeueReusableCellWithIdentifier:tableviewContentCell];
        cell.butomTag=indexPath.section;
        cell.delegate=self;
        return cell;
    }
}


- (CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        return SDHEIGHT;
    }
    return 120;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 6;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    BaseWebViewController *webView=[[BaseWebViewController alloc]init];
    webView.urlStr=@"http://www.baidu.com";
    webView.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:webView animated:YES];
}

#pragma mark AllProductHeadCell_Delegate
- (void)clickCell:(AllProductHeadCell *)cell onTheBannerIndex:(NSInteger )index{
    BaseWebViewController *webView=[[BaseWebViewController alloc]init];
    webView.urlStr=@"http://www.baidu.com";
    webView.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:webView animated:YES];
};

//去赚钱
- (void)clickCell:(AllProductContentCell *)cell toGetMoney:(NSInteger)index{
    NSLog(@"=====%ld",index);
//    [self touch:nil];
}

#pragma mark 分享到朋友圈
//- (void)touch:(ClassContentModel *)model{
//    if ([WXApi isWXAppInstalled]) {
//        WeakSelf;
//        [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
//            [weakSelf shareWebPageToPlatformType:platformType withModel:model] ;
//        }];
//    }else{
//        UIAlertController *alertController=[UIAlertController alertControllerWithTitle:@"提醒" message:@"您尚未安装微信客户端，暂无法使用微信分享功能" preferredStyle:UIAlertControllerStyleAlert];
//        UIAlertAction *cancelAction=[UIAlertAction actionWithTitle:@"我知道了" style:UIAlertActionStyleCancel handler:nil];
//        [alertController addAction:cancelAction];
//        [KeyWindow.rootViewController presentViewController:alertController animated:YES completion:nil];
//    }
//}
//
//- (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType withModel:(ClassContentModel *)shareModel{
//    //创建分享消息对象
//    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
//    //创建网页内容对象
//    NSString* thumbURL =  shareModel.contentImageUrl;
//    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:shareModel.contentTitle descr:shareModel.subTitle thumImage:[NSData dataWithContentsOfURL:[NSURL URLWithString:thumbURL]]];
//    //设置网页地址
//    shareObject.webpageUrl = shareModel.shareUrl;
//    //分享消息对象设置分享内容对象
//    messageObject.shareObject = shareObject;
//    //调用分享接口
//    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
//        if (error) {
//            [MBProgressHUD ToastInformation:@"分享失败"];
//        }else{
//            [MBProgressHUD ToastInformation:@"分享成功"];
//        }
//    }];
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
        _myTableView.sectionHeaderHeight=GetHeight(0.0001);
        _myTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
        
        [_myTableView registerClass:[AllProductHeadCell class] forCellReuseIdentifier:tableviewHeadCell];
        
        [_myTableView registerNib:[UINib nibWithNibName:NSStringFromClass([AllProductContentCell class]) bundle:nil] forCellReuseIdentifier:tableviewContentCell];
        
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
