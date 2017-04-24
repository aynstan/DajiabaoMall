//
//  EditController.h
//  DaJiaBaoMall
//
//  Created by 大家保 on 2017/3/31.
//  Copyright © 2017年 大家保. All rights reserved.
//

#import "BaseViewController.h"

@interface EditController : BaseViewController

@property (nonatomic,copy) NSString *titleStr;

@property (nonatomic,copy) NSString *placeHorderStr;

@property (nonatomic,copy) NSString *subTitleStr;

@property (nonatomic,copy) NSString *fieldText;

@property (nonatomic,copy) void (^BackBlock) (NSString *str);

@end
