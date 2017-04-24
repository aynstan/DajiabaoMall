//
//  LoginViewController.h
//  chenzi
//
//  Created by 大家保 on 16/5/2.
//  Copyright © 2016年 大家保. All rights reserved.
//

#import "UserGuideViewController.h"
#import "YLImageView.h"
#import "YLGIFImage.h"
#import "LoginController.h"
#import "BaseNavigationController.h"

@interface UserGuideViewController ()<UIScrollViewDelegate>{
    UIScrollView *scrollView;
    NSArray *arr;
    UIButton *goButton;
}


@end

@implementation UserGuideViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    //设置setupScrollView
    [self setupScrollView];
    //设置setupPageControl
    [self setupPageControl];
}

// 设置uiScrollView
- (void)setupScrollView{
    if (SCREEN_HEIGHT==480) {
        arr=@[@"01_small.gif",@"02_small.gif",@"03_small.gif"];
    }else{
        arr=@[@"01.gif",@"02.gif",@"03.gif"];
    }
    scrollView = [[UIScrollView alloc]initWithFrame:self.view.frame];
    scrollView.delegate =self;
    //关闭水平方向上的滚动条
    scrollView.showsHorizontalScrollIndicator =NO;
    scrollView.bounces=NO;
    //是否可以整屏滑动
    scrollView.pagingEnabled =YES;
    scrollView.tag =200;
    scrollView.contentSize =CGSizeMake([[UIScreen mainScreen] bounds].size.width *arr.count, [UIScreen mainScreen].bounds.size.height);
    [self.view addSubview:scrollView];
    for (int i = 0; i < arr.count; i++) {
        YLImageView* imageView = [[YLImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH* i,0,SCREEN_WIDTH, SCREEN_HEIGHT)];
        [scrollView addSubview:imageView];
        imageView.image = [YLGIFImage imageNamed:arr[i]];
    }
}

//进入主页按钮
-(void)addButton{
    if (SCREEN_HEIGHT==480) {
        goButton=[[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH * 2+(SCREEN_WIDTH/2.0-168/2.0),SCREEN_HEIGHT-80 ,168, 40)];
    }else{
        goButton=[[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH * 2+(SCREEN_WIDTH/2.0-168/2.0),SCREEN_HEIGHT-90 ,168, 40)];
    }
    [goButton addTarget:self action:@selector(goMain) forControlEvents:UIControlEventTouchUpInside];
    [goButton setBackgroundImage:[UIImage imageNamed:@"立即体验"] forState:0];
    [goButton setBackgroundImage:[UIImage imageNamed:@"立即体验"] forState:UIControlStateHighlighted];
    [UIView animateWithDuration:1 animations:^{
        goButton.alpha=1;
    }];
    [scrollView addSubview:goButton];
}

// 设置uiPageControl
- (void)setupPageControl{
    // UIPageControl1.表示页数2.表示当前正处于第几页3.点击切换页数
    UIPageControl *pageControl;
    if (SCREEN_HEIGHT==480) {
         pageControl= [[UIPageControl alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-300)/2.0, SCREEN_HEIGHT-GetHeight(15)-20, 300, 20)];
    }else{
         pageControl= [[UIPageControl alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-300)/2.0, SCREEN_HEIGHT-GetHeight(15)-20, 300, 20)];
    }
    pageControl.tag =100;
    //设置表示的页数
    pageControl.numberOfPages =3;
    //设置选中的页数
    pageControl.currentPage =0;
    //设置未选中点的颜色
    pageControl.pageIndicatorTintColor = [[UIColor blackColor] colorWithAlphaComponent:0.1];
    //设置选中点的颜色
    pageControl.currentPageIndicatorTintColor = [[UIColor whiteColor] colorWithAlphaComponent:0.8];
    //启用触摸响应
    [pageControl addTarget:self action:@selector(handlePageControl:)forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:pageControl];
}
//scrollView代理
-(void)scrollViewDidScroll:(UIScrollView *)scrollview{
    UIPageControl *pagControl = (UIPageControl *)[self.view viewWithTag:100];
    pagControl.currentPage = scrollview.contentOffset.x / SCREEN_WIDTH ;
    if (scrollView.contentOffset.x>=SCREEN_WIDTH*2) {
        [self addButton];
    }
}
//uiPageControl代理
- (void)handlePageControl:(UIPageControl *)pageControl{
    //切换pageControl .对应切换scrollView不同的界面
    UIScrollView *scrollview = (UIScrollView *)[self.view viewWithTag:200];
    [scrollview setContentOffset:CGPointMake(SCREEN_WIDTH * pageControl.currentPage,0) animated:YES];
}

//切换到主页
- (void)goMain{
    [UserDefaults setBool:YES forKey:@"firstLanch"];
    [UserDefaults synchronize];
    
    LoginController *login=[[LoginController alloc]init];
    BaseNavigationController *nav=[[BaseNavigationController alloc]initWithRootViewController:login];
    KeyWindow.rootViewController=nav;
}

/**
 *  友盟统计页面打开开始时间
 *
 */
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"引导页"];
}
/**
 *  友盟统计页面关闭时间
 *
 */
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"引导页"];
}


- (BOOL)prefersStatusBarHidden{
    return YES;
}


@end
