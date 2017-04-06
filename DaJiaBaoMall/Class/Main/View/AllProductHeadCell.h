//
//  AllProductHeadCell.h
//  DaJiaBaoMall
//
//  Created by 大家保 on 2017/4/1.
//  Copyright © 2017年 大家保. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AllProductHeadCell;

@protocol AllProductHeadCell_Delegate <NSObject>

- (void)clickCell:(AllProductHeadCell *)cell onTheBannerIndex:(NSInteger )index;

@end

@interface AllProductHeadCell : UITableViewCell

@property (nonatomic,assign) id<AllProductHeadCell_Delegate> delegate;

- (void)setMode;


@end
