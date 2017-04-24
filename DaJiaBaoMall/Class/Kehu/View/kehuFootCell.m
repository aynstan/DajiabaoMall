//
//  kehuFootCell.m
//  DaJiaBaoMall
//
//  Created by 大家保 on 2017/3/28.
//  Copyright © 2017年 大家保. All rights reserved.
//

#import "kehuFootCell.h"


@implementation kehuFootCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (IBAction)gotoLoadPay:(id)sender {
    if (self.delegate&&[self.delegate respondsToSelector:@selector(clickInHeadCell:withLoadPayButtom:)]) {
        [self.delegate clickInHeadCell:self withLoadPayButtom:sender];
    }
}

- (IBAction)gotoAllPay:(id)sender {
    if (self.delegate&&[self.delegate respondsToSelector:@selector(clickInHeadCell:withCompletePayButtom:)]) {
        [self.delegate clickInHeadCell:self withCompletePayButtom:sender];
    }
}

@end
