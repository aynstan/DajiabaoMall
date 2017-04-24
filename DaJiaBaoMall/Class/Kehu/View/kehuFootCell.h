//
//  kehuFootCell.h
//  DaJiaBaoMall
//
//  Created by 大家保 on 2017/3/28.
//  Copyright © 2017年 大家保. All rights reserved.
//

#import <UIKit/UIKit.h>

@class kehuFootCell;

@protocol kehuFootCellDelegate <NSObject>

- (void)clickInHeadCell:(kehuFootCell *)cell withLoadPayButtom:(UIButton *)btn;

- (void)clickInHeadCell:(kehuFootCell *)cell withCompletePayButtom:(UIButton *)btn;

@end



@interface kehuFootCell : UITableViewCell
//未支付
@property (weak, nonatomic) IBOutlet UIButton *noPayButtom;
//已支付
@property (weak, nonatomic) IBOutlet UIButton *alReadyButton;

@property (nonatomic,assign) id<kehuFootCellDelegate> delegate;

@end
