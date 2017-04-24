//
//  TuiguangCell.m
//  DaJiaBaoMall
//
//  Created by 大家保 on 2017/3/31.
//  Copyright © 2017年 大家保. All rights reserved.
//

#import "TuiguangCell.h"
#import "TuiguangModel.h"

@implementation TuiguangCell


- (void)setModel:(TuiguangModel *)model{
    self.tuiguangName.text=(model.name.length?model.name:@"");
    self.beginTime.text=[self timeToString:model.time];
    self.tuiguangMoney.text=[NSString stringWithFormat:@"%.2f元",model.rate];
    self.baofei.text=[NSString stringWithFormat:@"%.2f元",model.price];
    self.productName.text=(model.productname.length?model.productname:@"");
}

- (NSString *)timeToString:(long long) miaoshu{
    NSDate *date =[[NSDate alloc]initWithTimeIntervalSince1970:miaoshu/1000.0];
    NSTimeZone *zone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
    NSInteger interval = [zone secondsFromGMTForDate:date];
    NSDate *localeDate = [date  dateByAddingTimeInterval: interval];
    NSDateFormatter *dateFormat=[[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm"];
    return  [dateFormat stringFromDate:localeDate];
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
