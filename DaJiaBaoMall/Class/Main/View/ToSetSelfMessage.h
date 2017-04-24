//
//  ToSetSelfMessage.h
//  DaJiaBaoMall
//
//  Created by 大家保 on 2017/4/20.
//  Copyright © 2017年 大家保. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^SetCancelBlock) ();

typedef void (^CloseSeetBlock) ();

@interface ToSetSelfMessage : UIView

- (IBAction)toSet:(id)sender;

@property (nonatomic,copy) SetCancelBlock setBlock;

@property (nonatomic,copy) CloseSeetBlock closeBlock;

@end
