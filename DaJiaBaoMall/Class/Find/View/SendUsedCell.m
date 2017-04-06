//
//  SendUsedCell.m
//  DaJiaBaoMall
//
//  Created by 大家保 on 2017/4/1.
//  Copyright © 2017年 大家保. All rights reserved.
//

#import "SendUsedCell.h"

@implementation SendUsedCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
    [super setHighlighted:highlighted animated:animated];
    self.contentView.backgroundColor=colorF3F4F5;
    self.timeLabel.backgroundColor=[UIColor blackColor];
    self.bgView.backgroundColor=[UIColor whiteColor];
    self.line1.backgroundColor=RGB(231, 231, 232);
    self.line2.backgroundColor=RGB(231, 231, 232);
    self.line3.backgroundColor=RGB(231, 231, 232);
}


- (IBAction)shareToFrend:(id)sender {
    if (self.delegate&&[self.delegate respondsToSelector:@selector(clickCell:onTheShareIndex:)]) {
        [self.delegate clickCell:self onTheShareIndex:self.buttomTag];
    }
}

- (IBAction)quicklyBuy:(id)sender {
    if (self.delegate&&[self.delegate respondsToSelector:@selector(clickCell:onTheBuyIndex:)]) {
        [self.delegate clickCell:self onTheBuyIndex:self.buttomTag];
    }
}
@end
