//
//  TixianCell.h
//  DaJiaBaoMall
//
//  Created by 大家保 on 2017/3/31.
//  Copyright © 2017年 大家保. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TixianModel;

@interface TixianCell : UITableViewCell
//提现金额
@property (weak, nonatomic) IBOutlet UILabel *tixianMoney;
//状态
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
//时间
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (nonatomic,strong) TixianModel *model;

@end
