//
//  ClassModel.h
//  DaJiaBaoMall
//
//  Created by 大家保 on 2017/3/30.
//  Copyright © 2017年 大家保. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ClassContentModel;

@interface ClassModel : NSObject
//头部图片
@property (nonatomic,copy) NSString *image;
//头部分类标题
@property (nonatomic,copy) NSString *title;
//是否有更多
@property (nonatomic,assign) BOOL more;
//类型
@property (nonatomic,assign) NSInteger type;
//更多的url
@property (nonatomic,copy) NSString *url;
//内容
@property (nonatomic,strong) NSMutableArray<ClassContentModel *> *data;

@end
