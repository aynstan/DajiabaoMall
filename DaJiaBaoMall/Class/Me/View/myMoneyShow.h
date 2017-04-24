//
//  myMoneyShow.h
//  DaJiaBaoMall
//
//  Created by 大家保 on 2017/4/12.
//  Copyright © 2017年 大家保. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^CloseBlock) ();

@interface myMoneyShow : UIView
//图片
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (nonatomic,copy)CloseBlock closeBlock;

//关闭
- (IBAction)close:(id)sender;

@end
