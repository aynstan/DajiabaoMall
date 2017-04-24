//
//  GetCustomCell.m
//  DaJiaBaoMall
//
//  Created by 大家保 on 2017/3/27.
//  Copyright © 2017年 大家保. All rights reserved.
//

#import "GetCustomCell.h"
#import "Huoke.h"

@implementation GetCustomCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setModel:(Huoke *)model{
    [self.headImage sd_setImageWithURL:[NSURL URLWithString:model.image] placeholderImage:[UIImage imageNamed:@"空白图"]];
    self.contentTitle.text=(0==model.title.length?@"":model.title);
    self.contentSubTitle.text=(0==model.info.length?@"":model.info);
}

@end
