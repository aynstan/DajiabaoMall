//
//  TixianCell.m
//  DaJiaBaoMall
//
//  Created by 大家保 on 2017/3/31.
//  Copyright © 2017年 大家保. All rights reserved.
//

#import "TixianCell.h"
#import "TixianModel.h"

@implementation TixianCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setModel:(TixianModel *)model{
    if (model.status==10) {
        self.statusLabel.text=@"提现中";
        self.tixianMoney.text=[NSString stringWithFormat:@"-%.2f",model.account];
    }else if (model.status==20){
        self.statusLabel.text=@"提现成功";
        self.tixianMoney.text=[NSString stringWithFormat:@"-%.2f",model.account];
    }else if(model.status==30){
        self.statusLabel.text=@"提现失败";
        self.tixianMoney.text=[NSString stringWithFormat:@"-%.2f",model.account];
    }else if(model.status==40){
        self.statusLabel.text=@"提现退款";
        self.tixianMoney.text=[NSString stringWithFormat:@"+%.2f",model.account];
    }
    self.timeLabel.text=[self timeToString:model.time];
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

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}



@end
