//
//  SetController.m
//  DaJiaBaoMall
//
//  Created by 大家保 on 2017/3/31.
//  Copyright © 2017年 大家保. All rights reserved.
//

#import "SetController.h"
#import "UMessage.h"
#import "LoginController.h"
#import "BaseNavigationController.h"
#import <RongIMKit/RongIMKit.h>
#import "MeModel.h"

@interface SetController (){
   UIButton *clearCachButton;
}

@end

@implementation SetController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self  addTitle:@"设置"];
    [self addLeftButton];
    [self initUI];
    [self getAllCache];
}

//初始化布局
- (void)initUI{
    UIView *headView=[[UIView alloc]init];
    headView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:headView];
    [headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(79);
        make.height.mas_equalTo(100);
    }];
    
    
    clearCachButton=[[UIButton alloc]init];
    [clearCachButton addTarget:self action:@selector(clearCache:) forControlEvents:UIControlEventTouchUpInside];
    [clearCachButton setTitle:@"正在计算..." forState:0];
    [clearCachButton.titleLabel setFont:font15];
    [clearCachButton setTitleColor:[UIColor colorWithHexString:@"#595959"] forState:0];
    [clearCachButton setTitleColor:[UIColor colorWithHexString:@"#595959"] forState:UIControlStateDisabled];
    clearCachButton.enabled=NO;
    [clearCachButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    clearCachButton.contentEdgeInsets=UIEdgeInsetsMake(0, 0, 0, GetWidth(37));
    [clearCachButton setBackgroundColor:[UIColor whiteColor]];
    [headView addSubview:clearCachButton];
    [clearCachButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(GetHeight(49.5));
    }];
    
    UILabel *clearLabel=[[UILabel alloc]init];
    clearLabel.text=@"清除缓存";
    clearLabel.textColor=[UIColor colorWithHexString:@"#282828"];
    clearLabel.font=font15;
    [clearCachButton addSubview:clearLabel];
    [clearLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(clearCachButton.mas_left).offset(GetWidth(15));
        make.top.mas_equalTo(clearCachButton);
        make.height.mas_equalTo(clearCachButton);
    }];
    
    UIImageView *rightArr=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"forward"]];
    [clearCachButton addSubview:rightArr];
    [rightArr mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(clearCachButton.mas_right).offset(-GetWidth(15));
        make.centerY.mas_equalTo(0);
        make.height.mas_equalTo(12);
        make.width.mas_equalTo(7);
    }];
    
    UILabel *line=[[UILabel alloc]init];
    line.backgroundColor=[UIColor colorWithHexString:@"#dcdcdc"];
    [headView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(clearCachButton.mas_bottom).offset(0);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(0.5);
    }];
    
    UIButton *pingjia=[[UIButton alloc]init];
    [pingjia addTarget:self action:@selector(gotoAppStore:) forControlEvents:UIControlEventTouchUpInside];
    [pingjia setTitle:@"给我们评分" forState:0];
    [pingjia.titleLabel setFont:font15];
    [pingjia setTitleColor:[UIColor colorWithHexString:@"#282828"] forState:0];
    [pingjia setTitleColor:[UIColor colorWithHexString:@"#282828"] forState:UIControlStateDisabled];
    [pingjia setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    pingjia.contentEdgeInsets=UIEdgeInsetsMake(0, 15, 0, 0);
    [pingjia setBackgroundColor:[UIColor whiteColor]];
    [headView addSubview:pingjia];
    [pingjia mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(line.mas_bottom);
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
    
    
    UIImageView *rightArr2=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"forward"]];
    [pingjia addSubview:rightArr2];
    [rightArr2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(pingjia.mas_right).offset(-GetWidth(15));
        make.centerY.mas_equalTo(0);
        make.height.mas_equalTo(12);
        make.width.mas_equalTo(7);
    }];

    
    
    UIButton *exiteButtom=[UIButton buttonWithTitle:@"退出登录" titleColor:[UIColor colorWithHexString:@"#282828"] font:font16 target:self action:@selector(exit:)];
    [exiteButtom setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:exiteButtom];
    [exiteButtom mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(headView.mas_bottom).offset(15);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(50);
    }];
}

//获取所有缓存
- (void)getAllCache{
    [XWNetworkCache getAllHttpCacheSizeWithBlock:^(NSInteger totalCost) {
        NSUInteger sdCacheSize=[[SDImageCache sharedImageCache] getSize];
        NSString   *allCache=[self fileSizeWithInterge:(totalCost+sdCacheSize)];
        [clearCachButton setTitle:allCache forState:0];
        clearCachButton.enabled=YES;
    }];
}

//计算出大小
- (NSString *)fileSizeWithInterge:(NSInteger)size{
    // 1k = 1024, 1m = 1024k
    if (size < 1024) {// 小于1k
        return [NSString stringWithFormat:@"%.2fB",(float)size];
    }else if (size < 1024 * 1024){// 小于1m
        CGFloat aFloat = size/1024.0;
        return [NSString stringWithFormat:@"%.2fK",aFloat];
    }else if (size < 1024 * 1024 * 1024){// 小于1G
        CGFloat aFloat = size/(1024.0 * 1024.0);
        return [NSString stringWithFormat:@"%.2fM",aFloat];
    }else{
        CGFloat aFloat = size/(1024.0*1024.0*1024.0);
        return [NSString stringWithFormat:@"%.2fG",aFloat];
    }
}

//清除缓存
- (void)clearCache:(UIButton *)sender{
    UIAlertController *clearAlert=[UIAlertController alertControllerWithTitle:@"确定清除本地缓存？" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *queding=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD showHUDWithTitle:@"正在清理..."];
        });
        [XWNetworkCache removeAllHttpCacheWithBlock:^{
            [[SDImageCache sharedImageCache] clearMemory];
            [[SDImageCache sharedImageCache] clearDiskOnCompletion:^{
                [self getAllCache];
                [MBProgressHUD showSuccess:@"清理完毕"];
            }];
        }];
    }];
    [clearAlert addAction:cancel];
    [clearAlert addAction:queding];
    [self presentViewController:clearAlert animated:YES completion:nil];
}


//给我们评分
- (void)gotoAppStore:(UIButton *)sender{
    NSString *updateUrl = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewSoftware?id=%d",1140892295];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:updateUrl]];
}

//退出登录
- (void)exit:(UIButton *)sender{
    UIAlertController *exitAlert=[UIAlertController alertControllerWithTitle:@"确定退出登录？" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *queding=[UIAlertAction actionWithTitle:@"退出" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        MeModel *me=[self getMeModelMessage];
        [UMessage removeAlias:me.mobilephone type:@"com.dajiabao.qqb" response:nil];
        [[RCIM sharedRCIM] logout];
        [UserDefaults setObject:nil forKey:TOKENID];
        [self saveMeModelMessage:nil];
        KeyWindow.rootViewController=[[BaseNavigationController alloc]initWithRootViewController:[[LoginController alloc]init]];
    }];
    [exitAlert addAction:cancel];
    [exitAlert addAction:queding];
    [self presentViewController:exitAlert animated:YES completion:nil];
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
    [MobClick beginLogPageView:@"设置"];
}
/**
 *  友盟统计页面关闭时间
 *
 */
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"设置"];
}




@end
