//
//  CustomModel.h
//  DaJiaBaoMall
//
//  Created by 大家保 on 2017/4/15.
//  Copyright © 2017年 大家保. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CustomModel : NSObject
//图片地址
@property (nonatomic,copy) NSString *imageUrl;
//标题
@property (nonatomic,copy) NSString *title;
//副标题
@property (nonatomic,copy) NSString *subTitle;
//内容url
@property (nonatomic,copy) NSString *contentUrl;


@end
