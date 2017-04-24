//
//  GetCustomCell.h
//  DaJiaBaoMall
//
//  Created by 大家保 on 2017/3/27.
//  Copyright © 2017年 大家保. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Huoke;

@interface GetCustomCell : UITableViewCell
//图片
@property (weak, nonatomic) IBOutlet UIImageView *headImage;
//标题
@property (weak, nonatomic) IBOutlet UILabel *contentTitle;
//副标题
@property (weak, nonatomic) IBOutlet UILabel *contentSubTitle;
//model
@property (nonatomic,strong) Huoke *model;

@end
