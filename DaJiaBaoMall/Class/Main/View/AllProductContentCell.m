//
//  AllProductContentCell.m
//  DaJiaBaoMall
//
//  Created by 大家保 on 2017/4/1.
//  Copyright © 2017年 大家保. All rights reserved.
//

#import "AllProductContentCell.h"
#import "ProductContentModel.h"

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

- (void)setModel:(ProductContentModel *)model{
    self.contentTitle.text=model.name?model.name:@"";
    self.contentSubTitle.text=model.title?model.title:@"";
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:model.image] placeholderImage:[UIImage imageNamed:@"空白图"]];
    self.tuiguangLabel.text=model.referee?[NSString stringWithFormat:@"/推广费%ld%@",(long)model.referee,@"%"]:@"";
    self.tuiguangLabel.hidden=self.closeEye;
    
    NSString *price=[NSString stringWithFormat:@"%ld",(long)model.price];
    NSString *usePrice=[NSString stringWithFormat:@"%@元起",price];
    NSMutableAttributedString *attr=[[NSMutableAttributedString alloc]initWithString:usePrice];
    [attr addAttribute:NSFontAttributeName value:font16 range:NSMakeRange(0, price.length)];
    self.contentPrice.attributedText=attr;
    
}

@end
