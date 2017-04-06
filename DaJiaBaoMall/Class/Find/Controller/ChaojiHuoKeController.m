//
//  ChaojiHuoKeController.m
//  DaJiaBaoMall
//
//  Created by 大家保 on 2017/4/1.
//  Copyright © 2017年 大家保. All rights reserved.
//

#import "ChaojiHuoKeController.h"
#import "GetPeopleController.h"
#import "GetGroupController.h"

@interface ChaojiHuoKeController ()

@end

@implementation ChaojiHuoKeController

//初始化
- (instancetype)init{
    if (self=[super init]) {
        self = [[ChaojiHuoKeController alloc] initWithViewControllerClasses:[self ViewControllerClasses] andTheirTitles:@[@"加粉",@"加群"]];
        self.menuViewStyle=WMMenuViewStyleLine;
        self.menuBGColor=[UIColor clearColor];
        self.menuHeight=GetHeight(44);
        self.progressHeight=GetHeight(4);
        self.titleSizeNormal=GetWidth(16);
        self.titleSizeSelected=GetWidth(18);
        self.progressViewCornerRadius=GetHeight(2);
        self.progressViewIsNaughty=YES;
        self.titleColorSelected=color0196FF;
        self.itemsWidths=@[@(SCREEN_WIDTH/2.0),@(SCREEN_WIDTH/2.0)];
        //self.automaticallyCalculatesItemWidths=YES;
        self.progressViewWidths=@[@(GetWidth(30)),@(GetWidth(30))];
        self.viewFrame=CGRectMake(0,64, SCREEN_WIDTH, SCREEN_HEIGHT-64);
    }
    return self;
};

// 存响应的控制器
- (NSArray *)ViewControllerClasses {
    return @[[GetPeopleController class],[GetGroupController class]];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self addTitle:@"超级获客"];
    [self addLeftButton];
    [self addRightButtonWithImageName:@"会员头像"];
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
    Bottonline.backgroundColor=colorc3c3c3;
    [self.view addSubview:Bottonline];
};

//返回按钮
- (void)addLeftButton{
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    UIButton *leftButton=[[UIButton alloc]initWithFrame:CGRectMake(0, 20, 44, 44)];
    [leftButton setImage:[UIImage imageNamed:@"return-arr"] forState:0];
    [leftButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:leftButton];
};

- (void)addRightButtonWithImageName:(NSString *)imageName{
    UIButton *RightButton=[[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-45, 20, 45, 44)];
    RightButton.tag=10000;
    [RightButton setImage:[UIImage imageNamed:imageName] forState:0];
    [RightButton addTarget:self action:@selector(forward:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:RightButton];
}

//返回
- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)forward:(UIButton *)sender{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
