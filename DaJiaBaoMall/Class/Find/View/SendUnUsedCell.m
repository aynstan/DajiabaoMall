//
//  SendUnUsedCell.m
//  DaJiaBaoMall
//
//  Created by 大家保 on 2017/4/1.
//  Copyright © 2017年 大家保. All rights reserved.
//

#import "SendUnUsedCell.h"
#import "UsedProduct.h"

@implementation SendUnUsedCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.contentView.backgroundColor=colorF3F4F5;
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
    [super setHighlighted:highlighted animated:animated];
    self.contentView.backgroundColor=colorF3F4F5;
    self.bgView.backgroundColor=[UIColor whiteColor];
}

- (void)setModel:(UsedProduct *)model{
    self.contentTitle.text=0==model.productName.length?@"":model.productName;
    self.peopleName.text=0==model.name.length?@"":model.name;
    self.peoplePhone.text=0==model.mobilephone?@"":model.mobilephone;
    self.timeLabel.text=[NSString stringWithFormat:@"投保时间：%@",[self timeToString:model.time]];
}

- (NSString *)timeToString:(long long) miaoshu{
    NSDate *date =[[NSDate alloc]initWithTimeIntervalSince1970:miaoshu/1000.0];
    NSTimeZone *zone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
    NSInteger interval = [zone secondsFromGMTForDate:date];
    NSDate *localeDate = [date  dateByAddingTimeInterval: interval];
    NSDateFormatter *dateFormat=[[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    return  [dateFormat stringFromDate:localeDate];
    
}


@end
