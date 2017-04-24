//
//  ClassContentModel.h
//  DaJiaBaoMall
//
//  Created by 大家保 on 2017/3/30.
//  Copyright © 2017年 大家保. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ClassContentModel : NSObject
//内容标题
@property (nonatomic,copy) NSString *title;
//内容副标题
@property (nonatomic,copy) NSString *context;
//内容图片
@property (nonatomic,copy) NSString *image;
//内容地址
@property (nonatomic,copy) NSString *url;



@end
