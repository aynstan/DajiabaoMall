//
//  OrderCell.m
//  DaJiaBaoMall
//
//  Created by 大家保 on 2017/3/31.
//  Copyright © 2017年 大家保. All rights reserved.
//

#import "OrderCell.h"
#import "OrderModel.h"

@implementation OrderCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setModel:(OrderModel *)model{
    self.timeLabel.text=[self timeToString:model.createtime];
    if (model.status==1) {
        self.statusLabel.text=@"待支付";
        self.statusLabel.textColor=[UIColor colorWithHexString:@"#ff693a"];
    }else if (model.status==2){
        self.statusLabel.text=@"已支付";
        self.statusLabel.textColor=[UIColor colorWithHexString:@"#00b675"];
    }else if (model.status==3){
        self.statusLabel.text=@"已退保";
        self.statusLabel.textColor=[UIColor colorWithHexString:@"#ff693a"];
    }
    self.nameLabel.text=(0==model.name.length?@"":model.name);
    self.productNameLabel.text=(0==model.productname.length?@"":model.productname);
    self.danhaoLabel.text=(0==model.policyno.length?@"":model.policyno);
    self.tuiguangfeiLabel.text=[NSString stringWithFormat:@"%.2f元",model.tuiguangfee];
    self.baofeiLabel.text=[NSString stringWithFormat:@"%.2f元",model.baofee];
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

@end
