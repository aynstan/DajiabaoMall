
//
//  storeViewController.h
//  聚豹汇
//
//  Created by manasoft on 15/7/7.
//  Copyright (c) 2015年 manasoft. All rights reserved.
//



#import <UIKit/UIKit.h>

@class MXPullDownMenu;

@protocol MXPullDownMenuDelegate <NSObject>

- (void)PullDownMenu:(MXPullDownMenu *)pullDownMenu didSelectRowAtColumn:(NSInteger)column row:(NSInteger)row;

@end

@interface MXPullDownMenu : UIView<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic) id<MXPullDownMenuDelegate> delegate;

- (MXPullDownMenu *)initWithArray:(NSArray *)array selectedColor:(UIColor *)color frame:(CGRect)selfFrame backGroundViewInView:(UIView *)view;

//更新数据
- (void)updateContentWithArray:(NSMutableArray *)arrayarray;

//隐藏背景视图
- (void)dissMissBackGround;

@end


@interface CALayer (MXAddAnimationAndValue)

- (void)addAnimation:(CAAnimation *)anim andValue:(NSValue *)value forKeyPath:(NSString *)keyPath;

@end
