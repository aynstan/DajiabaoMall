//
//  ShouyeHeadViewCell.m
//  DaJiaBaoMall
//
//  Created by 大家保 on 2017/3/28.
//  Copyright © 2017年 大家保. All rights reserved.
//

#import "ShouyeHeadViewCell.h"
#import "Home_New_CollectionViewCell.h"
#import "SDCycleScrollView.h"
#import "SGAdvertScrollView.h"
#import "MainHeadModel.h"
#define INTERVAL 5
#define SDHEIGHT SCREEN_WIDTH*243/375.0
#define COLLECTIONVIEWHEIGHT 97
#define ADVERTISEHEIGHT 40
#define SPACE_ITEM 10

@interface ShouyeHeadViewCell ()<SGAdvertScrollViewDelegate,SDCycleScrollViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource>
//广告栏
@property (nonatomic,strong) SDCycleScrollView *cycleScrollView;
//通知栏
@property (nonatomic,strong) SGAdvertScrollView *advertScrollView;
//功能栏
@property (nonatomic,strong)UICollectionView *myCollectionView;
//分割线
@property (nonatomic,strong)UIView *lineView;
//功能栏数组
@property (nonatomic,strong) NSMutableArray *CollectionArray;
//广告栏数组
@property (nonatomic,strong) NSMutableArray *bannarImageArray;


@end

static NSString  * const Indentifer=@"CollectTion_Cell";

@implementation ShouyeHeadViewCell


- (instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        [self initUI];
        [NotiCenter addObserver:self selector:@selector(banner) name:@"baner" object:nil];
    }
    return self;
}

/** 解决viewWillAppear时出现时轮播图卡在一半的问题，在控制器viewWillAppear时调用此方法 */
- (void)banner{
    if (self.cycleScrollView) {
        [self.cycleScrollView adjustWhenControllerViewWillAppera];
    }
}

//释放通知
- (void)dealloc{
    [NotiCenter removeObserver:self];
}

- (void)initUI{
    self.backgroundColor=[UIColor clearColor];
    // 网络加载 --- 创建不带标题的图片轮播器
    self.cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectZero imageURLStringsGroup:nil];
    // 是否无限循环,默认Yes
    self.cycleScrollView.infiniteLoop = YES;
    self.cycleScrollView.delegate = self;
    self.cycleScrollView.placeholderImage=[UIImage imageNamed:@"空白图"];
    self.cycleScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleAnimated;
    self.cycleScrollView.autoScrollTimeInterval = INTERVAL;
    self.cycleScrollView.pageControlStyle=SDCycleScrollViewPageContolStyleClassic;
    self.cycleScrollView.pageDotColor=[UIColor colorWithWhite:1 alpha:0.5];
    self.cycleScrollView.frame=CGRectMake(0, 0, SCREEN_WIDTH, SDHEIGHT);
    [self addSubview:self.cycleScrollView];
    
    //添加collectionview
    UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc]init];
    layout.scrollDirection=UICollectionViewScrollDirectionHorizontal;
    layout.sectionInset=UIEdgeInsetsMake(0, 0, 0, 0);
    self.myCollectionView=[[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
    self.myCollectionView.backgroundColor=[UIColor whiteColor];
    [self.myCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([Home_New_CollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:Indentifer];
    self.myCollectionView.delegate=self;
    self.myCollectionView.dataSource=self;
    self.myCollectionView.backgroundColor=[UIColor whiteColor];
    self.myCollectionView.frame=CGRectMake(self.cycleScrollView.x, self.cycleScrollView.height, SCREEN_WIDTH, COLLECTIONVIEWHEIGHT);
    [self addSubview:self.myCollectionView];

    //添加循环滚动的东西
    self.advertScrollView = [[SGAdvertScrollView alloc] initWithFrame:CGRectMake(0, self.myCollectionView.y+self.myCollectionView.height, SCREEN_WIDTH, ADVERTISEHEIGHT)];
    self.advertScrollView.titleColor = [UIColor colorWithHexString:@"#595959"];
    self.advertScrollView.image = [UIImage imageNamed:@"公告"];
    self.advertScrollView.backgroundColor=[UIColor whiteColor];
    self.advertScrollView.titleFont = SystemFont(12);
    self.advertScrollView.timeInterval=5;
    self.advertScrollView.advertScrollViewDelegate = self;
    [self addSubview:self.advertScrollView];
    
    //添加分割线
    self.lineView=[[UIView alloc]initWithFrame:CGRectZero];
    self.lineView.backgroundColor=[UIColor colorWithHexString:@"#dcdcdc"];
    self.lineView.frame=CGRectMake(0, self.myCollectionView.y+self.myCollectionView.height, SCREEN_WIDTH, 0.5);
    [self addSubview:self.lineView];
    
}


- (void)setModel:(MainHeadModel *)model{
    //banner滚动视图
    [self.bannarImageArray removeAllObjects];
    NSArray<ADModel *> *adArr=model.ads;
    for (ADModel *ad in adArr) {
        [self.bannarImageArray addObject:ad.image];
    }
    self. cycleScrollView.imageURLStringsGroup = self.bannarImageArray;
    
    //广告通知视图
    self.advertScrollView.titleArray = model.rollmsg;
    
    //collectionview视图
    [self.CollectionArray removeAllObjects];
    NSArray<SubIconModel *> *subArr=model.subIcon;
    for (SubIconModel *sub in subArr) {
        [self.CollectionArray addObject:sub.image];
    }
    [self.myCollectionView reloadData];
}


#pragma mark 通知滚动视图代理方法
- (void)advertScrollView:(SGAdvertScrollView *)advertScrollView didSelectedItemAtIndex:(NSInteger)index {
}


#pragma mark - SDCycleScrollViewDelegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(clickCell:onTheBannerIndex:)]) {
        [self.delegate clickCell:self onTheBannerIndex:index];
    }
}

- (void)indexOnPageControl:(NSInteger)index{
    
}


#pragma mark - CollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.CollectionArray.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    Home_New_CollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:Indentifer forIndexPath:indexPath];
    cell.imageString=self.CollectionArray[indexPath.item];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(clickCell:onTheCollectionViewIndex:)]) {
        [self.delegate clickCell:self onTheCollectionViewIndex:indexPath.row];
    }
};

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(SCREEN_WIDTH/self.CollectionArray.count, COLLECTIONVIEWHEIGHT-2*15);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
        return 0;
}

#pragma mark 懒加载
- (NSMutableArray *)CollectionArray{
    if (_CollectionArray==nil) {
        _CollectionArray=[NSMutableArray array];
   }
    return _CollectionArray;
}

- (NSMutableArray *)bannarImageArray{
    if (!_bannarImageArray) {
        _bannarImageArray=[NSMutableArray array];
    }
    return _bannarImageArray;
}


@end
