//
//  LSPaoMaView.h
//  LSDevelopmentModel
//
//  Created by  tsou117 on 15/7/29.
//  Copyright (c) 2015年  tsou117. All rights reserved.
//

#import <UIKit/UIKit.h>

#define TEXTCOLOR [UIColor colorWithHexString:@"ffdace"]

@interface LSPaoMaView : UIView

//显示的文字
@property (nonatomic,copy) NSString *showTitle;
//停止跑马
- (void)stop;

@end
