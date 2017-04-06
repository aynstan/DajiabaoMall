//
//  ErweiMaView.m
//  DaJiaBaoMall
//
//  Created by 大家保 on 2017/4/1.
//  Copyright © 2017年 大家保. All rights reserved.
//

#import "ErweiMaView.h"

@implementation ErweiMaView

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (0<[self clearSpace:textField.text].length) {
        self.postButtom.enabled=YES;
    }else{
        self.postButtom.enabled=NO;
    }
    return YES;
}

/**
 *  去除字符串空格
 *
 *  @param str 去处空格前的字符
 *
 *  @return 去处空格后的字符
 */
- (NSString *)clearSpace:(NSString *)str{
    return 0==str.length?@"":[[str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] stringByReplacingOccurrencesOfString:@" " withString:@""];
}


- (IBAction)beginPost:(id)sender {
    if (self.delegate&&[self.delegate respondsToSelector:@selector(clickView:clickPost:)]) {
        [self.delegate clickView:self clickPost:sender];
    }
}

- (IBAction)cancel:(id)sender {
    if (self.delegate&&[self.delegate respondsToSelector:@selector(clickView:clickCancel:)]) {
        [self.delegate clickView:self clickCancel:sender];
    }
}

@end
