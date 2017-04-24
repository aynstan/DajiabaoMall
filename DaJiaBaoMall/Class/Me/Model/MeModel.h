//
//  MeModel.h
//  DaJiaBaoMall
//
//  Created by 大家保 on 2017/4/13.
//  Copyright © 2017年 大家保. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MeModel : NSObject<NSCoding>
//电话
@property (nonatomic,copy) NSString *mobilephone;
//名字
@property (nonatomic,copy) NSString *name;
//头像
@property (nonatomic,copy) NSString *picture;
//是否已认证通过
@property (nonatomic,assign) BOOL isauth;
//是否已绑定微信
@property (nonatomic,assign) BOOL weixinauth;
//微信id
@property (nonatomic,copy) NSString *wxToken;
//性别
@property (nonatomic,copy) NSString *sex;
//公司
@property (nonatomic,copy) NSString *company;
//职务
@property (nonatomic,copy) NSString *position;
//二维码地址
@property (nonatomic,copy) NSString *qrimage;
//融云id
@property (nonatomic,copy) NSString *ryToken;

#pragma mark 银行信息
//银行名称
@property (nonatomic, copy) NSString *bankname;
//是否已绑定银行卡
@property (nonatomic, assign) BOOL bankAuth;
//银行logo
@property (nonatomic, copy) NSString *banklogo;
//卡号
@property (nonatomic, copy) NSString *banknum;
//银行客服电话
@property (nonatomic, copy) NSString *serviceTel;
//账户余额
@property (nonatomic, copy) NSString *account;
//本月收入
@property (nonatomic, copy) NSString *monthincome;
//累计收入
@property (nonatomic, copy) NSString *totalincome;
//冻结金额
@property (nonatomic, copy) NSString *frozenmoney;
//解冻时间
@property (nonatomic, assign) long long frozentime;


@end
