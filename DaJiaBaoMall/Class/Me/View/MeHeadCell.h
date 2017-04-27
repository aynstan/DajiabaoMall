//
//  MeHeadCell.h
//  DaJiaBaoMall
//
//  Created by 大家保 on 2017/3/28.
//  Copyright © 2017年 大家保. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MeHeadCell;
@class MeModel;

@protocol MeHeadCell_Delegate <NSObject>

- (void)clickIncell:(MeHeadCell *)cell onTheChangeButtom:(UIButton *)sender;

- (void)clickIncell:(MeHeadCell *)cell onTheMyOrderButtom:(UIButton *)sender;

- (void)clickIncell:(MeHeadCell *)cell onTheMyMoneyButtom:(UIButton *)sender;

@end

@interface MeHeadCell : UITableViewCell
//头像
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
//手机号
@property (weak, nonatomic) IBOutlet UILabel *phoneOrWeChat;
//更改个人信息
@property (weak, nonatomic) IBOutlet UIButton *changeButton;
//我的订单
@property (weak, nonatomic) IBOutlet UIButton *myOrderButtom;
//我的钱包
@property (weak, nonatomic) IBOutlet UIButton *myMoneyButtom;
//是否是vip
@property (weak, nonatomic) IBOutlet UIImageView *vipImageView;

@property (nonatomic,assign) id<MeHeadCell_Delegate> delegate;

@property (nonatomic,strong) MeModel *model;

@end
