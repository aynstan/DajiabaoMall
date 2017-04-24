//
//  ProductModel.h
//  DaJiaBaoMall
//
//  Created by 大家保 on 2017/4/14.
//  Copyright © 2017年 大家保. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ProductContentModel.h"

@interface ProductModel : NSObject
//产品分类标题
@property (nonatomic,copy) NSString *category;
//分类产品列表
@property (nonatomic,strong) NSArray<ProductContentModel *> *product;

@end
