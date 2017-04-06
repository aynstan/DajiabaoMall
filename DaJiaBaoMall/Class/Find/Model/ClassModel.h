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

@property (nonatomic,copy) NSString *imageViewUrl;

@property (nonatomic,copy) NSString *titleStr;

@property (nonatomic,assign) BOOL hasMore;

@property (nonatomic,assign) NSInteger type;

@property (nonatomic,copy) NSString *moreUrl;

@property (nonatomic,strong) NSMutableArray<ClassContentModel *> *contentArray;

@end
