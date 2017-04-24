//
//  kehuHeadCell.h
//  DaJiaBaoMall
//
//  Created by 大家保 on 2017/3/28.
//  Copyright © 2017年 大家保. All rights reserved.
//

#import <UIKit/UIKit.h>
@class kehuHeadCell;

@protocol kehuHeadCellDelegate <NSObject>

- (void)clickInHeadCell:(kehuHeadCell *)cell withTodayButtom:(UIButton *)btn;

- (void)clickInHeadCell:(kehuHeadCell *)cell withAllButtom:(UIButton *)btn;

@end


@interface kehuHeadCell : UITableViewCell
//今日互动次数
@property (weak, nonatomic) IBOutlet UIButton *toDayButtom;
//累计授权用户
@property (weak, nonatomic) IBOutlet UIButton *allButtom;

@property (nonatomic,assign) id<kehuHeadCellDelegate> delegate;

- (IBAction)today:(id)sender;

- (IBAction)all:(id)sender;

- (IBAction)clickTodayButtom:(id)sender;

- (IBAction)clickAllButtom:(id)sender;


@end
