//
//  ClassRoomCell.m
//  DaJiaBaoMall
//
//  Created by 大家保 on 2017/3/27.
//  Copyright © 2017年 大家保. All rights reserved.
//

#import "ClassRoomCell.h"
#import "ClassContentModel.h"

@implementation ClassRoomCell

- (void)setModel:(ClassContentModel *)model{
    self.contentTitle.text=0<model.title.length?model.title:@"";
    [self.contentImageUrl sd_setImageWithURL:[NSURL URLWithString:model.image] placeholderImage:[UIImage imageNamed:@"空白图"]];
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
