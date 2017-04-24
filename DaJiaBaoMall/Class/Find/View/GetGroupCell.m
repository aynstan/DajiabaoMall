//
//  GetGroupCell.m
//  DaJiaBaoMall
//
//  Created by 大家保 on 2017/4/1.
//  Copyright © 2017年 大家保. All rights reserved.
//

#import "GetGroupCell.h"
#import "WechatGrop.h"

@implementation GetGroupCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setModel:(WechatGrop *)model{
    [self.wechatGropImage sd_setImageWithURL:[NSURL URLWithString:model.images] placeholderImage:[UIImage imageNamed:@"空白图"]];
    self.wechatName.text=(0==model.name.length?@"":[NSString stringWithFormat:@"群主：%@",model.name]);
}

@end
