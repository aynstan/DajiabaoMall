//
//  NomessageView.m
//  DaJiaBaoMall
//
//  Created by 大家保 on 2017/4/16.
//  Copyright © 2017年 大家保. All rights reserved.
//

#import "NomessageView.h"

@implementation NomessageView

- (instancetype)init{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] lastObject];
}

- (instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    self.frame=frame;
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] lastObject];
}

- (void)setButtomTitle:(NSString *)buttomTitle{
    [self.titleButtom setTitle:buttomTitle forState:0];
}

- (IBAction)buttomClick:(id)sender {
    self.clickBlock?self.clickBlock():nil;
}

@end
