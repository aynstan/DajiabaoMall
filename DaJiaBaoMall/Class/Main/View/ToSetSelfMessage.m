//
//  ToSetSelfMessage.m
//  DaJiaBaoMall
//
//  Created by 大家保 on 2017/4/20.
//  Copyright © 2017年 大家保. All rights reserved.
//

#import "ToSetSelfMessage.h"

@implementation ToSetSelfMessage


- (IBAction)close:(id)sender {
    self.closeBlock?self.closeBlock():nil;
}

- (IBAction)toSet:(id)sender {
    NSLog(@"这里");
    self.setBlock?self.setBlock():nil;
}
@end
