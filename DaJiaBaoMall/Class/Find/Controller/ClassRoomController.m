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

@property (nonatomic,assign) NSInteger maxSize;

@end

static NSString *const tableviewCellIndentifer=@"Cell";

static NSString *const tableviewBottomCellIndentifer=@"BottomCell";

@implementation ClassRoomController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.bgView.hidden=YES;
    [self.myTableView.mj_header beginRefreshing];
}


#pragma mark uitableview delegate;
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ClassModel *model=self.dataSourceArray[indexPath.section];
    if (model.type==3) {
        ClassRoomFooterCell *cell=[tableView dequeueReusableCellWithIdentifier:tableviewBottomCellIndentifer];
        cell.delegate=self;
        [cell setModelArray:model.contentArray];
        return cell;
    }else{
        ClassRoomCell *cell=[tableView dequeueReusableCellWithIdentifier:tableviewCellIndentifer];
        ClassContentModel *contentModel=model.contentArray[indexPath.row];
        [cell setModel:contentModel];
        return cell;

    }
}


- (CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    ClassModel *model=self.dataSourceArray[indexPath.section];
    if (model.type==3) {
        return 150*((model.contentArray.count+1)/2)+((model.contentArray.count+1)/2-1)*10+40;
    }else{
        return 100;
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
        return model.contentArray.count;
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
    return  45;
}


//点击具体内容
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ClassModel *model=self.dataSourceArray[indexPath.section];
    if (model.type==3) {
        
    }else{
        ClassContentModel *contentModel=model.contentArray[indexPath.row];
        BaseWebViewController *webView=[[BaseWebViewController alloc]init];
        webView.urlStr=contentModel.shareUrl;
        webView.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:webView animated:YES];
    }
}

//点击头部
- (void)clickCell:(TitleViewCell *)cell withTag:(NSInteger)tag{
    ClassModel *model=self.dataSourceArray[tag];
    BaseWebViewController *webView=[[BaseWebViewController alloc]init];
    webView.urlStr=model.moreUrl;
    webView.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:webView animated:YES];
};

//点击资讯item
- (void)clickCell:(ClassRoomFooterCell *)cell onTheCollectionViewIndex:(NSInteger )index{
    NSArray *arr=cell.modelArray;
    ClassContentModel *contentModel=arr[index];
    BaseWebViewController *webView=[[BaseWebViewController alloc]init];
    webView.urlStr=contentModel.shareUrl;
    webView.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:webView animated:YES];
};


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
        _myTableView.sectionFooterHeight=GetHeight(10);
        _myTableView.separatorInset=UIEdgeInsetsMake(0, 0, 0, 0);
        _myTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
        
        [_myTableView registerNib:[UINib nibWithNibName:NSStringFromClass([ClassRoomCell class]) bundle:nil] forCellReuseIdentifier:tableviewCellIndentifer];
        
        [_myTableView registerClass:[ClassRoomFooterCell class] forCellReuseIdentifier:tableviewBottomCellIndentifer];
        
        [self.view addSubview:_myTableView];
        _myTableView.sd_layout.leftSpaceToView(self.view,0).topSpaceToView(self.view,0).rightSpaceToView(self.view,0).bottomSpaceToView(self.view,0);
        [self addMJheader];
    }
    return _myTableView;
}

- (NSMutableArray *)dataSourceArray{
    if (!_dataSourceArray) {
        _dataSourceArray=[NSMutableArray array];
        
        ClassModel *model1=[[ClassModel alloc]init];
        model1.imageViewUrl=@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1490861504125&di=11b621209ce0af956837a0e53200b372&imgtype=0&src=http%3A%2F%2Fimg.taopic.com%2Fuploads%2Fallimg%2F140222%2F240403-14022212100634.jpg";
        model1.moreUrl=@"http://www.sogou.com";
        model1.titleStr=@"使用贴士";
        model1.hasMore=YES;
        model1.type=1;
        
        ClassContentModel *contentModel1=[[ClassContentModel alloc]init];
        contentModel1.contentTitle=@"大家保app展业宝典";
        contentModel1.subTitle=@"在什么情况下，可以领取失业保险待遇？大家缴纳的失业保险费，除了用于支付失业保险待遇，还有什么用途？针对这些群众关心的问题，人力资源和社会保障部失业保险司相关负责人进行了回应。";
        contentModel1.contentImageUrl=@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1490861504125&di=11b621209ce0af956837a0e53200b372&imgtype=0&src=http%3A%2F%2Fimg.taopic.com%2Fuploads%2Fallimg%2F140222%2F240403-14022212100634.jpg";
        contentModel1.shareUrl=@"http://www.baidu.com";
        
        ClassContentModel *contentModel2=[[ClassContentModel alloc]init];
        contentModel2.contentTitle=@"分分保app展业宝典";
        contentModel2.subTitle=@"大家缴纳的失业保险费，除了用于支付失业保险待遇，还有什么用途？";
        contentModel2.contentImageUrl=@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1490861592323&di=ddf9ad9e6084b2fca645b07021822978&imgtype=0&src=http%3A%2F%2Fpic.58pic.com%2F58pic%2F13%2F53%2F30%2F36G58PICBcS_1024.jpg";
        contentModel2.shareUrl=@"http://www.baidu.com";
        
        model1.contentArray=[[NSMutableArray alloc]initWithObjects:contentModel1,contentModel2, nil];
        
        [_dataSourceArray addObject:model1];
        
        
        ClassModel *model2=[[ClassModel alloc]init];
        model2.imageViewUrl=@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1490861504125&di=11b621209ce0af956837a0e53200b372&imgtype=0&src=http%3A%2F%2Fimg.taopic.com%2Fuploads%2Fallimg%2F140222%2F240403-14022212100634.jpg";
        model2.titleStr=@"产品素材";
        model2.hasMore=YES;
        model2.type=2;
        model2.moreUrl=@"http://www.baidu.com";
        
        ClassContentModel *contentModel11=[[ClassContentModel alloc]init];
        contentModel11.contentTitle=@"好的素材看过来";
        contentModel11.subTitle=@"该负责人介绍说，失业人员领取失业保险待遇，需要满足一定的条件：一是按照规定参加失业保险，所在单位和本人已按照规定履行缴费义务满1年的";
        contentModel11.contentImageUrl=@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1490861504125&di=11b621209ce0af956837a0e53200b372&imgtype=0&src=http%3A%2F%2Fimg.taopic.com%2Fuploads%2Fallimg%2F140222%2F240403-14022212100634.jpg";
        contentModel11.shareUrl=@"http://www.sina.com";
        
        ClassContentModel *contentModel21=[[ClassContentModel alloc]init];
        contentModel21.contentTitle=@"免费素材大放送";
        contentModel21.subTitle=@"申领失业保险金的程序是：第一步，用人单位应当及时为失业人员出具终止或者解除劳动关系的证明，并将失业人员的名单自终止或者解除劳动关系之日起15日内告知社会保险经";
        contentModel21.contentImageUrl=@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1490861592323&di=ddf9ad9e6084b2fca645b07021822978&imgtype=0&src=http%3A%2F%2Fpic.58pic.com%2F58pic%2F13%2F53%2F30%2F36G58PICBcS_1024.jpg";
        contentModel21.shareUrl=@"http://www.sina.com";
        
        model2.contentArray=[[NSMutableArray alloc]initWithObjects:contentModel11,contentModel21, nil];
        
        [_dataSourceArray addObject:model2];
        
        
        ClassModel *model3=[[ClassModel alloc]init];
        model3.imageViewUrl=@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1490861504125&di=11b621209ce0af956837a0e53200b372&imgtype=0&src=http%3A%2F%2Fimg.taopic.com%2Fuploads%2Fallimg%2F140222%2F240403-14022212100634.jpg";
        model1.moreUrl=@"http://www.sina.com";
        model3.titleStr=@"媒体报道";
        model3.hasMore=NO;
        model3.type=3;
        
        ClassContentModel *contentModel13=[[ClassContentModel alloc]init];
        contentModel13.contentTitle=@"人民日报";
        contentModel13.subTitle=@"大家保门急诊产品突破医保限制，无医保热源有福啦";
        contentModel13.contentImageUrl=@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1490861504125&di=11b621209ce0af956837a0e53200b372&imgtype=0&src=http%3A%2F%2Fimg.taopic.com%2Fuploads%2Fallimg%2F140222%2F240403-14022212100634.jpg";
        contentModel13.shareUrl=@"http://www.baidu.com";
        
        ClassContentModel *contentModel23=[[ClassContentModel alloc]init];
        contentModel23.contentTitle=@"今日头条";
        contentModel23.subTitle=@"大家保门急诊产品突破医保限制，无医保热源有福啦";
        contentModel23.contentImageUrl=@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1490861592323&di=ddf9ad9e6084b2fca645b07021822978&imgtype=0&src=http%3A%2F%2Fpic.58pic.com%2F58pic%2F13%2F53%2F30%2F36G58PICBcS_1024.jpg";
        contentModel23.shareUrl=@"http://www.baidu.com";
        
        ClassContentModel *contentModel33=[[ClassContentModel alloc]init];
        contentModel33.contentTitle=@"新浪新闻";
        contentModel33.subTitle=@"大家保门急诊产品突破医保限制，无医保热源有福啦";
        contentModel33.contentImageUrl=@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1490861504125&di=11b621209ce0af956837a0e53200b372&imgtype=0&src=http%3A%2F%2Fimg.taopic.com%2Fuploads%2Fallimg%2F140222%2F240403-14022212100634.jpg";
        contentModel33.shareUrl=@"http://www.baidu.com";
        
        ClassContentModel *contentModel43=[[ClassContentModel alloc]init];
        contentModel43.contentTitle=@"百度新闻";
        contentModel43.subTitle=@"大家保门急诊产品突破医保限制，无医保热源有福啦";
        contentModel43.contentImageUrl=@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1490861592323&di=ddf9ad9e6084b2fca645b07021822978&imgtype=0&src=http%3A%2F%2Fpic.58pic.com%2F58pic%2F13%2F53%2F30%2F36G58PICBcS_1024.jpg";
        contentModel43.shareUrl=@"http://www.baidu.com";
        
        model3.contentArray=[[NSMutableArray alloc]initWithObjects:contentModel13,contentModel23,contentModel33,contentModel43, nil];
        
        [_dataSourceArray addObject:model3];
        
    }
    return _dataSourceArray;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



@end
