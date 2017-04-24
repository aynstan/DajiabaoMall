//
//  VisitCountModel.h
//  DaJiaBaoMall
//
//  Created by 大家保 on 2017/4/10.
//  Copyright © 2017年 大家保. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VisitCountModel : NSObject
//今日访问量
@property (nonatomic,assign) NSInteger todayCount;
//文章阅读量
@property (nonatomic,assign) NSInteger articleCount;
//产品阅读量
@property (nonatomic,assign) NSInteger productCount;
//赠险阅读量
@property (nonatomic,assign) NSInteger zengCount;
//累计授权
@property (nonatomic,assign) NSInteger totalCount;
//赠险url
@property (nonatomic,copy) NSString *zengUrl;
//产品url
@property (nonatomic,copy) NSString *productUrl;
//今日访问量url
@property (nonatomic,copy) NSString *todayUrl;
//文章url
@property (nonatomic,copy) NSString *articleUrl;
//全部访问量url
@property (nonatomic,copy) NSString *totalUrl;
//未支付订单量
@property (nonatomic,assign) NSInteger unpayOrder;
//已支付订单
@property (nonatomic,assign) NSInteger payOrder;

@end
