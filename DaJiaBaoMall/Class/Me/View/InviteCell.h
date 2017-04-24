//
//  InviteCell.h
//  DaJiaBaoMall
//
//  Created by 大家保 on 2017/3/31.
//  Copyright © 2017年 大家保. All rights reserved.
//

#import <UIKit/UIKit.h>
@class InvitePersonModel;

@interface InviteCell : UITableViewCell
//手机号
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
//件数
@property (weak, nonatomic) IBOutlet UILabel *jianshuLabel;
//金额
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
//model
@property (nonatomic,strong) InvitePersonModel *model;

@end
