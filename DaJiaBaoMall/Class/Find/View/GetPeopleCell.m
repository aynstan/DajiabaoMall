//
//  GetPeopleCell.m
//  DaJiaBaoMall
//
//  Created by 大家保 on 2017/4/1.
//  Copyright © 2017年 大家保. All rights reserved.
//

#import "GetPeopleCell.h"
#import "XWPersonModel.h"

@implementation GetPeopleCell

- (IBAction)selectedButtom:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickCell:onButtonIndex:)]) {
        [self.delegate clickCell:self onButtonIndex:self.butoonIndex];
    }
}

- (void)setModel:(XWPersonModel *)model{
    self.headImageLabel.text=0<model.name?[model.name substringToIndex:1]:@"无";
    self.name.text=0<model.name?model.name:@"无";
    self.phoneLabel.text=0<model.phone?model.phone:@"";
    self.sexLabel.text=0<model.sex?model.sex:@"保密";
    self.selectButtom.selected=model.checked;
    self.headImageLabel.backgroundColor=[model.sex isEqualToString:@"男"]?[UIColor blueColor]:[UIColor redColor];
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
