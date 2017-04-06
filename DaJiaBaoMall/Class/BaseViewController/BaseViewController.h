//
//  QMYBBaseViewController.h
//  QMYB
//
//  Created by 大家保 on 2017/2/15.
//  Copyright © 2017年 大家保. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController

/**
 *  自定义导航栏
 */
@property (nonatomic, strong) UIView * bgView;
/**
 *  统一导航栏初始化
 */
- (void)initNavBar;
/**
 *  添加返回按钮
 */
- (void)addLeftButton;
/**
 *  添加左边按钮
 *
 */
- (void)addLeftBarButton:(NSString *)imageName;
/**
 *  右边按钮（文字）
 *
 *  @param rightStr 按钮标题
 */
- (void)addRightButton:(NSString *)rightStr;
/**
 *  右边按钮（图片）
 */
- (void)addRightButtonWithImageName:(NSString *)imageName;
/**
 *  添加导航栏标题
 *
 *  @param title 标题
 */
- (void)addTitle:(NSString *)title;
/**
 *  右边按钮事件
 *
 *  @param button 右边按钮
 */
- (void)forward:(UIButton *)button;
/**
 *  返回按钮事件
 */
- (void)back;
/**
 *  leftBarButton点击事件 ,子类重写
 *
 */
- (void)leftClick:(UIButton *)btn;
/**
 *  去除字符串空格
 *
 *  @param str 去处空格前的字符
 *
 *  @return 去处空格后的字符
 */
- (NSString *)clearSpace:(NSString *)str;


/**
 *  网络是否可用
 *
 *  @return 网络是否可用
 */
-(BOOL)isNetworkRunning;


#pragma mark - 右侧滑动到某个控制器
/** 右侧滑动到第几个视图控制器  从0开始计算 */
- (void)rightSlideToViewControllerIndex:(NSInteger)index;


/** 右侧滑动到根部视图控制器 */
- (void)rightSlideToRootController;

#pragma mark - 多行文本高度
-(CGFloat)changeStationWidth:(NSString *)string anWidthTxtt:(CGFloat)widthText anfont:(CGFloat)fontSize;

/** 设置IQKeyBorderManager */
- (void)setIQKeyBorderManager;

//设置银行卡号样式
- (NSString *)BankNum:(NSString *)bankID;

//缺省页
- (UIView *)noMessageView :(NSString *)str;

//返回银行卡号
- (NSString *)returnBankName:(NSString*) idCard;

@end
