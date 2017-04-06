//
//  SendUsedCell.h
//  DaJiaBaoMall
//
//  Created by 大家保 on 2017/4/1.
//  Copyright © 2017年 大家保. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SendUsedCell;

@protocol SendUsedCell_Delegate <NSObject>

- (void)clickCell:(SendUsedCell *)cell onTheShareIndex:(NSInteger )index;

- (void)clickCell:(SendUsedCell *)cell onTheBuyIndex:(NSInteger )index;

@end

@interface SendUsedCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *line1;
@property (weak, nonatomic) IBOutlet UILabel *line2;
@property (weak, nonatomic) IBOutlet UILabel *line3;
@property (weak, nonatomic) IBOutlet UIButton *timeLabel;

@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *ageLabel;
@property (weak, nonatomic) IBOutlet UILabel *qixianLabel;
@property (weak, nonatomic) IBOutlet UILabel *productName;
@property (weak, nonatomic) IBOutlet UILabel *productPrice;

@property (nonatomic,assign) NSInteger buttomTag;
@property (nonatomic,assign) id<SendUsedCell_Delegate> delegate;

@end
