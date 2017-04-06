//
//  ShouyeHeadViewCell.h
//  DaJiaBaoMall
//
//  Created by 大家保 on 2017/3/28.
//  Copyright © 2017年 大家保. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ShouyeHeadViewCell;

@protocol ShouyeHeadViewCell_Delegate <NSObject>

- (void)clickCell:(ShouyeHeadViewCell *)cell onTheBannerIndex:(NSInteger )index;

- (void)clickCell:(ShouyeHeadViewCell *)cell onTheCollectionViewIndex:(NSInteger )index;

- (void)clickCell:(ShouyeHeadViewCell *)cell onTheAdvertiserIndex:(NSInteger )index;

@end

@interface ShouyeHeadViewCell : UITableViewCell

@property (nonatomic,assign) id<ShouyeHeadViewCell_Delegate> delegate;

- (void)setMode;

@end
