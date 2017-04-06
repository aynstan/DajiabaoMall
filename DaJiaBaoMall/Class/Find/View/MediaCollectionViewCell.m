//
//  MediaCollectionViewCell.m
//  DaJiaBaoMall
//
//  Created by 大家保 on 2017/3/30.
//  Copyright © 2017年 大家保. All rights reserved.
//

#import "MediaCollectionViewCell.h"
#import "ClassContentModel.h"

@implementation MediaCollectionViewCell

- (void)setModel:(ClassContentModel *)model{
    self.title.text=0<model.contentTitle.length?model.contentTitle:@"";
    self.subtitle.text=0<model.subTitle.length?model.subTitle:@"";
}
//分享
- (IBAction)share:(id)sender {
    if (self.cellDelegate&&[self.cellDelegate respondsToSelector:@selector(clickCell:index:)]) {
        [self.cellDelegate clickCell:self index:self.clickTag];
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

@end
