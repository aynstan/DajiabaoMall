//
//  GetPeopleCell.h
//  DaJiaBaoMall
//
//  Created by 大家保 on 2017/4/1.
//  Copyright © 2017年 大家保. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XWPersonModel;
@class GetPeopleCell;

@protocol GetPeopleCell_Delegate  <NSObject>

- (void)clickCell:(GetPeopleCell *)cell onButtonIndex:(NSInteger)index;

@end

@interface GetPeopleCell : UITableViewCell
//头视图
@property (weak, nonatomic) IBOutlet UILabel *headImageLabel;
//名字
@property (weak, nonatomic) IBOutlet UILabel *name;
//电话
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
//性别
@property (weak, nonatomic) IBOutlet UILabel *sexLabel;
//选中按钮
@property (weak, nonatomic) IBOutlet UIButton *selectButtom;

@property (nonatomic,assign) NSInteger butoonIndex;

@property (nonatomic,assign) id<GetPeopleCell_Delegate> delegate;

@property (nonatomic,assign) XWPersonModel *model;

@end
