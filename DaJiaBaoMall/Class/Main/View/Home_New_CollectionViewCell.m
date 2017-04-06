//
//  Home_New_CollectionViewCell.m
//  BaobiaoDog
//
//  Created by 大家保 on 2016/10/26.
//  Copyright © 2016年 大家保. All rights reserved.
//

#import "Home_New_CollectionViewCell.h"

@implementation Home_New_CollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
   
}

- (void)setImageString:(NSString *)imageString{
    _imageString=imageString;
    self.ContentImageView.image=[UIImage imageNamed:imageString];
}

@end
