//
//  FressProduct.h
//  DaJiaBaoMall
//
//  Created by 大家保 on 2017/4/10.
//  Copyright © 2017年 大家保. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ShareModel;


@interface FressProduct : NSObject
//创建时间
@property (nonatomic,assign) long long createTime;
//结束时间
@property (nonatomic,assign) long long endTime;
//当前时间
@property (nonatomic,assign) long long nowtime;
//id
@property (nonatomic,assign) NSInteger uId;
//memberId
@property (nonatomic,assign) NSInteger memberId;
//status
@property (nonatomic,assign) NSInteger status;
//分享model
@property (nonatomic,strong) ShareModel *productInfo;



@end
