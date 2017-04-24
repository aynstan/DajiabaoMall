//
//  SendProductController.m
//  DaJiaBaoMall
//
//  Created by 大家保 on 2017/4/1.
//  Copyright © 2017年 大家保. All rights reserved.
//

#import "SendProductController.h"
#import "SendUsedController.h"
#import "SendUnUsedController.h"
#import "SendProductShow.h"

@interface SendProductController ()

@property (nonatomic,strong) JCAlertView *alertView;

@end

@implementation SendProductController

//初始化
- (instancetype)init{
    if (self=[super init]) {
        self = [[SendProductController alloc] initWithViewControllerClasses:[self ViewControllerClasses] andTheirTitles:@[@"未使用",@"已使用"]];
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
        self.progressViewWidths=@[@(GetWidth(70)),@(GetWidth(70))];
        self.viewFrame=CGRectMake(0,64, SCREEN_WIDTH, SCREEN_HEIGHT-64);
    }
    return self;
};

// 存响应的控制器
- (NSArray *)ViewControllerClasses {
    return @[[SendUsedController class],[SendUnUsedController class]];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self addTitle:@"赠客产品"];
    [self addLeftButton];
    [self addRightButtonWithImageName:@"question"];
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
    
    UIView *Bottonline=[[UIView alloc]initWithFrame:CGRectMake(0, 63.5, SCREEN_WIDTH, 0.5)];
    Bottonline.backgroundColor=[UIColor colorWithHexString:@"#dcdcdc"];
    [self.view addSubview:Bottonline];
    
    UIView *Bottonline2=[[UIView alloc]initWithFrame:CGRectMake(0, 64+43.5, SCREEN_WIDTH, 0.5)];
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

- (void)addRightButtonWithImageName:(NSString *)imageName{
    UIButton *RightButton=[[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-45, 20, 45, 44)];
    RightButton.tag=10000;
    [RightButton setImage:[UIImage imageNamed:imageName] forState:0];
    [RightButton addTarget:self action:@selector(forward:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:RightButton];
}

//说明
- (void)forward:(UIButton *)sender{
    WeakSelf;
    SendProductShow *showView=[[[NSBundle mainBundle]loadNibNamed:@"SendProductShow" owner:nil options:nil]lastObject];;
    showView.frame=CGRectMake(0, 0, 280, 280*820/620.0);
    showView.imageView.image=[UIImage imageNamed:@"弹窗bg"];
    showView.mytextView.text=@"如何获得赠险？\n新人注册成功后，即可获得价值300元的赠险。\n\n如何使用已经获得的赠险？\n可自用也可以赠送客户，通过微信分享产品给客户，同一款产品可分享给多人，但仅有一个投保名额，投保成功即表示产品已使用。使用过的产品不再支持赠送或投保。\n\n产品是否有期限？\n产品的有效期为7天，自获得日开始计时，过期将自动作废，请在有效期内使用。\n\n如何查询客户的投保信息？\n您可在赠品>已使用页面查看客户投保信息详情。";
    showView.closeBlock=^(){
        [weakSelf.alertView dismissWithCompletion:nil];
    };
    self.alertView=[[JCAlertView alloc]initWithCustomView:showView dismissWhenTouchedBackground:NO];
    [self.alertView show];
}

//返回
- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

/**
 *  友盟统计页面打开开始时间
 *
 */
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"赠客产品_未使用"];
}
/**
 *  友盟统计页面关闭时间
 *
 */
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"赠客产品_未使用"];
}



@end
