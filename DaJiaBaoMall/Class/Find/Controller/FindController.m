//
//  FindController.m
//  DaJiaBaoMall
//
//  Created by 大家保 on 2017/3/27.
//  Copyright © 2017年 大家保. All rights reserved.
//

#import "FindController.h"
#import "GetCustomController.h"
#import "ClassRoomController.h"

@interface FindController ()

@end

@implementation FindController

//初始化
- (instancetype)init{
    if (self=[super init]) {
        self = [[FindController alloc] initWithViewControllerClasses:[self ViewControllerClasses] andTheirTitles:@[@"展业获客神器",@"产品课堂"]];
        self.menuViewStyle=WMMenuViewStyleLine;
        self.menuBGColor=[UIColor clearColor];
        self.menuHeight=GetHeight(44);
        self.progressHeight=GetHeight(4);
        self.titleSizeNormal=GetWidth(16);
        self.titleSizeSelected=GetWidth(16);
        self.progressViewCornerRadius=GetHeight(0);
        self.progressViewIsNaughty=YES;
        self.titleColorSelected=[UIColor colorWithHexString:@"#ff693a"];
        self.titleColorNormal=[UIColor colorWithHexString:@"#282828"];
        self.itemsWidths=@[@(SCREEN_WIDTH/2.0),@(SCREEN_WIDTH/2.0)];
        //self.automaticallyCalculatesItemWidths=YES;
        self.progressViewWidths=@[@(GetWidth(100)),@(GetWidth(100))];
        self.viewFrame=CGRectMake(0,20, SCREEN_WIDTH, SCREEN_HEIGHT-20-49);
    }
    return self;
};

// 存响应的控制器
- (NSArray *)ViewControllerClasses {
    return @[[GetCustomController class],[ClassRoomController class]];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self addTitle:@""];
}

//添加标题
- (void)addTitle:(NSString *)title{
    UILabel * titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(60, 20, SCREEN_WIDTH-120, 43.5)];
    titleLabel.textColor=color3c3a40;
    titleLabel.font=SystemFont(18);
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textAlignment=NSTextAlignmentCenter;
    titleLabel.text=title;
    [self.view addSubview:titleLabel];
    
    UIView *Bottonline=[[UIView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 0.5)];
    Bottonline.backgroundColor=[UIColor colorWithHexString:@"#dcdcdc"];
    [self.view addSubview:Bottonline];
};


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
