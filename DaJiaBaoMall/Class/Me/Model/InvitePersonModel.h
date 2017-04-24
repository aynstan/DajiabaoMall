//
//  InvitePersonModel.h
//  DaJiaBaoMall
//
//  Created by 大家保 on 2017/4/15.
//  Copyright © 2017年 大家保. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InvitePersonModel : NSObject
//邀请人手机号
@property (nonatomic, copy) NSString *tel;
//成交件数
@property (nonatomic,assign) NSInteger count;
//名字
@property (nonatomic,copy) NSString *name;
//推广费
@property (nonatomic,assign) CGFloat sum;
//点击的跳转
@property (nonatomic,copy) NSString *url;

@end
