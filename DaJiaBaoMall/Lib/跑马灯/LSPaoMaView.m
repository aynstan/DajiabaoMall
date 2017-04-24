//
//  LSPaoMaView.m
//  LSDevelopmentModel
//
//  Created by  tsou117 on 15/7/29.
//  Copyright (c) 2015年  tsou117. All rights reserved.
//

#import "LSPaoMaView.h"

@implementation LSPaoMaView{
    //标记第一个位置
    CGRect rectMark1;
    //标记第二个位置
    CGRect rectMark2;
    //label数组
    NSMutableArray* labelArr;
    //时间
    NSTimeInterval timeInterval;
    //停止
    BOOL isStop;
}

//初始化
- (instancetype)initWithFrame:(CGRect)frame{
    if ([super initWithFrame:frame]) {
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.1];
        self.clipsToBounds = YES;
    }
    return self;
}

//设置跑马灯内容
- (void)setShowTitle:(NSString *)showTitle{
    for (UIView *subView in self.subviews) {
        [subView removeFromSuperview];
    }
    //显示的文字
    _showTitle = [NSString stringWithFormat:@"   %@   ",showTitle];
    //间隔
    timeInterval = [self displayDurationForString:showTitle];
    //文本
    UILabel* textLb = [[UILabel alloc] initWithFrame:CGRectZero];
    textLb.textColor = TEXTCOLOR;
    textLb.font = font12;
    textLb.text = showTitle;
    //计算textLb大小
    CGSize sizeOfText = [textLb sizeThatFits:CGSizeZero];
    //初始化两个位置信息
    rectMark1 =sizeOfText.width>SCREEN_WIDTH?CGRectMake(0, 0, sizeOfText.width, self.bounds.size.height):CGRectMake(0, 0, SCREEN_WIDTH, self.bounds.size.height);
    rectMark2 =sizeOfText.width>SCREEN_WIDTH ? CGRectMake(rectMark1.origin.x+rectMark1.size.width, 0, sizeOfText.width, self.bounds.size.height):CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, self.bounds.size.height);
    //显示第一条
    textLb.frame = rectMark1;
    [self addSubview:textLb];
    //文本数组
    labelArr = [NSMutableArray arrayWithObject:textLb];
    //添加reserveTextLb
    UILabel* reserveTextLb = [[UILabel alloc] initWithFrame:rectMark2];
    reserveTextLb.textColor = TEXTCOLOR;
    reserveTextLb.font = font12;
    reserveTextLb.text = showTitle;
    [self addSubview:reserveTextLb];
    [labelArr addObject:reserveTextLb];
    //开始移动
    [self paomaAnimate];
}

//开始移动
- (void)paomaAnimate{
    if (!isStop) {
        UILabel* lbindex0 = labelArr[0];
        UILabel* lbindex1 = labelArr[1];
        [UIView transitionWithView:self duration:timeInterval options:UIViewAnimationOptionCurveLinear animations:^{
            lbindex0.frame = rectMark1.size.width>SCREEN_WIDTH?CGRectMake(-rectMark1.size.width, 0, rectMark1.size.width, rectMark1.size.height): CGRectMake(-SCREEN_WIDTH, 0, SCREEN_WIDTH, rectMark1.size.height);
            lbindex1.frame = rectMark1.size.width>SCREEN_WIDTH?CGRectMake(lbindex0.frame.origin.x+lbindex0.frame.size.width, 0, lbindex1.frame.size.width, rectMark1.size.height):CGRectMake(0, 0, SCREEN_WIDTH, lbindex1.frame.size.height);
        } completion:^(BOOL finished) {
            lbindex0.frame = rectMark2;
            lbindex1.frame = rectMark1;
            [labelArr replaceObjectAtIndex:0 withObject:lbindex1];
            [labelArr replaceObjectAtIndex:1 withObject:lbindex0];
            [self paomaAnimate];
        }];
    }
}

//是否停止
- (void)stop{
    isStop = YES;
}

//完成一圈所花时间
- (NSTimeInterval)displayDurationForString:(NSString*)string {
    return string.length;
}

@end
