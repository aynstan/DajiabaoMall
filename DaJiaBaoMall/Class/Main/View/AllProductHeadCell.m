//
//  AllProductHeadCell.m
//  DaJiaBaoMall
//
//  Created by 大家保 on 2017/4/1.
//  Copyright © 2017年 大家保. All rights reserved.
//

#import "AllProductHeadCell.h"
#import "SDCycleScrollView.h"
#define SDHEIGHT SCREEN_WIDTH/2.0
#define INTERVAL 5

@interface AllProductHeadCell ()<SDCycleScrollViewDelegate>

@property (nonatomic,strong) SDCycleScrollView *cycleScrollView;

@end

@implementation AllProductHeadCell

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
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.cycleScrollView.frame=CGRectMake(0, 0, SCREEN_WIDTH, SDHEIGHT);
}

- (void)setMode{
    //banner滚动视图
    self. cycleScrollView.imageURLStringsGroup = @[@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1490691687490&di=f3327add036a106708bfe9e6002986f7&imgtype=0&src=http%3A%2F%2Fimgsrc.baidu.com%2Fforum%2Fpic%2Fitem%2Fd4628535e5dde7117fbeec54a7efce1b9d166120.jpg",@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1490691687490&di=670d2ffa166660de120f9da5651c7f8c&imgtype=0&src=http%3A%2F%2Fc.hiphotos.baidu.com%2Fzhidao%2Fpic%2Fitem%2F7a899e510fb30f24d89e9f18cf95d143ad4b03a0.jpg",@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1490691687489&di=e1889ef9a29f4b016279c7ea325246e7&imgtype=0&src=http%3A%2F%2Fb.hiphotos.baidu.com%2Fzhidao%2Fpic%2Fitem%2F5fdf8db1cb1349546045f2dc5e4e9258d1094a2a.jpg",@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1490691687489&di=5dc258ea3bf7f3acdf741818ee59e25f&imgtype=0&src=http%3A%2F%2Fh.hiphotos.baidu.com%2Fzhidao%2Fpic%2Fitem%2Fd058ccbf6c81800a5e0fe16eb63533fa838b47e3.jpg",@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1490691687487&di=9943adc77691de32670decad94cfd4e9&imgtype=0&src=http%3A%2F%2Fc.hiphotos.baidu.com%2Fzhidao%2Fwh%253D450%252C600%2Fsign%3D05e4cdbf71c6a7efb973a022c8ca8367%2F0b46f21fbe096b6314d136300b338744eaf8ac82.jpg"];
};

#pragma mark - SDCycleScrollViewDelegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(clickCell:onTheBannerIndex:)]) {
        [self.delegate clickCell:self onTheBannerIndex:index];
    }
}

- (void)indexOnPageControl:(NSInteger)index{
    
}


- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
