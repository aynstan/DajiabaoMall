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
    NSString *clipName=model.name;
    clipName=4<clipName.length?[clipName substringFromIndex:4]:clipName;
    self.headImageLabel.text=0<clipName?[clipName substringToIndex:1]:@"无";
    self.name.text=0<clipName.length?clipName:@"无";
    self.phoneLabel.text=0<model.mobilephone?[self place:model.mobilephone]:@"";
    self.selectButtom.selected=model.checked;
    self.headImageLabel.backgroundColor=(model.sex==1?[UIColor colorWithHexString:@"#a0c0ef"]:[UIColor colorWithHexString:@"#ffc3c3"]);
    if (model.sex!=0&&model.sex!=1) {
        self.sexLabel.text=@"保密";
    }else{
        self.sexLabel.text=(model.sex==0?@"女":@"男");
    }
}

- (NSString *)place:(NSString *)str{
    if (7>str.length) {
        return str;
    }
    NSMutableString *cardIdStr=[[NSMutableString alloc]initWithString:str];
    for (int i=3; i<cardIdStr.length-4; i++) {
        [cardIdStr replaceCharactersInRange:NSMakeRange(i, 1) withString:@"*"];
    }
    return cardIdStr;
}


- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
