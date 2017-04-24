//
//  InviteHeadView.h
//  DaJiaBaoMall
//
//  Created by 大家保 on 2017/3/31.
//  Copyright © 2017年 大家保. All rights reserved.
//

#import <UIKit/UIKit.h>
@class InviteModel;

@interface InviteHeadView : UIView
//邀请人数
@property (weak, nonatomic) IBOutlet UILabel *peopleCountLabel;
//完成件数
@property (weak, nonatomic) IBOutlet UILabel *jianshuCountLabel;
//金额
@property (weak, nonatomic) IBOutlet UILabel *moneyCountLabel;

@property (nonatomic,strong) InviteModel *model;

@end
