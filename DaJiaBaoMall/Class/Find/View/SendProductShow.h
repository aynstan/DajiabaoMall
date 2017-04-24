//
//  SendProductShow.h
//  DaJiaBaoMall
//
//  Created by 大家保 on 2017/4/13.
//  Copyright © 2017年 大家保. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^CloseBlock) ();

@interface SendProductShow : UIView

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

- (IBAction)close:(id)sender;

- (IBAction)gotoLook:(id)sender;


@property (weak, nonatomic) IBOutlet UITextView *mytextView;

@property (nonatomic,copy)CloseBlock closeBlock;

@end
