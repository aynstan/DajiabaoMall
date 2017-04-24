//
//  NomessageView.h
//  DaJiaBaoMall
//
//  Created by 大家保 on 2017/4/16.
//  Copyright © 2017年 大家保. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^ClickBlock) ();

@interface NomessageView : UIView
//按钮内容
@property (nonatomic,copy) NSString *buttomTitle;
//按钮
@property (weak, nonatomic) IBOutlet UIButton *titleButtom;
//点击事件
@property (nonatomic,copy) ClickBlock clickBlock;


@end
