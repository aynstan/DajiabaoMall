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
#define INTERVAL 5
#define SDHEIGHT SCREEN_WIDTH/2.0
#define COLLECTIONVIEWHEIGHT 80
#define ADVERTISEHEIGHT 40
#define SPACE_ITEM 10

@interface ShouyeHeadViewCell ()<SGAdvertScrollViewDelegate,SDCycleScrollViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,strong) SDCycleScrollView *cycleScrollView;

@property (nonatomic,strong) SGAdvertScrollView *advertScrollView;

@property (nonatomic,strong)UICollectionView *myCollectionView;

@property (nonatomic,strong)UIView *lineView;

@property (nonatomic,strong) NSMutableArray *CollectionArray;

@end

static NSString  * const Indentifer=@"CollectTion_Cell";

@implementation ShouyeHeadViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initUI];
    }
    return self;
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
    [self.contentView addSubview:self.cycleScrollView];
    
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
    [self.contentView addSubview:self.myCollectionView];

    //添加循环滚动的东西
    self.advertScrollView = [[SGAdvertScrollView alloc] init];
    self.advertScrollView.frame =CGRectZero;
    self.advertScrollView.titleColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    self.advertScrollView.image = [UIImage imageNamed:@"horn_icon"];
    self.advertScrollView.backgroundColor=[UIColor whiteColor];
    self.advertScrollView.titleFont = [UIFont systemFontOfSize:12];
    self.advertScrollView.timeInterval=5;
    self.advertScrollView.advertScrollViewDelegate = self;
    [self.contentView addSubview:self.advertScrollView];
    
    //添加分割线
    self.lineView=[[UIView alloc]initWithFrame:CGRectZero];
    self.lineView.backgroundColor=[UIColor lightGrayColor];
    [self.contentView addSubview:self.lineView];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    self.cycleScrollView.frame=CGRectMake(0, 0, SCREEN_WIDTH, SDHEIGHT);
    
    self.myCollectionView.frame=CGRectMake(self.cycleScrollView.x, self.cycleScrollView.height+10, SCREEN_WIDTH, COLLECTIONVIEWHEIGHT);
    
    self.lineView.frame=CGRectMake(12, self.myCollectionView.y+self.myCollectionView.height, SCREEN_WIDTH-12, 0.5);
    
    self.advertScrollView.frame=CGRectMake(0, self.myCollectionView.y+self.myCollectionView.height, SCREEN_WIDTH, ADVERTISEHEIGHT);
    
}

- (void)setMode{
    //banner滚动视图
    self. cycleScrollView.imageURLStringsGroup = @[@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1490691687490&di=f3327add036a106708bfe9e6002986f7&imgtype=0&src=http%3A%2F%2Fimgsrc.baidu.com%2Fforum%2Fpic%2Fitem%2Fd4628535e5dde7117fbeec54a7efce1b9d166120.jpg",@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1490691687490&di=670d2ffa166660de120f9da5651c7f8c&imgtype=0&src=http%3A%2F%2Fc.hiphotos.baidu.com%2Fzhidao%2Fpic%2Fitem%2F7a899e510fb30f24d89e9f18cf95d143ad4b03a0.jpg",@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1490691687489&di=e1889ef9a29f4b016279c7ea325246e7&imgtype=0&src=http%3A%2F%2Fb.hiphotos.baidu.com%2Fzhidao%2Fpic%2Fitem%2F5fdf8db1cb1349546045f2dc5e4e9258d1094a2a.jpg",@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1490691687489&di=5dc258ea3bf7f3acdf741818ee59e25f&imgtype=0&src=http%3A%2F%2Fh.hiphotos.baidu.com%2Fzhidao%2Fpic%2Fitem%2Fd058ccbf6c81800a5e0fe16eb63533fa838b47e3.jpg",@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1490691687487&di=9943adc77691de32670decad94cfd4e9&imgtype=0&src=http%3A%2F%2Fc.hiphotos.baidu.com%2Fzhidao%2Fwh%253D450%252C600%2Fsign%3D05e4cdbf71c6a7efb973a022c8ca8367%2F0b46f21fbe096b6314d136300b338744eaf8ac82.jpg"];
    
    //广告通知视图
    self.advertScrollView.titleArray = @[@"上海用户165****3455成功出单，获得推广费40元", @"北京用户165****3455成功出单，获得推广费320元", @"深圳用户165****3455成功出单，获得推广费120元"];
    
    //collectionview视图
    [self.CollectionArray removeAllObjects];
    [self.CollectionArray addObject:@"车辆抵押"];
    [self.CollectionArray addObject:@"新车分期"];
    [self.CollectionArray addObject:@"信用认证"];
    [self.myCollectionView reloadData];
};

#pragma mark 通知滚动视图代理方法
- (void)advertScrollView:(SGAdvertScrollView *)advertScrollView didSelectedItemAtIndex:(NSInteger)index {
    if (self.delegate&&[self.delegate respondsToSelector:@selector(clickCell:onTheAdvertiserIndex:)]) {
        [self.delegate clickCell:self onTheAdvertiserIndex:index];
    }
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
    return CGSizeMake(SCREEN_WIDTH/self.CollectionArray.count, COLLECTIONVIEWHEIGHT-2*SPACE_ITEM);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
        return 0;
}



- (NSMutableArray *)CollectionArray{
    if (_CollectionArray==nil) {
        _CollectionArray=[NSMutableArray array];
   }
    return _CollectionArray;
}


- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
