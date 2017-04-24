//
//  TuiguangCell.h
//  DaJiaBaoMall
//
//  Created by 大家保 on 2017/3/31.
//  Copyright © 2017年 大家保. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TuiguangModel;

@interface TuiguangCell : UITableViewCell
//推广人
@property (weak, nonatomic) IBOutlet UILabel *tuiguangName;
//开始时间
@property (weak, nonatomic) IBOutlet UILabel *beginTime;
//推广费
@property (weak, nonatomic) IBOutlet UILabel *tuiguangMoney;
//保费
@property (weak, nonatomic) IBOutlet UILabel *baofei;
//产品名称
@property (weak, nonatomic) IBOutlet UILabel *productName;
//model
@property (nonatomic,strong) TuiguangModel *model;

@end
