//
//  MyMessageControllerViewController.m
//  DaJiaBaoMall
//
//  Created by 大家保 on 2017/3/31.
//  Copyright © 2017年 大家保. All rights reserved.
//

#import "MyMessageControllerViewController.h"
#import "MyMessageCell.h"
#import "CameraAndPhotoPicker.h"
#import "EditController.h"
#import "CheckPhoneController.h"
#import "ShimingRenzhengController.h"

@interface MyMessageControllerViewController ()<UITableViewDelegate,UITableViewDataSource>{
    UIImageView *touxiangImageView;
}

@property (nonatomic,strong)UITableView *myTableView;

@property (nonatomic,strong)NSMutableArray *dataSourceArray;

@property (nonatomic, strong) CameraAndPhotoPicker *picker;

@end

static NSString *const tableviewCellIndentifer=@"Cell";

@implementation MyMessageControllerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addTitle:@"名片信息"];
    [self addLeftButton];
    [self addRightButton:@"保存"];
    [self.myTableView setHidden:NO];
}

//保存事件
- (void)forward:(UIButton *)button{
}

#pragma mark uitableview delegate;
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *arr=self.dataSourceArray[indexPath.section];
    MyMessageCell *cell=[tableView dequeueReusableCellWithIdentifier:tableviewCellIndentifer];
    cell.titleStr.text=arr[indexPath.row];
    if ([cell.titleStr.text isEqualToString:@"实名认证"]) {
        cell.jiaV.hidden=NO;
    }else{
        cell.jiaV.hidden=YES;
    }
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section==0) {
        
        UIView *whiteView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 90)];
        whiteView.backgroundColor=[UIColor clearColor];
        
        UIButton *touxiang=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 80)];
        [touxiang setTitle:@"头像" forState:0];
        [touxiang addTarget:self action:@selector(changeTouxiang:) forControlEvents:UIControlEventTouchUpInside];
        [touxiang.titleLabel setFont:font16];
        [touxiang setTitleColor:[UIColor blackColor] forState:0];
        [touxiang setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [touxiang setContentEdgeInsets:UIEdgeInsetsMake(0, 12, 0, 0)];
        [touxiang setBackgroundColor:[UIColor whiteColor]];
        [whiteView addSubview:touxiang];
        
        UIImageView *imageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"forward"]];
        [touxiang addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(0);
            make.right.mas_equalTo(-12);
            make.size.mas_equalTo(CGSizeMake(20, 20));
        }];
        
        touxiangImageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"会员头像"]];
        touxiangImageView.tag=1000;
        [touxiang addSubview:touxiangImageView];
        [touxiangImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(0);
            make.right.mas_equalTo(imageView.mas_left).offset(-12);
            make.size.mas_equalTo(CGSizeMake(60, 60));
        }];
        
        return whiteView;
        
    }else if(section==1){
        return [UIView new];
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return 90;
    }else if(section==1){
        return 10;
    }
    return 0;
}


- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section==0) {
        return [UIView new];
    }else if(section==1){
        UIView *bgView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 110)];
        bgView.backgroundColor=[UIColor clearColor];
        
        UIView *whiteView=[[UIView alloc]initWithFrame:CGRectMake(0, 10, SCREEN_WIDTH, 100)];
        whiteView.backgroundColor=[UIColor whiteColor];
        [bgView addSubview:whiteView];
        
        UIButton *addButtom=[UIButton buttonWithTitle:@"+" titleColor:[UIColor clearColor] font:[UIFont systemFontOfSize:100] target:self action:@selector(addErWeiMa)];
        [addButtom setBackgroundColor:[UIColor lightGrayColor]];
        [addButtom setTitleColor:[UIColor darkGrayColor] forState:0];
        [whiteView addSubview:addButtom];
        [addButtom mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(0);
            make.left.mas_equalTo(12);
            make.size.mas_equalTo(CGSizeMake(76, 76));
        }];
        
        UILabel *label=[[UILabel alloc]init];
        label.textColor=[UIColor darkGrayColor];
        label.font=font14;
        label.text=@"个人微信二维码（将显示在名片中）";
        [whiteView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(addButtom);
            make.left.mas_equalTo(addButtom.mas_right).offset(12);
        }];
        
        UIButton *jieshao=[UIButton buttonWithTitle:@"如何获取二维码？" titleColor:[UIColor lightGrayColor] font:[UIFont systemFontOfSize:13] target:self action:@selector(jishao)];
        [whiteView addSubview:jieshao];
        [jieshao mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(label.mas_bottom).offset(0);
            make.left.mas_equalTo(addButtom.mas_right).offset(12);
            make.height.mas_equalTo(35);
        }];
        
        return bgView;
    }
    return 0;
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section==0) {
        return 0.001;
    }else if(section==1){
        return 110;
    }
    return 0;
}


- (CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataSourceArray.count;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *arr=self.dataSourceArray[section];
    return arr.count;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section==0) {
        if (indexPath.row==0) {
            EditController *edit=[[EditController alloc]init];
            edit.hidesBottomBarWhenPushed=YES;
            edit.titleStr=@"名片昵称";
            edit.placeHorderStr=@"请设置名片昵称";
            edit.subTitleStr=@"该昵称将显示在您的个人名片等展业宣传信息中";
            edit.BackBlock=^(NSString *backStr){
                MyMessageCell *cell=[self.myTableView cellForRowAtIndexPath:indexPath];
                cell.subTitle.text=backStr;
            };
            [self.navigationController pushViewController:edit animated:YES];
        }else if (indexPath.row==1){
            //手机号
            [self changePhone:indexPath];
        }else if (indexPath.row==2){
            //性别
            [self changeSex:indexPath];
        }else if(indexPath.row==3){
            //实名认证
            [self shimingrenzheng:indexPath];
        }
     }else if (indexPath.section==1){
        if (indexPath.row==0) {
            EditController *edit=[[EditController alloc]init];
            edit.hidesBottomBarWhenPushed=YES;
            edit.titleStr=@"公司";
            edit.placeHorderStr=@"请输入您所在公司的名称";
            edit.subTitleStr=@"";
            edit.BackBlock=^(NSString *backStr){
                MyMessageCell *cell=[self.myTableView cellForRowAtIndexPath:indexPath];
                cell.subTitle.text=backStr;
            };
            [self.navigationController pushViewController:edit animated:YES];
        }else if(indexPath.row==1){
            EditController *edit=[[EditController alloc]init];
            edit.hidesBottomBarWhenPushed=YES;
            edit.titleStr=@"职务";
            edit.placeHorderStr=@"请输入您的职务";
            edit.subTitleStr=@"";
            edit.BackBlock=^(NSString *backStr){
                MyMessageCell *cell=[self.myTableView cellForRowAtIndexPath:indexPath];
                cell.subTitle.text=backStr;
            };
            [self.navigationController pushViewController:edit animated:YES];
        }
    }
}

//更改性别
- (void)changeSex:(NSIndexPath *)indexPath{
    UIAlertController *alertController=[UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cancelAction=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *man=[UIAlertAction actionWithTitle:@"男" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        MyMessageCell *cell=[self.myTableView cellForRowAtIndexPath:indexPath];
        cell.subTitle.text=@"男";
    }];
    UIAlertAction *woman=[UIAlertAction actionWithTitle:@"女" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        MyMessageCell *cell=[self.myTableView cellForRowAtIndexPath:indexPath];
        cell.subTitle.text=@"女";
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:man];
    [alertController addAction:woman];
    [self presentViewController:alertController animated:YES completion:nil];
}

//修改手机号
- (void)changePhone:(NSIndexPath *)indexPath{
    CheckPhoneController *phone=[[CheckPhoneController alloc]init];
    phone.hidesBottomBarWhenPushed=YES;
    phone.BackBlock=^(NSString *backStr){
        MyMessageCell *cell=[self.myTableView cellForRowAtIndexPath:indexPath];
        cell.subTitle.text=backStr;
    };
    [self.navigationController pushViewController:phone animated:YES];
}

//实名认证
- (void)shimingrenzheng:(NSIndexPath *)indexPath{
    ShimingRenzhengController *shiming=[[ShimingRenzhengController alloc]init];
    shiming.hidesBottomBarWhenPushed=YES;
    shiming.BackBlock=^(NSString *backStr){
        MyMessageCell *cell=[self.myTableView cellForRowAtIndexPath:indexPath];
        cell.subTitle.text=backStr;
    };
    [self.navigationController pushViewController:shiming animated:YES];
}

//修改名片
- (void)addErWeiMa{
    
}

//如何使用微信二维码
- (void)jishao{
    
}

//更换头像
- (void)changeTouxiang:(UIButton *)sender{
    UIAlertController *alertController=[UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cancelAction=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *camera=[UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.picker getPhotoWithCamera:^(UIImage *selectedImage) {
            [self saveTouxiang:selectedImage];
        } editing:YES faild:^{
            [self alertWithMessage:@"请在iphone的“设置-隐私-相机”选项中，允许圈圈使用您的相机"];
        } showIn:self];
    }];
    UIAlertAction *photo=[UIAlertAction actionWithTitle:@"从相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.picker getPhotoWithPhotoLib:^(UIImage *selecteImage) {
            [self saveTouxiang:selecteImage];
        } editing:YES faild:^{
            [self alertWithMessage:@"请在iphone的“设置-隐私-照片”选项中，允许圈圈访问您的手机相册"];
        } showIn:self];
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:camera];
    [alertController addAction:photo];
    [self presentViewController:alertController animated:YES completion:nil];
}

//保存头像数据
- (void)saveTouxiang:(UIImage *)touxiangImage{
    touxiangImageView.image=touxiangImage;
}

//权限提醒
- (void)alertWithMessage:(NSString *)toastMessage{
    UIAlertController *phoneAlert=[UIAlertController alertControllerWithTitle:@"提醒" message:toastMessage preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel=[UIAlertAction actionWithTitle:@"我知道了" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [phoneAlert addAction:cancel];
    [self presentViewController:phoneAlert animated:YES completion:nil];
}


#pragma mark 懒加载
- (UITableView *)myTableView{
    if (!_myTableView) {
        _myTableView=[[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _myTableView.backgroundColor=[UIColor clearColor];
        _myTableView.delegate=self;
        _myTableView.dataSource=self;
        _myTableView.tableFooterView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.0001)];
        _myTableView.tableHeaderView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
        _myTableView.separatorInset=UIEdgeInsetsMake(0, 0, 0, 0);
        _myTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
        
        [_myTableView registerNib:[UINib nibWithNibName:NSStringFromClass([MyMessageCell class]) bundle:nil] forCellReuseIdentifier:tableviewCellIndentifer];
        [self.view addSubview:_myTableView];
        
        _myTableView.sd_layout.leftSpaceToView(self.view,0).topSpaceToView(self.view,64).rightSpaceToView(self.view,0).bottomSpaceToView(self.view,0);

    }
    return _myTableView;
}

- (CameraAndPhotoPicker *)picker{
    if (!_picker) {
        _picker=[[CameraAndPhotoPicker alloc]init];
        _picker.saveToLocal=YES;
    }
    return _picker;
}




- (NSMutableArray *)dataSourceArray{
    if (!_dataSourceArray) {
        _dataSourceArray=[[NSMutableArray alloc]initWithObjects:@[@"名片昵称",@"手机号",@"性别",@"实名认证"],@[@"公司",@"职务"], nil];
    }
    return _dataSourceArray;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



@end
