//
//  BankListController.h
//  DaJiaBaoMall
//
//  Created by 大家保 on 2017/3/31.
//  Copyright © 2017年 大家保. All rights reserved.
//

#import "BaseViewController.h"

@interface BankListController : BaseViewController

@property (nonatomic,copy) void (^BankNameBlock)(NSString *bankName,NSInteger type);

@end
