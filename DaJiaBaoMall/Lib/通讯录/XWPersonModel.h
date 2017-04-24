//
//  XWPersonModel.h
//  DaJiaBaoMall
//
//  Created by 大家保 on 2017/4/5.
//  Copyright © 2017年 大家保. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XWPersonModel : NSObject
/** 联系人的id*/
@property (nonatomic,assign)  int uId;
/** 联系人的性别*/
@property (nonatomic,assign)  int sex;
/** 联系人是否选中*/
@property (nonatomic,assign)  BOOL checked;
/** 联系人姓名*/
@property (nonatomic, copy)   NSString *name;
/** 联系人电话*/
@property (nonatomic, copy) NSString *mobilephone;
/** 联系人所属的省*/
@property (nonatomic,copy)  NSString *province;
/** 联系人所属的市*/
@property (nonatomic,copy)  NSString *city;
/** 联系人所属的区*/
@property (nonatomic,copy)  NSString *district;
/** 联系人的toeknId*/
@property (nonatomic,copy)    NSString * tokenId;

@end
