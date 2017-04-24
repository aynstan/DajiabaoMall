//
//  KehuContentCell.h
//  DaJiaBaoMall
//
//  Created by 大家保 on 2017/3/28.
//  Copyright © 2017年 大家保. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KehuContentCell : UITableViewCell
//图片
@property (weak, nonatomic) IBOutlet UIImageView *imageViewHead;
//标题
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
//副标题
@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;


@end
