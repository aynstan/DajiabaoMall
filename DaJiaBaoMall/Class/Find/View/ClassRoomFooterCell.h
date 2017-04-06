//
//  ClassRoomFooterCell.h
//  DaJiaBaoMall
//
//  Created by 大家保 on 2017/3/30.
//  Copyright © 2017年 大家保. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ClassRoomFooterCell;
@class ClassContentModel;

@protocol ClassRoomFooterCell_Delegate <NSObject>

- (void)clickCell:(ClassRoomFooterCell *)cell onTheCollectionViewIndex:(NSInteger )index;

@end

@interface ClassRoomFooterCell : UITableViewCell

@property (nonatomic,assign) id<ClassRoomFooterCell_Delegate> delegate;

@property (nonatomic,strong) NSMutableArray<ClassContentModel *> *modelArray;

@end
