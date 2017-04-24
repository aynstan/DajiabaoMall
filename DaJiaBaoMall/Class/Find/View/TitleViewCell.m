//
//  TitleViewCell.m
//  DaJiaBaoMall
//
//  Created by 大家保 on 2017/3/27.
//  Copyright © 2017年 大家保. All rights reserved.
//

#import "TitleViewCell.h"
#import "ClassModel.h"

@implementation TitleViewCell



- (void)setModel:(ClassModel *)model{
    
    [self.imageUrl sd_setImageWithURL:[NSURL URLWithString:model.image] placeholderImage:[UIImage imageNamed:@"空白图"]];
    
    self.titleStr.text=0<model.title?model.title:@"";
    
    self.moreButtom.hidden=!(model.more);

}

//点击更多
- (IBAction)ClickMoreButtom:(id)sender {
    if (self.delegate&&[self.delegate respondsToSelector:@selector(clickCell:withTag:)]) {
        [self.delegate clickCell:self withTag:self.clickTag];
    }
}




@end
