//
//  SendUsedCell.m
//  DaJiaBaoMall
//
//  Created by 大家保 on 2017/4/1.
//  Copyright © 2017年 大家保. All rights reserved.
//

#import "SendUsedCell.h"
#import "FressProduct.h"
#import "ShareModel.h"
#import "OYCountDownManager.h"


@implementation SendUsedCell

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
    [super setHighlighted:highlighted animated:animated];
    self.contentView.backgroundColor=[UIColor colorWithHexString:@"#f6f5f4"];;
    [self.timeLabel setBackgroundImage:[UIImage imageNamed:@"时间底色"] forState:0];
    self.bgView.backgroundColor=[UIColor whiteColor];
    self.line1.backgroundColor=[UIColor colorWithHexString:@"#dcdcdc"];
    self.line2.backgroundColor=[UIColor colorWithHexString:@"#dcdcdc"];
    self.line3.backgroundColor=[UIColor colorWithHexString:@"#dcdcdc"];
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        // 监听通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(countDownNotification) name:kCountDownNotification object:nil];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder{
    self = [super initWithCoder:coder];
    if (self) {
        // 监听通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(countDownNotification) name:kCountDownNotification object:nil];
    }
    return self;
}

#pragma mark - 倒计时通知回调
- (void)countDownNotification {
    // 计算倒计时
    long long countDown = (self.model.endTime-self.model.nowtime)/1000.0 - kCountDownManager.timeInterval;
    if (countDown <= 0){
        [self.timeLabel setTitle:@"免费赠险已结束" forState:0];
        if (self.countDownZero) {
            self.countDownZero();
        }
        return;
    }
    // 重新赋值
    [self.timeLabel setTitle:[self dateTimeDifferenceWithStartTime:countDown] forState:0];
}


- (IBAction)shareToFrend:(id)sender {
    if (self.delegate&&[self.delegate respondsToSelector:@selector(clickCell:onTheShareIndex:)]) {
        [self.delegate clickCell:self onTheShareIndex:self.buttomTag];
    }
}

- (IBAction)quicklyBuy:(id)sender {
    if (self.delegate&&[self.delegate respondsToSelector:@selector(clickCell:onTheBuyIndex:)]) {
        [self.delegate clickCell:self onTheBuyIndex:self.buttomTag];
    }
}

- (void)setModel:(FressProduct *)productModel{
    //model
    _model=productModel;
    ShareModel *shareModel=productModel.productInfo;
    //产品图片
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:shareModel.image] placeholderImage:[UIImage imageNamed:@"空白图"]];
    //产品名称
    self.productName.text=0==shareModel.title.length?@"":shareModel.title;
    //保障年龄
    self.ageLabel.text=0==shareModel.age.length?@"":shareModel.age;
    //保障期限
    NSString *shengyu= 0==shareModel.time.length?@"":shareModel.time;
    self.qixianLabel.text=[NSString stringWithFormat:@"%@天",shengyu];
    //价钱
    NSString *price=0==shareModel.price.length?@"":shareModel.price;
    self.productPrice.text=[NSString stringWithFormat:@"%@元",price];
    // 手动调用通知的回调（倒计时）
    [self countDownNotification];
}

//计算剩余天数
- (NSString *)dateTimeDifferenceWithStartTime:(long long)lostTime{
    long long value=lostTime;
    int second = (int)value %60;//秒
    int minute = (int)value /60%60;
    int house = (int)value / (24 * 3600)%3600;
    int day = (int)value / (24 * 3600);
    NSString *str;
    if (day != 0) {
        str = [NSString stringWithFormat:@"%d天%d小时%d分%d秒后过期",day,house,minute,second];
    }else if (day==0 && house != 0) {
        str = [NSString stringWithFormat:@"%d小时%d分%d秒后过期",house,minute,second];
    }else if (day== 0 && house== 0 && minute!=0) {
        str = [NSString stringWithFormat:@"%d分%d秒后过期",minute,second];
    }else{
        str = [NSString stringWithFormat:@"%d秒后过期",second];
    }
    return str;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

@end
