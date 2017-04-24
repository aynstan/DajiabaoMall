//
//  InviteCell.m
//  DaJiaBaoMall
//
//  Created by 大家保 on 2017/3/31.
//  Copyright © 2017年 大家保. All rights reserved.
//

#import "InviteCell.h"
#import "InvitePersonModel.h"

@implementation InviteCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

- (void)setModel:(InvitePersonModel *)model{
    self.phoneLabel.text=(0==model.tel.length?@"":model.tel);
    self.jianshuLabel.text=[NSString stringWithFormat:@"成交%ld件",(long)model.count];
    self.moneyLabel.text=[NSString stringWithFormat:@"推广费%.2f元",model.sum];
}

@end
