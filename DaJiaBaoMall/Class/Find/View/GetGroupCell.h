//
//  GetGroupCell.h
//  DaJiaBaoMall
//
//  Created by 大家保 on 2017/4/1.
//  Copyright © 2017年 大家保. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WechatGrop;

@interface GetGroupCell : UICollectionViewCell
//群图片地址
@property (weak, nonatomic) IBOutlet UIImageView *wechatGropImage;
//群主名
@property (weak, nonatomic) IBOutlet UILabel *wechatName;
//model
@property (nonatomic,strong) WechatGrop *model;

@end
