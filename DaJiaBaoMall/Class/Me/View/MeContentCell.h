//
//  MeContentCell.h
//  DaJiaBaoMall
//
//  Created by 大家保 on 2017/3/28.
//  Copyright © 2017年 大家保. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MeContentCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *contentTitle;

@property (weak, nonatomic) IBOutlet UIButton *isHot;

@property (weak, nonatomic) IBOutlet UIImageView *hadImage;

@property (weak, nonatomic) IBOutlet UILabel *subTile;

@property (weak, nonatomic) IBOutlet UIImageView *forwarImage;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *widthConstens;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heithConstens;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightContents;

@end
