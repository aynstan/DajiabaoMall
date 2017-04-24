//
//  BankListCell.m
//  DaJiaBaoMall
//
//  Created by 大家保 on 2017/3/31.
//  Copyright © 2017年 大家保. All rights reserved.
//

#import "BankListCell.h"
#import "BankModel.h"

@implementation BankListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}


- (void)setModel:(BankModel *)model{
    [self.logo sd_setImageWithURL:[NSURL URLWithString:model.logo] placeholderImage:[UIImage imageNamed:@"空白图"]];
    self.bankName.text=0==model.name?@"":model.name;
    self.maxPay.text=[NSString stringWithFormat:@"每日最大限额%.2f万",model.info];
}

@end
