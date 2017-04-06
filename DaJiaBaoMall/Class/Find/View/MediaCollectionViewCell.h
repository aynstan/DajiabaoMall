//
//  MediaCollectionViewCell.h
//  DaJiaBaoMall
//
//  Created by 大家保 on 2017/3/30.
//  Copyright © 2017年 大家保. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ClassContentModel;
@class MediaCollectionViewCell;

@protocol MediaCollectionViewCell_Delegate <NSObject>

- (void)clickCell:(MediaCollectionViewCell *)cell index:(NSInteger )clickIndex;

@end

@interface MediaCollectionViewCell : UICollectionViewCell
//标题
@property (weak, nonatomic) IBOutlet UILabel *title;
//副标题
@property (weak, nonatomic) IBOutlet UILabel *subtitle;

@property (nonatomic,strong)ClassContentModel *model;

@property (nonatomic,assign) NSInteger clickTag;

@property (nonatomic,assign) id<MediaCollectionViewCell_Delegate> cellDelegate;

@end
