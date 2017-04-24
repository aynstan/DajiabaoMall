//
//  ShouyeContentCell.m
//  DaJiaBaoMall
//
//  Created by 大家保 on 2017/3/28.
//  Copyright © 2017年 大家保. All rights reserved.
//

#import "ShouyeContentCell.h"
#import "ProductContentModel.h"

@implementation ShouyeContentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    [super setHighlighted:highlighted animated:animated];
    self.contentView.backgroundColor=[UIColor whiteColor];
    self.ContentBgView.backgroundColor = [UIColor whiteColor];
    self.lineLabel.backgroundColor=[UIColor colorWithHexString:@"#dcdcdc"];
}


//model
- (void)setModel:(ProductContentModel *)model{
    self.titleLabel.text=model.name?model.name:@"";
    [self.headImage sd_setImageWithURL:[NSURL URLWithString:model.image] placeholderImage:[UIImage imageNamed:@"空白图"]];
    self.tuiguangfeiLabel.text=model.referee?[NSString stringWithFormat:@"推广费%ld%@",(long)model.referee,@"%"]:@"";
    self.tuiguangfeiLabel.hidden=![UserDefaults boolForKey:@"openMoney"];
    
    NSString *price=[NSString stringWithFormat:@"¥%ld元起",(long)model.price];
    NSMutableAttributedString *attrString=[[NSMutableAttributedString alloc]initWithString:price];
    [attrString addAttribute:NSFontAttributeName value:font12 range:NSMakeRange(price.length-2, 2)];
    self.zhifuLabel.attributedText=attrString;
    
    NSArray *strArr=[model.title componentsSeparatedByString:@","];
    NSString *titleStr;
    if (strArr.count) {
        NSString *title1=[@"• " stringByAppendingString:strArr[0]];
        titleStr=title1;
        if (strArr.count>=2) {
            NSString *title2=[@"• " stringByAppendingString:strArr[1]];
            titleStr=[titleStr stringByAppendingString:@"\n"];
            titleStr=[titleStr stringByAppendingString:title2];
        }
    }
    NSMutableAttributedString *attr=[[NSMutableAttributedString alloc]initWithString:titleStr];
    NSMutableParagraphStyle *style=[[NSMutableParagraphStyle alloc]init];
    [style setLineSpacing:10];
    [attr addAttribute:NSFontAttributeName value:font12 range:NSMakeRange(0, titleStr.length)];
    [attr addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, titleStr.length)];
    self.jieshaoLabel.attributedText=attr;
}

@end
