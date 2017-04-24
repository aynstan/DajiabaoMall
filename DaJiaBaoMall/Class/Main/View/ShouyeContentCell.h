//
//  ShouyeContentCell.h
//  DaJiaBaoMall
//
//  Created by 大家保 on 2017/3/28.
//  Copyright © 2017年 大家保. All rights reserved.
//

#import <UIKit/UIKit.h>
@class  ProductContentModel;

@interface ShouyeContentCell : UITableViewCell
//商品名称
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
//介绍文本
@property (weak, nonatomic) IBOutlet UILabel *jieshaoLabel;
//图片
@property (weak, nonatomic) IBOutlet UIImageView *headImage;
//推广费
@property (weak, nonatomic) IBOutlet UILabel *tuiguangfeiLabel;
//支付
@property (weak, nonatomic) IBOutlet UILabel *zhifuLabel;
//model
@property (nonatomic,strong) ProductContentModel *model;



//分割线label
@property (weak, nonatomic) IBOutlet UIView *lineLabel;
//整个contentView
@property (weak, nonatomic) IBOutlet UIView *ContentBgView;

@end
