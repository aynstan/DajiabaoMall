//
//  SendProductShow.m
//  DaJiaBaoMall
//
//  Created by 大家保 on 2017/4/13.
//  Copyright © 2017年 大家保. All rights reserved.
//

#import "SendProductShow.h"

@implementation SendProductShow


- (IBAction)close:(id)sender {
    self.closeBlock?self.closeBlock():nil;
}

- (IBAction)gotoLook:(id)sender {
    self.closeBlock?self.closeBlock():nil;
}
@end
