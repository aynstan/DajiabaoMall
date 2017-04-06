//
//  ToastErweiMaView.h
//  DaJiaBaoMall
//
//  Created by 大家保 on 2017/4/1.
//  Copyright © 2017年 大家保. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ToastErweiMaView;

@protocol ToastErweiMaView_Delegate <NSObject>

- (void)clickView:(ToastErweiMaView *)view clickToastCancel:(UIButton *)sender;

- (void)clickView:(ToastErweiMaView *)view clickSave:(UIButton *)sender;

@end


@interface ToastErweiMaView : UIView

@property (weak, nonatomic) IBOutlet UIImageView *erweimaImageView;

@property (weak, nonatomic) IBOutlet UILabel *tishi;

- (IBAction)cancel:(id)sender;

- (IBAction)saveImage:(id)sender;

@property (nonatomic,assign) id<ToastErweiMaView_Delegate> delegate;

@end
