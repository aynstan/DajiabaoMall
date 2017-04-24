//
//  InviteHeadView.m
//  DaJiaBaoMall
//
//  Created by 大家保 on 2017/3/31.
//  Copyright © 2017年 大家保. All rights reserved.
//

#import "InviteHeadView.h"
#import "InviteModel.h"

@implementation InviteHeadView

- (void)setModel:(InviteModel *)model{
    self.peopleCountLabel.text=[NSString stringWithFormat:@"%ld人",(long)model.inviteCount];
    self.jianshuCountLabel.text=[NSString stringWithFormat:@"%ld件",(long)model.successCount];
    self.moneyCountLabel.text=[NSString stringWithFormat:@"%.2f元",model.sumprofit];
}

@end
