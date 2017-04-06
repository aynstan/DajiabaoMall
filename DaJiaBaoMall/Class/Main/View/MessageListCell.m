//
//  MessageListCell.m
//  DaJiaBaoMall
//
//  Created by 大家保 on 2017/3/31.
//  Copyright © 2017年 大家保. All rights reserved.
//

#import "MessageListCell.h"

@implementation MessageListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.redImageView.backgroundColor=[UIColor redColor];
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    self.redImageView.backgroundColor=[UIColor redColor];
}

@end
