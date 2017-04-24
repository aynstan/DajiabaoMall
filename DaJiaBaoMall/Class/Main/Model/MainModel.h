//
//  MainModel.h
//  DaJiaBaoMall
//
//  Created by 大家保 on 2017/4/14.
//  Copyright © 2017年 大家保. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MainHeadModel.h"
#import "ProductModel.h"

@interface MainModel : NSObject
//头部
@property (nonatomic,strong) MainHeadModel *head;
//内容区域
@property (nonatomic,strong) NSArray<ProductModel *> *productList;

@end
