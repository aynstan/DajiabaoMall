//
//  kehuHeadCell.m
//  DaJiaBaoMall
//
//  Created by 大家保 on 2017/3/28.
//  Copyright © 2017年 大家保. All rights reserved.
//

#import "kehuHeadCell.h"


@implementation kehuHeadCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}



- (IBAction)today:(id)sender {
    if (self.delegate&&[self.delegate respondsToSelector:@selector(clickInHeadCell:withTodayButtom:)]) {
        [self.delegate clickInHeadCell:self withTodayButtom:sender];
    }
}

- (IBAction)all:(id)sender {
    if (self.delegate&&[self.delegate respondsToSelector:@selector(clickInHeadCell:withAllButtom:)]) {
        [self.delegate clickInHeadCell:self withAllButtom:sender];
    }
}

- (IBAction)clickTodayButtom:(id)sender {
    if (self.delegate&&[self.delegate respondsToSelector:@selector(clickInHeadCell:withTodayButtom:)]) {
        [self.delegate clickInHeadCell:self withTodayButtom:sender];
    }
}

- (IBAction)clickAllButtom:(id)sender {
    if (self.delegate&&[self.delegate respondsToSelector:@selector(clickInHeadCell:withAllButtom:)]) {
        [self.delegate clickInHeadCell:self withAllButtom:sender];
    }

}
@end
