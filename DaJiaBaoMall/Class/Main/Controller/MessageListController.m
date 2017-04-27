//
//  MessageListController.m
//  DaJiaBaoMall
//
//  Created by 大家保 on 2017/3/31.
//  Copyright © 2017年 大家保. All rights reserved.
//

#import "MessageListController.h"
#import "MessageListCell.h"
#import "BaseWebViewController.h"
#import "ConnectServiceViewController.h"
#import "MessageModel.h"


@interface MessageListController ()<UITableViewDelegate,UITableViewDataSource>{
    NSInteger zichanCount;
    NSInteger inviteCount;
    NSInteger kehuCount;
    NSInteger systemCount;
}

@property (nonatomic,strong)UITableView *myTableView;

@property (nonatomic,strong)NSMutableArray *dataSourceArray;

@end

static NSString *const tableviewCellIndentifer=@"Cell";

@implementation MessageListController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addTitle:@"消息中心"];
    [self addLeftButton];
    [self.myTableView reloadData];
    [NotiCenter addObserver:self selector:@selector(haveMessage) name:@"haveMessage" object:nil];
}

//接收新消息通知
- (void)haveMessage{
    [self getMessage];
}

- (void)dealloc{
    [NotiCenter removeObserver:self];
}


#pragma mark uitableview delegate;
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MessageListCell *cell=[tableView dequeueReusableCellWithIdentifier:tableviewCellIndentifer];
    NSArray *arr=self.dataSourceArray[indexPath.row];
    cell.FirstImageView.image=[UIImage imageNamed:arr[0]];
    cell.title.text=arr[1];
    cell.subTitle.text=arr[2];
    if (indexPath.row==0) {
        cell.redImageView.hidden=![UserDefaults boolForKey:@"haveUnredMsg"];
    }else if (indexPath.row==1) {
        cell.redImageView.hidden=zichanCount<=0;
    }else if (indexPath.row==2) {
        cell.redImageView.hidden=inviteCount<=0;
    }else if (indexPath.row==3) {
        cell.redImageView.hidden=kehuCount<=0;
    }else if (indexPath.row==4) {
        cell.redImageView.hidden=systemCount<=0;
    }
    return cell;
}


- (CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSourceArray.count;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row==0) {
        ConnectServiceViewController *conversationVC = [[ConnectServiceViewController alloc] init];
        conversationVC.conversationType = ConversationType_CUSTOMERSERVICE;
        conversationVC.targetId =RongCloudServiceID;
        conversationVC.title =@"智能客服";
        conversationVC.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:conversationVC animated:YES];
    }else{
        NSString *urlStr;
        if(indexPath.row==1){
            urlStr=[NSString stringWithFormat:@"%@%@",H5HOSTURL,zichanUrl];
        }else if(indexPath.row==2){
            urlStr=[NSString stringWithFormat:@"%@%@",H5HOSTURL,inviteUrl];
        }else if(indexPath.row==3){
            urlStr=[NSString stringWithFormat:@"%@%@",H5HOSTURL,kehuUrl];
        }else if(indexPath.row==4){
            urlStr=[NSString stringWithFormat:@"%@%@",H5HOSTURL,systemUrl];
        }
        BaseWebViewController *webView=[[BaseWebViewController alloc]init];
        webView.urlStr=urlStr;
        webView.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:webView animated:YES];
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
        _myTableView.tableHeaderView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 15)];
        _myTableView.sectionHeaderHeight=15;
        _myTableView.sectionFooterHeight=0.001;
        _myTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
        
        [_myTableView registerNib:[UINib nibWithNibName:NSStringFromClass([MessageListCell class]) bundle:nil] forCellReuseIdentifier:tableviewCellIndentifer];
        [self.view addSubview:_myTableView];
        _myTableView.sd_layout.leftSpaceToView(self.view,0).topSpaceToView(self.view,64).rightSpaceToView(self.view,0).bottomSpaceToView(self.view,0);
    }
    return _myTableView;
}

- (NSMutableArray *)dataSourceArray{
    if (!_dataSourceArray) {
        _dataSourceArray=[[NSMutableArray alloc]initWithObjects:@[@"在线客服",@"在线客服",@"有问题？直接找在线客服！"],@[@"我的资产",@"我的资产",@"在这里，您可以看到所有的资产动态！"],@[@"邀请通知",@"邀请通知",@"在这里，您可以查看所有已邀请的小伙伴！"],@[@"客户动态",@"客户动态",@"在这里，您可以查看所有的客户动态！"],@[@"系统消息",@"系统消息",@"在这里，您可以查看所有的系统消息！"], nil];
        
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
    [MobClick beginLogPageView:@"消息列表"];
    [self getMessage];
}
/**
 *  友盟统计页面关闭时间
 *
 */
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"消息列表"];
}

//获取消息
- (void)getMessage{
    NSString *url=[NSString stringWithFormat:@"%@%@",APPHOSTURL,getAllMessage];
    [XWNetworking getJsonWithUrl:url params:nil success:^(id response) {
        if (response) {
            NSInteger statusCode=[response integerForKey:@"code"];
            if (statusCode==0) {
                
            }else{
                zichanCount=[(response[@"data"][@"messagesKhdt"][@"size"]) integerValue];
                inviteCount=[(response[@"data"][@"messagesXtxx"][@"size"]) integerValue];
                kehuCount=[(response[@"data"][@"messagesYqtz"][@"size"]) integerValue];
                systemCount=[(response[@"data"][@"messagesZc"][@"size"]) integerValue];
                [self.myTableView reloadData];
            }
        }
    } fail:^(NSError *error) {
    } showHud:NO];
}


@end
