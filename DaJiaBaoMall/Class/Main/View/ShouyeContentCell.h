//
//  ShouyeContentCell.h
//  DaJiaBaoMall
//
//  Created by 大家保 on 2017/3/28.
//  Copyright © 2017年 大家保. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShouyeContentCell : UITableViewCell
//商品名称
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
//商品价格
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
//推广费文案
@property (weak, nonatomic) IBOutlet UILabel *tuiguangfeiLabel;
//费率文本
@property (weak, nonatomic) IBOutlet UILabel *feilvLabel;
//介绍文本
@property (weak, nonatomic) IBOutlet UILabel *jieshaoLabel;
//分割线label
@property (weak, nonatomic) IBOutlet UIView *lineLabel;
//整个contentView
@property (weak, nonatomic) IBOutlet UIView *ContentBgView;

@end
