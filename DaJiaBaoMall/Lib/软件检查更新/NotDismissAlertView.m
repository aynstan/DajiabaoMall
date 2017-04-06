//
//  NotDismissAlertView.m
//  BaobiaoDog
//
//  Created by 大家保 on 2016/11/30.
//  Copyright © 2016年 大家保. All rights reserved.
//

#import "NotDismissAlertView.h"
#define alertWidth (SCREEN_WIDTH-80)

@implementation NotDismissAlertView

- (instancetype)initWithTitle:(NSString *)title content:(NSString *)content toUpdate:(NSInteger)update firstButtonClick:(FirstButtonBlock)firstBlock secondButtonClick:(SecondButtonBlock)secondBlock{
    if (self=[super init]) {
        self.titleStr=title;
        self.content=content;
        self.toUpdate=update;
        self.firstButtonBlock=firstBlock;
        self.secondButtonBlock=secondBlock;
        self.frame=CGRectMake(0, 0, alertWidth, 0);
        self.backgroundColor=[UIColor whiteColor];
        self.layer.cornerRadius=6;
        self.clipsToBounds=YES;
        
        //标题
        UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 15, CGRectGetWidth(self.frame), 18)];
        titleLabel.textColor=color2c2c2c;
        titleLabel.font=font18;
        titleLabel.textAlignment=NSTextAlignmentCenter;
        titleLabel.text=self.titleStr;
        [self addSubview:titleLabel];
        
        
        //更新内容
        NSMutableAttributedString *contentAttr=[[NSMutableAttributedString alloc]initWithString:self.content];
        NSMutableParagraphStyle  *style=[[NSMutableParagraphStyle alloc]init];
        style.lineSpacing=5;
        [contentAttr addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, self.content.length)];
        UILabel *contentLabel=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(titleLabel.frame)+15, CGRectGetMaxY(titleLabel.frame)+15, CGRectGetWidth(self.frame)-30, 2000)];
        contentLabel.numberOfLines=0;
        contentLabel.font=font14;
        contentLabel.textAlignment=NSTextAlignmentLeft;
        contentLabel.textColor=[UIColor colorWithHexString:@"#595959"];
        contentLabel.attributedText=contentAttr;
        [contentLabel sizeToFit];
        [self addSubview:contentLabel];
        
        //分割线（横向）
        UILabel *hengxian=[[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(contentLabel.frame)+18, alertWidth, 0.5)];
        hengxian.backgroundColor=colordcdde3;
        [self addSubview:hengxian];
        
        //取消，退出
        UIButton *firstButton=[UIButton buttonWithTitle:update==1?@"退出":@"取消" titleColor:color00aae7 font:font16 target:self action:@selector(firsetClick:)];
        firstButton.frame=CGRectMake(0, CGRectGetMaxY(hengxian.frame), alertWidth/2.0, 45);
        [self addSubview:firstButton];
        
        //马上更新
        UIButton *secondButton=[UIButton buttonWithTitle:@"立即更新" titleColor:color00aae7 font:font16 target:self action:@selector(secondClick:)];
        secondButton.frame=CGRectMake(alertWidth/2.0, CGRectGetMaxY(hengxian.frame), alertWidth/2.0, 45);
        [self addSubview:secondButton];
        
        //分割线（竖线）
        UILabel *shuxian=[[UILabel alloc]initWithFrame:CGRectMake(alertWidth/2.0, CGRectGetMinY(secondButton.frame), 0.5, CGRectGetHeight(secondButton.frame))];
        shuxian.backgroundColor=colordcdde3;
        [self addSubview:shuxian];
        
        CGRect oldRect=self.frame;
        oldRect.size.height=CGRectGetMaxY(secondButton.frame);
        self.frame=oldRect;
        
    }
    return self;
};

//取消或退出
- (void)firsetClick:(UIButton *)btn{
    self.firstButtonBlock(self.toUpdate);
}

//马上更新
- (void)secondClick:(UIButton *)btn{
    self.secondButtonBlock(self.toUpdate);
}

@end
