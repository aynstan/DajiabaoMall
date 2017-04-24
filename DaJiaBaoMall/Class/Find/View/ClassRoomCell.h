//
//  ClassRoomCell.h
//  DaJiaBaoMall
//
//  Created by 大家保 on 2017/3/27.
//  Copyright © 2017年 大家保. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ClassContentModel;

@interface ClassRoomCell : UITableViewCell
//标题
@property (weak, nonatomic) IBOutlet UILabel *contentTitle;
//图片地址
@property (weak, nonatomic) IBOutlet UIImageView *contentImageUrl;
//model
@property (nonatomic,strong) ClassContentModel *model;

@end
