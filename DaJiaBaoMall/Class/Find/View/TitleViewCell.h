//
//  TitleViewCell.h
//  DaJiaBaoMall
//
//  Created by 大家保 on 2017/3/27.
//  Copyright © 2017年 大家保. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ClassModel;
@class TitleViewCell;

@protocol TitleViewCell_Delegate <NSObject>

- (void)clickCell:(TitleViewCell *)cell withTag:(NSInteger )tag;

@end

@interface TitleViewCell : UIView

@property (nonatomic,strong)ClassModel *model;
//图片地址
@property (weak, nonatomic) IBOutlet UIImageView *imageUrl;
//标题
@property (weak, nonatomic) IBOutlet UILabel *titleStr;
//更多
@property (weak, nonatomic) IBOutlet UIButton *moreButtom;
//第几个section
@property (nonatomic,assign) NSInteger clickTag;

@property (nonatomic,assign) id<TitleViewCell_Delegate> delegate;

- (IBAction)ClickMoreButtom:(id)sender;



@end
