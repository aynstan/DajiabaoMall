//
//  FressProduct.m
//  DaJiaBaoMall
//
//  Created by 大家保 on 2017/4/10.
//  Copyright © 2017年 大家保. All rights reserved.
//

#import "FressProduct.h"

@implementation FressProduct

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    /* 返回的字典，key为模型属性名，value为转化的字典的多级key */
    return @{@"uId" : @"id"};
}



@end
