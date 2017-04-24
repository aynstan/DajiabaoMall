//
//  OrderCell.h
//  DaJiaBaoMall
//
//  Created by 大家保 on 2017/3/31.
//  Copyright © 2017年 大家保. All rights reserved.
//

#import <UIKit/UIKit.h>
@class OrderModel;

@interface OrderCell : UITableViewCell
//时间
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
//支付状态
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
//投保人姓名
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
//产品名称
@property (weak, nonatomic) IBOutlet UILabel *productNameLabel;
//单号
@property (weak, nonatomic) IBOutlet UILabel *danhaoLabel;
//推广费
@property (weak, nonatomic) IBOutlet UILabel *tuiguangfeiLabel;
//保费
@property (weak, nonatomic) IBOutlet UILabel *baofeiLabel;
//model
@property (nonatomic,strong) OrderModel *model;

@end
