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
#define UMENG_APPKEY   @"58f4304bf29d98036d000d61"
#define weChatId       @"wx2cb63a03944301c6"
#define weChatScreat   @"519a67c3b5a4148400fa872a4b9f1b1a"

//友盟推送
#define UMPUSHKEY      @"58f4304bf29d98036d000d61"
#define UMPUSHSECRET   @"rjt33enby6zaozqyh9jy4fbwlwenqhdi"

//融云正式环境key
#define RongCloudKey   @"pkfcgjstp9ca8"
//融云正式环境用户token
#define RongCloudToken @"HcykLZuBncpigMqb3vShSzxy+6s0Y7/owVrYZxi99xEbaCBh3M0SLl5aYawhMlQfQ8WR4sVP++ZusJMqLRuJ/NYzxuGhGZa9"
//融云客服id
#define RongCloudServiceID  @"KEFU149260495739963"

//短信服务器地址
#define codeUrl          @"http://mapi.pre.dajiabao.com"
//#define codeUrl        @"http://mapi.dajiabao.com"
//玉林服务器地址
//#define   APPHOSTURL   @"http://sns.api.yulin.dev.dajiabao.com/"
//测试环境
//#define     APPHOSTURL @"http://api.qqb.test02.arrill.com"
//pre服务器地址
#define     APPHOSTURL   @"http://api.qqb.pre.arrill.com"
//正式服务器地址
//#define     APPHOSTURL @"http://api.fx.weijiabaoxian.com"
//登录
#define LOGINURL       @"/v1/member/login"
//自动登录
#define AUTOLOGINURL   @"/v1/member/autologin"
//微信登录
#define wechatLogin    @"/v1/member/wxlogin"
//客户界面
#define customer       @"/v1/customer/index"
//获取免费赠险
#define freeinsurance  @"/v1/freeinsurance/get"
//查询已使用的赠险
#define freeinsurance_getused    @"/v1/freeinsurance/getused"
//按需获取通讯录
#define supercontacts        @"/v1/supercontacts/get"
//添加到通讯录
#define supercontacts_add    @"/v1/supercontacts/add"
//获取微信群
#define getAccountList       @"/v1/supercontacts/getwxgroup"
//个人信息详情
#define  personinfo          @"/v1/person/personinfo"
//修改 昵称 公司 职务
#define  changeMeInfo        @"/v1/person/alter"
//真实姓名认证
#define  person_auth         @"/v1/person/auth"
//获客
#define supercontacts        @"/v1/supercontacts/get"
//添加通讯录
#define addcontacts          @"/v1/supercontacts/add"
//主页
#define getconfig            @"/v1/index/getconfig"
//所有产品
#define getAllProduct        @"/v1/index/getproduct"
//获客
#define gethuoke             @"/v1/index/gethuoke"
//课程
#define getClass             @"/v1/index/getprolesson"
//获取消息
#define getAllMessage        @"/v1/message/all"
//改变消息状态
#define changeMessageStatus      @"/v1/message/all"
//推广收入
#define moneyIn       @"/v1/money/in"
//提现支出
#define moneyOut      @"/v1/money/out"
//待支付
#define loadPay       @"/v1/order/query/1"
//已支付
#define alreadyPay    @"/v1/order/query/2"
//已退保
#define rebackPay     @"/v1/order/query/3"
//微信是否已绑定手机号
#define checkWechatAndPhone   @"/v1/member/prewxlogin"
//应用内绑定微信
#define wechatInLine          @"/v1/member/tiewx"
//实名认证信息
#define shimingrenzhengMsg    @"/v1/money/authinfo"
//银行卡列表
#define bankList         @"/v1/money/bankinfo"
//绑定银行卡
#define bangdingBank     @"/v1/money/tiebank"
//重新获取容云链接口令
#define reConnectRcToken @"/v1/member/gettoken"
//上传头像
#define uploadTouxiang   @"/v1/member/image"
//上传个人二维码
#define uploadErweiMa    @"/v1/member/wxqrimg"
//上传群二维码
#define uploadWXGroup    @"/v1/supercontacts/wxqun"
//获取群资料
#define  getWechatGroup  @"/v1/supercontacts/getwxgroup"
//全部邀请
#define  inviteAll       @"/v1/invite/getall"
//当月邀请
#define  monthInvite     @"/v1/invite/getmonth"
//更新融云token
#define refreshRcToken   @"/v1/member/uptoken"



//h5地址域名
//#define   H5HOSTURL   @"http://sns.wap.yulin.dev.dajiabao.com"
//#define   H5HOSTURL   @"http://www.qqb.test02.arrill.com"
#define   H5HOSTURL     @"http://www.qqb.pre.arrill.com"
//关于我们
#define aboutus        @"/sns/wap/aboutus"
//交流反馈
#define aboutalk       @"/sns/wap/aboutalk"
//邀请好友一起赚钱
#define inviteFrend    @"/sns/wap/invite/invite"
//邀请好友一起赚钱
#define  qa            @"/sns/wap/qa/index"
//如何获取微信二维码
#define  getqrcode     @"/getqrcode"
//资产
#define  zichanUrl        @"/message/list?type=10"
//邀请
#define  inviteUrl        @"/message/list?type=20"
//客户
#define  kehuUrl          @"/message/list?type=30"
//系统
#define  systemUrl        @"/message/list?type=40"
//提现
#define  tixianUrl        @"/sns/wap/account/index"
//注册协议
#define  loginagreement   @"/loginagreement"


//本地保存的user
#define ME           @"Me"
//本地保存的user
#define TOKENID      @"sid"

#endif /* QMYBUrl_h */
