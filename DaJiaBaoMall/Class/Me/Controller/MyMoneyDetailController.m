//
//  MyMoneyDetailController.m
//  DaJiaBaoMall
//
//  Created by 大家保 on 2017/3/31.
//  Copyright © 2017年 大家保. All rights reserved.
//

#import "MyMoneyDetailController.h"
#import "TuiguangController.h"
#import "TixianController.h"


@interface MyMoneyDetailController ()



@end

@implementation MyMoneyDetailController

//初始化
- (instancetype)init{
    if (self=[super init]) {
        self = [[MyMoneyDetailController alloc] initWithViewControllerClasses:[self ViewControllerClasses] andTheirTitles:@[@"推广收入",@"提现支出"]];
        self.menuViewStyle=WMMenuViewStyleLine;
        self.menuBGColor=[UIColor clearColor];
        self.menuHeight=GetHeight(44);
        self.progressHeight=GetHeight(4);
        self.titleSizeNormal=GetWidth(16);
        self.titleSizeSelected=GetWidth(16);
        self.progressViewCornerRadius=GetHeight(0);
        self.progressViewIsNaughty=YES;
        self.titleColorSelected=[UIColor colorWithHexString:@"#282828"];
        self.titleColorNormal=[UIColor colorWithHexString:@"#282828"];
        self.itemsWidths=@[@(SCREEN_WIDTH/2.0),@(SCREEN_WIDTH/2.0)];
        self.progressColor=[UIColor colorWithHexString:@"#ff693a"];
        self.progressViewWidths=@[@(GetWidth(73)),@(GetWidth(73))];
        self.viewFrame=CGRectMake(0,64, SCREEN_WIDTH, SCREEN_HEIGHT-64);
    }
    return self;
};

// 存响应的控制器
- (NSArray *)ViewControllerClasses {
    return @[[TuiguangController class],[TixianController class]];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self addTitle:@"钱包明细"];
    [self addLeftButton];
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
    
    UIView *Bottonline2=[[UIView alloc]initWithFrame:CGRectMake(0, 43.5+64, SCREEN_WIDTH, 0.5)];
    Bottonline2.backgroundColor=[UIColor colorWithHexString:@"#dcdcdc"];
    [self.view addSubview:Bottonline2];
};

//返回按钮
- (void)addLeftButton{
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    UIButton *leftButton=[[UIButton alloc]initWithFrame:CGRectMake(0, 20, 44, 44)];
    [leftButton setImage:[UIImage imageNamed:@"return-arr"] forState:0];
    [leftButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:leftButton];
};

//返回
- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}




@end
