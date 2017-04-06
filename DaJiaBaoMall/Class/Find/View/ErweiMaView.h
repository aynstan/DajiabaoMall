//
//  ErweiMaView.h
//  DaJiaBaoMall
//
//  Created by 大家保 on 2017/4/1.
//  Copyright © 2017年 大家保. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ErweiMaView;

@protocol ErweiMaView_Delegate <NSObject>

- (void)clickView:(ErweiMaView *)view clickCancel:(UIButton *)sender;

- (void)clickView:(ErweiMaView *)view clickPost:(UIButton *)sender;

@end

@interface ErweiMaView : UIView
//二维码图片
@property (weak, nonatomic) IBOutlet UIImageView *erweiMaImageView;
//群主微信号
@property (weak, nonatomic) IBOutlet UITextField *erweimaNum;
//上传按钮
@property (weak, nonatomic) IBOutlet UIButton *postButtom;
//代理
@property (nonatomic,assign) id<ErweiMaView_Delegate> delegate;
//上传
- (IBAction)beginPost:(id)sender;
//取消
- (IBAction)cancel:(id)sender;

@end
