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
    [self.title setTitle:(0<model.title.length?model.title:@"") forState:0];
    self.subtitle.text=0<model.context.length?model.context:@"";
}
//分享
- (IBAction)share:(id)sender {
    if (self.cellDelegate&&[self.cellDelegate respondsToSelector:@selector(clickCell:index:)]) {
        [self.cellDelegate clickCell:self index:self.clickTag];
    }
}

//更改约束
- (void)layoutSubviews{
    [super layoutSubviews];
    if (self.clickTag%4==0) {
        self.bgImageView.image=[UIImage imageNamed:@"News-bg-1"];
    }else if (self.clickTag%4==1) {
        self.bgImageView.image=[UIImage imageNamed:@"News-bg-2"];
    }else if (self.clickTag%4==2) {
        self.bgImageView.image=[UIImage imageNamed:@"News-bg-3"];
    }else if (self.clickTag%4==3) {
        self.bgImageView.image=[UIImage imageNamed:@"News-bg-4"];
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

@end
