//
//  ShouyeContentCell.m
//  DaJiaBaoMall
//
//  Created by 大家保 on 2017/3/28.
//  Copyright © 2017年 大家保. All rights reserved.
//

#import "ShouyeContentCell.h"

@implementation ShouyeContentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.contentView.backgroundColor=[UIColor whiteColor];
    self.ContentBgView.backgroundColor = RGB(231, 231, 232);
    self.lineLabel.backgroundColor=[UIColor colorWithHexString:@"#B3B3B3"];
    self.tuiguangfeiLabel.backgroundColor=[UIColor redColor];
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    [super setHighlighted:highlighted animated:animated];
    self.contentView.backgroundColor=[UIColor whiteColor];
    self.ContentBgView.backgroundColor = [UIColor whiteColor];
    self.lineLabel.backgroundColor=[UIColor colorWithHexString:@"#B3B3B3"];
    self.tuiguangfeiLabel.backgroundColor=[UIColor redColor];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    NSString *str=@"• 人人都买得起的高端医疗保障\n• 不只是百万医疗，保障额度逆天高";
    NSMutableAttributedString *attr=[[NSMutableAttributedString alloc]initWithString:str];
    NSMutableParagraphStyle *style=[[NSMutableParagraphStyle alloc]init];
    [style setLineSpacing:12];
    [attr addAttribute:NSFontAttributeName value:font14 range:NSMakeRange(0, str.length)];
    [attr addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, str.length)];
    
    self.jieshaoLabel.attributedText=attr;
}

@end
