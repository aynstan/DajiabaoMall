//
//  ToastErweiMaView.m
//  DaJiaBaoMall
//
//  Created by 大家保 on 2017/4/1.
//  Copyright © 2017年 大家保. All rights reserved.
//

#import "ToastErweiMaView.h"

@implementation ToastErweiMaView


- (IBAction)cancel:(id)sender {
    if (self.delegate&&[self.delegate respondsToSelector:@selector(clickView:clickToastCancel:)]) {
        [self.delegate clickView:self clickToastCancel:sender];
    }
}

- (IBAction)saveImage:(id)sender {
    if (self.delegate&&[self.delegate respondsToSelector:@selector(clickView:clickSave:)]) {
        [self.delegate clickView:self clickSave:sender];
    }
}
@end
