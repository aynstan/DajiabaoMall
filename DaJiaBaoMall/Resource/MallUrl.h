//
//  QMYBUrl.h
//  QMYB
//
//  Created by 大家保 on 2017/2/16.
//  Copyright © 2017年 大家保. All rights reserved.
//

#ifndef MallUrl_h
#define MallUrl_h

//友盟分享

//#define weChatId       @"wx2c74c71b775936b6"
//#define weChatScreat   @"42764bb57c18a5433216b442c84e8203"
//#define UMENG_APPKEY   @"58ae8a1da325114bae000a00"

#define weChatId       @"wxd9706b31477efec2"
#define weChatScreat   @"8ab75970786ba5e7f1dcd01ba1dd15b5"
#define UMENG_APPKEY   @"579aefcae0f55a521a0023d9"

//短信服务器地址
#define codeUrl        @"http://mapi.dajiabao.com"
//徐浩服务器地址
//#define   APPHOSTURL   @"http://www.xuhao.dev.dajiabao.com"
//#define   APPHOSTURL     @"http://callback.yulin.dev.dajiabao.com"
//测试环境
//#define     APPHOSTURL   @"http://test02.dev.dajiabao.com"
//pre服务器地址
//#define     APPHOSTURL     @"http://fx.pre.weijiabaoxian.com"
//正式服务器地址
#define     APPHOSTURL     @"http://api.fx.weijiabaoxian.com"
//登录
#define LOGINURL       @"/login"
//获取全部产品
#define ProductList    @"/getProductList"
//主页更新信息
#define updateUserInfo @"/updateUserInfo"
//我的收益
#define getProfit      @"/getProfit"
//我的交易
#define getBusiness    @"/getBusiness"
//提现
#define withDraw       @"/withDraw"
//账户记录
#define getAccountList @"/getAccountList"
//账户记录
#define getEmployeeList @"/getEmployeeList"
//创建店员
#define addEmployee     @"/addEmployee"
//推荐注册
#define registerPage    @"/registerPage"
//银行卡绑定（更换）
#define bindBankCard    @"/bindBankCard"
//退出登录
#define logout          @"/logout"
//检查更新
#define updateVersion   @"/updateVersion"


//本地保存的user
#define USER           @"User"
//本地保存的user
#define TOKENID        @"TokenId"
//本地保存的userid
#define USERID         @"UserId"



#endif /* QMYBUrl_h */
