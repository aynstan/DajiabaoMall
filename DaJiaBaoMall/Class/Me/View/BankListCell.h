//
//  BankListCell.h
//  DaJiaBaoMall
//
//  Created by 大家保 on 2017/3/31.
//  Copyright © 2017年 大家保. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BankModel;

@interface BankListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *logo;

@property (weak, nonatomic) IBOutlet UILabel *bankName;

@property (weak, nonatomic) IBOutlet UILabel *maxPay;

@property (nonatomic, strong) BankModel *model;

@property (weak, nonatomic) IBOutlet UILabel *line;

@end
