//
//  UsedProduct.h
//  DaJiaBaoMall
//
//  Created by 大家保 on 2017/4/13.
//  Copyright © 2017年 大家保. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UsedProduct : NSObject
//id
@property (nonatomic,assign) NSInteger uId;
//产品
@property (nonatomic,copy) NSString *productName;
//姓名
@property (nonatomic,copy) NSString *name;
//手机
@property (nonatomic,copy) NSString *mobilephone;
//点击的url
@property (nonatomic,copy) NSString *url;
//时间
@property (nonatomic,assign) long long time;

@end
