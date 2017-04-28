//
//  MessageListCell.h
//  DaJiaBaoMall
//
//  Created by 大家保 on 2017/3/31.
//  Copyright © 2017年 大家保. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageListCell : UITableViewCell
//第一个图片
@property (weak, nonatomic) IBOutlet UIImageView *FirstImageView;
//标题
@property (weak, nonatomic) IBOutlet UILabel *title;
//副标题
@property (weak, nonatomic) IBOutlet UILabel *subTitle;
//红色图片
@property (weak, nonatomic) IBOutlet UIImageView *redImageView;
//分割线
@property (weak, nonatomic) IBOutlet UILabel *line;

@end
