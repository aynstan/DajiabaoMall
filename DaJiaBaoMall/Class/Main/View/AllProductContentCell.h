//
//  AllProductContentCell.h
//  DaJiaBaoMall
//
//  Created by 大家保 on 2017/4/1.
//  Copyright © 2017年 大家保. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AllProductContentCell;
@class ProductContentModel;

@protocol AllProductContentCell_Delegate <NSObject>

- (void)clickCell:(AllProductContentCell *)cell toGetMoney:(NSInteger)index;

@end

@interface AllProductContentCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *headImageView;

@property (weak, nonatomic) IBOutlet UILabel *contentTitle;

@property (weak, nonatomic) IBOutlet UILabel *contentSubTitle;

@property (weak, nonatomic) IBOutlet UILabel *contentPrice;

@property (weak, nonatomic) IBOutlet UILabel *tuiguangLabel;

@property (nonatomic,assign) NSInteger butomTag;

@property (nonatomic,assign) id<AllProductContentCell_Delegate> delegate;

@property (nonatomic,strong) ProductContentModel *model;

@property (nonatomic,assign) BOOL closeEye;

@end
