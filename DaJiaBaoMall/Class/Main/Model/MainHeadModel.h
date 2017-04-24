//
//  MainHeadModel.h
//  DaJiaBaoMall
//
//  Created by 大家保 on 2017/4/14.
//  Copyright © 2017年 大家保. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ADModel.h"
#import "SubIconModel.h"

@interface MainHeadModel : NSObject
//广告
@property (nonatomic,strong) NSArray<ADModel *> *ads;
//功能栏
@property (nonatomic,strong) NSArray<SubIconModel *> *subIcon;
//通知
@property (nonatomic,strong) NSArray *rollmsg;

@end
