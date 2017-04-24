//
//  CustomCatogoryModel.h
//  DaJiaBaoMall
//
//  Created by 大家保 on 2017/4/15.
//  Copyright © 2017年 大家保. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Huoke.h"

@interface CustomCatogoryModel : NSObject
//类型type
@property (nonatomic,assign) NSInteger type;
//内容列表
@property (nonatomic,strong) NSArray<Huoke *>  *data;

@end
