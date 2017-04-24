//
//  OrderModel.h
//  DaJiaBaoMall
//
//  Created by 大家保 on 2017/4/15.
//  Copyright © 2017年 大家保. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderModel : NSObject
//时间
@property (nonatomic,assign) CGFloat createtime;
//投保人
@property (nonatomic,copy) NSString *name;
//状态
@property (nonatomic,assign) NSInteger status;
 //产品名称
@property (nonatomic,copy) NSString *productname;
//保单号
@property (nonatomic,copy) NSString *policyno;
//推广费
@property (nonatomic,assign) CGFloat tuiguangfee;
//保费
@property (nonatomic,assign) CGFloat baofee;
//内容url
@property (nonatomic,copy) NSString *url;

@end
