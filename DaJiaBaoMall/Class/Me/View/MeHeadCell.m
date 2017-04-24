//
//  MeHeadCell.m
//  DaJiaBaoMall
//
//  Created by 大家保 on 2017/3/28.
//  Copyright © 2017年 大家保. All rights reserved.
//

#import "MeHeadCell.h"
#import "MeModel.h"

@implementation MeHeadCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setModel:(MeModel *)model{
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:model.picture] placeholderImage:[UIImage imageNamed:@"head-portrait-big"]];
    self.phoneOrWeChat.text=0==model.mobilephone.length?@"":model.mobilephone;
}

//更改我的信息
- (IBAction)changeMyMessage:(id)sender {
    if (self.delegate&&[self.delegate respondsToSelector:@selector(clickIncell:onTheChangeButtom:)]) {
        [self.delegate clickIncell:self onTheChangeButtom:sender];
    }
}

//我的订单
- (IBAction)toMyOrder:(id)sender {
    if (self.delegate&&[self.delegate respondsToSelector:@selector(clickIncell:onTheMyOrderButtom:)]) {
        [self.delegate clickIncell:self onTheMyOrderButtom:sender];
    }
}

//我的钱包
- (IBAction)toMyMoney:(id)sender {
    if (self.delegate&&[self.delegate respondsToSelector:@selector(clickIncell:onTheMyMoneyButtom:)]) {
        [self.delegate clickIncell:self onTheMyMoneyButtom:sender];
    }
}
@end
