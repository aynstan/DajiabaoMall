//
//  InviteModel.h
//  DaJiaBaoMall
//
//  Created by 大家保 on 2017/4/15.
//  Copyright © 2017年 大家保. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "InvitePersonModel.h"

@interface InviteModel : NSObject
//邀请人数
@property (nonatomic, assign) NSInteger  inviteCount;
//成交件数
@property (nonatomic, assign) NSInteger  successCount;
//推广总金额
@property (nonatomic, assign) CGFloat    sumprofit;
//邀请人列表
@property (nonatomic, strong) NSArray<InvitePersonModel *> *data;

@end
