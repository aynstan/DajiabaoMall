//
//  TuiguangModel.h
//  DaJiaBaoMall
//
//  Created by 大家保 on 2017/4/16.
//  Copyright © 2017年 大家保. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TuiguangModel : NSObject
//推广人
@property (nonatomic, copy) NSString *name;
//推广时间
@property (nonatomic, assign) long long time;
//推广费
@property (nonatomic, assign) CGFloat rate;
//保费
@property (nonatomic, assign) CGFloat price;
//产品名称
@property (nonatomic, copy) NSString *productname;
//详情url
@property (nonatomic, copy) NSString *url;

@end
