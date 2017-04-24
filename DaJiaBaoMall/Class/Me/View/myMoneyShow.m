//
//  myMoneyShow.m
//  DaJiaBaoMall
//
//  Created by 大家保 on 2017/4/12.
//  Copyright © 2017年 大家保. All rights reserved.
//

#import "myMoneyShow.h"

@implementation myMoneyShow

- (IBAction)close:(id)sender {
    self.closeBlock?self.closeBlock():nil;
}

- (IBAction)gotoLook:(id)sender {
    self.closeBlock?self.closeBlock():nil;
}
@end
