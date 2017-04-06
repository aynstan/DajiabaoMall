//
//  NotDismissAlertView.h
//  BaobiaoDog
//
//  Created by 大家保 on 2016/11/30.
//  Copyright © 2016年 大家保. All rights reserved.
//

#import <UIKit/UIKit.h>
//第一个按钮的block
typedef void (^FirstButtonBlock) (NSInteger );
//第二个按钮的block
typedef void (^SecondButtonBlock) (NSInteger );

@interface NotDismissAlertView : UIView
//标题
@property (nonatomic,copy) NSString *titleStr;
//内容
@property (nonatomic,copy) NSString *content;
//是否强制更新
@property (nonatomic,assign) NSInteger toUpdate;
//第一个按钮block
@property (nonatomic,copy) FirstButtonBlock firstButtonBlock;
//第二个按钮block
@property (nonatomic,copy) SecondButtonBlock secondButtonBlock;
//初始化方法
- (instancetype)initWithTitle:(NSString *)title content:(NSString *)content toUpdate:(NSInteger)update firstButtonClick:(FirstButtonBlock)firstBlock secondButtonClick:(SecondButtonBlock)secondBlock;
@end
