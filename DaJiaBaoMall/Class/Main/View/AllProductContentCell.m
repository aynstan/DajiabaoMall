//
//  AllProductContentCell.m
//  DaJiaBaoMall
//
//  Created by 大家保 on 2017/4/1.
//  Copyright © 2017年 大家保. All rights reserved.
//

#import "AllProductContentCell.h"

@implementation AllProductContentCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (IBAction)toGetMoney:(id)sender {
    if (self.delegate &&[self.delegate respondsToSelector:@selector(clickCell:toGetMoney:)]) {
        [self.delegate clickCell:self toGetMoney:self.butomTag];
    }
}

@end
