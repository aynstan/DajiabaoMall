//
//  ProductContentModel.h
//  DaJiaBaoMall
//
//  Created by 大家保 on 2017/4/14.
//  Copyright © 2017年 大家保. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProductContentModel : NSObject
//产品名
@property (nonatomic,copy) NSString *name;
//产品内容
@property (nonatomic,copy) NSString *title;
//产品图片地址
@property (nonatomic,copy) NSString *image;
//产品价钱
@property (nonatomic,assign) NSInteger price;
//产品返点
@property (nonatomic,assign) NSInteger referee;
//内容url
@property (nonatomic,copy) NSString *url;

@end
