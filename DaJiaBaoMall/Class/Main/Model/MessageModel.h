//
//  MessageModel.h
//  DaJiaBaoMall
//
//  Created by 大家保 on 2017/4/15.
//  Copyright © 2017年 大家保. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MessageModel : NSObject
//客服消息数目
@property (nonatomic,assign) NSInteger *kefuCount;
//我的资产消息数目
@property (nonatomic,assign) NSInteger *zichanCount;
//邀请消息数目
@property (nonatomic,assign) NSInteger *inviteCount;
//客户消息数目
@property (nonatomic,assign) NSInteger *kehuCount;
//系统消息数目
@property (nonatomic,assign) NSInteger *systemCount;



@end
