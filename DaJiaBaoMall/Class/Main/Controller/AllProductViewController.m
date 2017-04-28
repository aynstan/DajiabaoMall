//
//  AllProductViewController.m
//  DaJiaBaoMall
//
//  Created by 大家保 on 2017/4/1.
//  Copyright © 2017年 大家保. All rights reserved.
//

#import "AllProductViewController.h"
#import "AllProductContentCell.h"
#import "BaseWebViewController.h"
#import "SDCycleScrollView.h"
#import "AllProductModel.h"
#import "WXApi.h"
#define INTERVAL 5
#define SDHEIGHT SCREEN_WIDTH*130/375.0

@interface AllProductViewController ()<UITableViewDelegate,UITableViewDataSource,AllProductContentCell_Delegate,SDCycleScrollViewDelegate>

@property (nonatomic,strong)UITableView *myTableView;

@property (nonatomic,strong)NSMutableArray *dataSourceArray;

@property (nonatomic,assign) NSInteger size;

@property (nonatomic,assign) NSInteger page;

@property (nonatomic,assign) NSInteger rows;

@property (nonatomic,strong) SDCycleScrollView *cycleScrollView;

@property (nonatomic,strong) AllProductModel *allProduct;

@property (nonatomic,strong) MJFooter *mjFooter;

@property (nonatomic,strong) NomessageView *noMessageView;

@end

static NSString *const tableviewHeadCell=@"HeadCell";

static NSString *const tableviewContentCell=@"ContentCell";

@implementation AllProductViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addTitle:@"保险客栈"];
    [self addLeftButton];
    [self addRightButton];
    self.size=15;
    [self.myTableView.mj_header beginRefreshing];
}

//添加右边按钮
- (void)addRightButton{
    UIButton *RightButton=[[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-45, 20, 45, 44)];
    RightButton.tag=10000;
    [RightButton setImage:[UIImage imageNamed:@"open"] forState:0];
    [RightButton setImage:[UIImage imageNamed:@"close"] forState:UIControlStateSelected];
    RightButton.selected=[UserDefaults boolForKey:@"closeEye"];
    [RightButton addTarget:self action:@selector(forward:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:RightButton];
}

//闭眼／睁眼
- (void)forward:(UIButton *)button{
    button.selected=!button.selected;
    [UserDefaults setBool:button.selected forKey:@"closeEye"];
    [UserDefaults synchronize];
    [self.myTableView reloadData];
}

#pragma mark 下拉刷新
- (void)savelist:(id)response{
    if (response) {
        NSInteger statusCode=[response integerForKey:@"code"];
        if (statusCode==0) {
            NSString *errorMsg=[response stringForKey:@"msg"];
            [MBProgressHUD ToastInformation:errorMsg];
        }else{
            [self.dataSourceArray removeAllObjects];
            if (response[@"data"] !=[NSNull null]&&[[response[@"data"] allKeys] containsObject:@"rows"]) {
                self.rows=[response[@"data"] integerForKey:@"rows"];
            }
            self.allProduct=[AllProductModel mj_objectWithKeyValues:response[@"data"]];
            [self.dataSourceArray addObjectsFromArray:self.allProduct.productList];
            if (self.dataSourceArray.count<self.rows) {
                [self addMJ_Footer];
            }
            if (self.dataSourceArray.count>0) {
                [self.noMessageView removeFromSuperview];
            }else{
                [self.myTableView addSubview:self.noMessageView];
            }
            [self.myTableView reloadData];
        }
    }
}


#pragma mark 获取更多产品数据
- (void)addlist:(id)response{
    if (response) {
        NSInteger statusCode=[response integerForKey:@"code"];
        if (statusCode==0) {
            if (self.page>1) {
                self.page--;
            }
            NSString *errorMsg=[response stringForKey:@"msg"];
            [MBProgressHUD ToastInformation:errorMsg];
        }else{
            if (response[@"data"] !=[NSNull null]&&[[response[@"data"] allKeys] containsObject:@"rows"]) {
                self.rows=[response[@"data"] integerForKey:@"rows"];
            }
            NSArray<ProductContentModel*> *dataArray=[ProductContentModel mj_objectArrayWithKeyValuesArray:response[@"data"][@"productList"]];
            [self.dataSourceArray addObjectsFromArray:dataArray];
            if (self.dataSourceArray.count>=self.rows) {
                [self.myTableView.mj_footer endRefreshingWithNoMoreData];
            }
            [self.myTableView reloadData];
        }
    }
}


#pragma mark uitableview delegate;
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
     AllProductContentCell *cell=[tableView dequeueReusableCellWithIdentifier:tableviewContentCell];
    cell.butomTag=indexPath.section;
    cell.closeEye=[UserDefaults boolForKey:@"closeEye"];
    cell.delegate=self;
    ProductContentModel *productModel=self.dataSourceArray[indexPath.section];
    [cell setModel:productModel];
    return cell;
}


- (CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 118;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataSourceArray.count;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ProductContentModel *productModel=self.dataSourceArray[indexPath.section];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    BaseWebViewController *webView=[[BaseWebViewController alloc]init];
    webView.urlStr=productModel.url;
    webView.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:webView animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return SDHEIGHT;
    }else{
        return 15;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section==0) {
        self.cycleScrollView.frame=CGRectMake(0, 0, SCREEN_WIDTH, SDHEIGHT);
        NSMutableArray *imageArray=[NSMutableArray array];
        [imageArray removeAllObjects];
        NSArray<ADModel *> *adArr=self.allProduct.ads;
        for (ADModel *ad in adArr) {
            [imageArray addObject:ad.image];
        }
        self.cycleScrollView.imageURLStringsGroup=imageArray;
        return self.cycleScrollView;
    }else{
        return [UIView new];
    }
}

#pragma mark SDCycleScrollViewDelegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    NSArray<ADModel *> *adArr=self.allProduct.ads;
    ADModel *ad=adArr[index];
    BaseWebViewController *webView=[[BaseWebViewController alloc]init];
    webView.urlStr=ad.url;
    webView.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:webView animated:YES];
};

//去赚钱
- (void)clickCell:(AllProductContentCell *)cell toGetMoney:(NSInteger)index{
    ProductContentModel *productModel=self.dataSourceArray[index];
    [self touch:productModel];
}

#pragma mark 分享到朋友圈
- (void)touch:(ProductContentModel *)model{
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

- (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType withModel:(ProductContentModel *)shareModel{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    //创建网页内容对象
    NSString* thumbURL =  shareModel.image;
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:shareModel.name descr:shareModel.title thumImage:[NSData dataWithContentsOfURL:[NSURL URLWithString:thumbURL]]];
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
        self.page=1;
        NSString *url=[NSString stringWithFormat:@"%@%@",APPHOSTURL,getAllProduct];
        NSDictionary *dic=@{@"page":@(self.page),@"size":@(self.size)};
        NSLog(@"===参数%@",dic);
        [XWNetworking getJsonWithUrl:url params:dic responseCache:^(id responseCache) {
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

#pragma mark 增加addMJ_Footer
- (void)addMJ_Footer{
    if (self.mjFooter==nil) {
        self.mjFooter=[MJFooter footerWithRefreshingBlock:^{
                    self.page++;
                    NSString *url=[NSString stringWithFormat:@"%@%@",APPHOSTURL,getAllProduct];
                    NSDictionary *dic=@{@"page":@(self.page),@"size":@(self.size)};
            NSLog(@"参数=%@",dic);
                    [XWNetworking getJsonWithUrl:url params:dic  success:^(id response) {
                        [self addlist:response];
                        [self endFreshAndLoadMore];
                    } fail:^(NSError *error) {
                        if (self.page>1) {
                            self.page--;
                        }
                        if ([XWNetworking isHaveNetwork]) {
                            [MBProgressHUD ToastInformation:@"服务器开小差了"];
                        }else{
                            [MBProgressHUD ToastInformation:@"网络似乎已断开..."];
                        }
                        [self endFreshAndLoadMore];
                    } showHud:NO];
        }];
        _myTableView.mj_footer=self.mjFooter;
    }
}

#pragma mark 关闭mjrefreshing
- (void)endFreshAndLoadMore{
    [_myTableView.mj_header endRefreshing];
    if (self.dataSourceArray.count>=self.rows) {
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
        _myTableView.sectionFooterHeight=GetHeight(0.0001);
        _myTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
        [_myTableView registerNib:[UINib nibWithNibName:NSStringFromClass([AllProductContentCell class]) bundle:nil] forCellReuseIdentifier:tableviewContentCell];
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

- (SDCycleScrollView *)cycleScrollView{
    if (!_cycleScrollView) {
        _cycleScrollView=[SDCycleScrollView cycleScrollViewWithFrame:CGRectZero imageURLStringsGroup:nil];
        // 是否无限循环,默认Yes
        self.cycleScrollView.infiniteLoop = YES;
        self.cycleScrollView.delegate = self;
        self.cycleScrollView.placeholderImage=[UIImage imageNamed:@"空白图"];
        self.cycleScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleAnimated;
        self.cycleScrollView.pageDotColor=[UIColor colorWithWhite:1 alpha:0.5];
        self.cycleScrollView.autoScrollTimeInterval = INTERVAL;
        self.cycleScrollView.pageControlStyle=SDCycleScrollViewPageContolStyleClassic;
    }
    return _cycleScrollView;
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
    [MobClick beginLogPageView:@"所有产品"];
}
/**
 *  友盟统计页面关闭时间
 *
 */
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"所有产品"];
}



@end
