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
#import "BaseWebViewController.h"
#import "MeModel.h"

@interface MyMessageControllerViewController ()<UITableViewDelegate,UITableViewDataSource>{
    UIImageView *touxiangImageView;
    UIButton *addButtom;
}

@property (nonatomic,strong)UITableView *myTableView;

@property (nonatomic,strong)NSMutableArray *dataSourceArray;

@property (nonatomic, strong) CameraAndPhotoPicker *picker;

@property (nonatomic, strong) MeModel *meModel;

@end

static NSString *const tableviewCellIndentifer=@"Cell";

@implementation MyMessageControllerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addTitle:@"名片信息"];
    [self addLeftButton];
    [self.myTableView.mj_header beginRefreshing];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.meModel=[self getMeModelMessage];
    [self.myTableView reloadData];
}


#pragma mark uitableview delegate;
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *arr=self.dataSourceArray[indexPath.section];
    MyMessageCell *cell=[tableView dequeueReusableCellWithIdentifier:tableviewCellIndentifer];
    cell.titleStr.text=arr[indexPath.row];
    if (indexPath.section==0) {
        if (indexPath.row==0) {
            cell.subTitle.text=(0==self.meModel.name.length?@"":self.meModel.name);
        }else if (indexPath.row==1) {
            cell.subTitle.text=(0==self.meModel.mobilephone.length?@"":self.meModel.mobilephone);
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            cell.widthContens.constant=0;
            cell.rightContents.constant=0;
        }else if (indexPath.row==2) {
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            cell.widthContens.constant=0;
            cell.rightContents.constant=0;
            if (self.meModel.isauth) {
                cell.subTitle.text=([self.meModel.sex isEqualToString:@"M"]?@"男":@"女");
            }else{
                cell.subTitle.text=@"保密";
            };
        }else if (indexPath.row==3) {
            cell.jiaV.highlighted=(self.meModel.isauth?YES:NO);
            cell.jiaV.hidden=NO;
            cell.subTitle.text=self.meModel.isauth==false?@"未认证":@"已认证";
            cell.widthContens.constant=(self.meModel.isauth==false?7:0);
            cell.heightContents.constant=(self.meModel.isauth==false?12:0);
            cell.rightContents.constant=(self.meModel.isauth==false?15:0);
            if (self.meModel.isauth) {
               cell.selectionStyle=UITableViewCellSelectionStyleNone;
            }else{
               cell.selectionStyle=UITableViewCellSelectionStyleDefault;
            }
        }
        cell.line.hidden=indexPath.row==3;
    }else if (indexPath.section==1){
        if (indexPath.row==0) {
            cell.subTitle.text=(0==self.meModel.company.length?@"":self.meModel.company);
        }else if (indexPath.row==1){
            cell.subTitle.text=(0==self.meModel.position.length?@"":self.meModel.position);
        }
        cell.line.hidden=indexPath.row==1;
    }
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section==0) {
        
        UIView *whiteView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 100)];
        whiteView.backgroundColor=[UIColor clearColor];
        
        UIButton *touxiang=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 100)];
        [touxiang setTitle:@"头像" forState:0];
        [touxiang addTarget:self action:@selector(changeTouxiang:) forControlEvents:UIControlEventTouchUpInside];
        [touxiang.titleLabel setFont:font16];
        [touxiang setTitleColor:[UIColor colorWithHexString:@"#282828"] forState:0];
        [touxiang setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [touxiang setContentEdgeInsets:UIEdgeInsetsMake(0, 15, 0, 0)];
        [touxiang setBackgroundColor:[UIColor whiteColor]];
        [whiteView addSubview:touxiang];
        
        UIImageView *imageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"forward"]];
        [touxiang addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(0);
            make.right.mas_equalTo(-15);
            make.size.mas_equalTo(CGSizeMake(7, 12));
        }];
        
        touxiangImageView=[[UIImageView alloc]init];
        [touxiangImageView sd_setImageWithURL:[NSURL URLWithString:self.meModel.picture] placeholderImage:[UIImage imageNamed:@"head-portrait-big"]];
        touxiangImageView.tag=1000;
        touxiangImageView.layer.cornerRadius=30;
        touxiangImageView.clipsToBounds=YES;
        [touxiang addSubview:touxiangImageView];
        [touxiangImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(0);
            make.right.mas_equalTo(imageView.mas_left).offset(-15);
            make.size.mas_equalTo(CGSizeMake(60, 60));
        }];
        
        UILabel *line=[[UILabel alloc]init];
        line.backgroundColor=[UIColor colorWithHexString:@"#dcdcdc"];
        [touxiang addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(0);
            make.left.mas_equalTo(15);
            make.right.mas_equalTo(0);
            make.height.mas_equalTo(0.5);
        }];
        
        return whiteView;
        
    }else if(section==1){
        return [UIView new];
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return 100;
    }else if(section==1){
        return 15;
    }
    return 0;
}


- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section==0) {
        return [UIView new];
    }else if(section==1){
        
        UIView *bgView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 115)];
        bgView.backgroundColor=[UIColor clearColor];
        
        
        UIView *whiteView=[[UIView alloc]initWithFrame:CGRectMake(0, 15, SCREEN_WIDTH, 100)];
        whiteView.backgroundColor=[UIColor whiteColor];
        [bgView addSubview:whiteView];
        
        
        UIImageView *imageView=[[UIImageView alloc]init];
        [imageView sd_setImageWithURL:[NSURL URLWithString:self.meModel.qrimage] placeholderImage:[UIImage imageNamed:@"上传二维码"]];
        [whiteView addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(0);
            make.left.mas_equalTo(15);
            make.size.mas_equalTo(CGSizeMake(60, 60));
        }];
        
        addButtom=[UIButton buttonWithTitle:@"" titleColor:[UIColor clearColor] font:[UIFont systemFontOfSize:0] target:self action:@selector(addErWeiMa)];
        [whiteView addSubview:addButtom];
        [addButtom mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(0);
            make.left.mas_equalTo(15);
            make.size.mas_equalTo(CGSizeMake(60, 60));
        }];
        
        UILabel *label=[[UILabel alloc]init];
        label.textColor=[UIColor colorWithHexString:@"#282828"];
        label.font=font13;
        label.text=@"个人微信二维码（将显示在名片中）";
        [whiteView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(addButtom);
            make.left.mas_equalTo(addButtom.mas_right).offset(15);
        }];
        
        UIButton *jieshao=[UIButton buttonWithTitle:@"如何获取二维码？" titleColor:[UIColor colorWithHexString:@"#595959"] font:[UIFont systemFontOfSize:12] target:self action:@selector(jishao)];
        [whiteView addSubview:jieshao];
        [jieshao mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(label.mas_bottom).offset(-5);
            make.left.mas_equalTo(addButtom.mas_right).offset(15);
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
        return 130;
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
            edit.fieldText=self.meModel.name;
            edit.placeHorderStr=@"请设置名片昵称";
            edit.subTitleStr=@"该昵称将显示在您的个人名片等展业宣传信息中";
            edit.BackBlock=^(NSString *backStr){
                MyMessageCell *cell=[self.myTableView cellForRowAtIndexPath:indexPath];
                cell.subTitle.text=backStr;
                [NotiCenter postNotificationName:@"changeUserInfor" object:nil];
            };
            [self.navigationController pushViewController:edit animated:YES];
        }else if (indexPath.row==1){
            //手机号
            //[self changePhone:indexPath];
        }else if (indexPath.row==2){
            //性别
            //[self changeSex:indexPath];
        }else if(indexPath.row==3){
            if (self.meModel.isauth) {
            }else{
                //实名认证
                [self shimingrenzheng:indexPath];
            }
        }
     }else if (indexPath.section==1){
        if (indexPath.row==0) {
            EditController *edit=[[EditController alloc]init];
            edit.hidesBottomBarWhenPushed=YES;
            edit.titleStr=@"公司";
            edit.placeHorderStr=@"请输入您所在公司的名称";
            edit.subTitleStr=@"";
            edit.fieldText=self.meModel.company;
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
            edit.fieldText=self.meModel.position;
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
    UIAlertController *alertController=[UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cancelAction=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *camera=[UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.picker getPhotoWithCamera:^(UIImage *selectedImage) {
            [self postErweiMa:selectedImage];
        } editing:YES faild:^{
            [self alertWithMessage:@"请在iphone的“设置-隐私-相机”选项中，允许圈圈使用您的相机"];
        } showIn:self];
    }];
    UIAlertAction *photo=[UIAlertAction actionWithTitle:@"从相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.picker getPhotoWithPhotoLib:^(UIImage *selecteImage) {
            [self postErweiMa:selecteImage];
        } editing:YES faild:^{
            [self alertWithMessage:@"请在iphone的“设置-隐私-照片”选项中，允许圈圈访问您的手机相册"];
        } showIn:self];
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:camera];
    [alertController addAction:photo];
    [self presentViewController:alertController animated:YES completion:nil];
}

//上传微信二维码
- (void)postErweiMa:(UIImage *)erweimaImage{
    NSString *url=[NSString stringWithFormat:@"%@%@",APPHOSTURL,uploadErweiMa];
    [XWNetworking uploadImagesWithURL:url parameters:nil name:@"upload" images:@[erweimaImage] fileNames:nil imageScale:0.8 imageType:nil progress:^(int64_t bytesProgress, int64_t totalBytesProgress) {
    } success:^(id response) {
        if (response) {
            NSInteger statusCode=[response integerForKey:@"code"];
            if (statusCode==0) {
                NSString *errorMsg=[response stringForKey:@"message"];
                [MBProgressHUD ToastInformation:errorMsg];
            }else if (statusCode==1){
                WeakSelf;
                weakSelf.meModel=[MeModel mj_objectWithKeyValues:[response objectForKey:@"data"]];
                [weakSelf saveMeModelMessage:self.meModel];
                [weakSelf.myTableView reloadData];
                [MBProgressHUD showSuccess:@"上传成功"];
            }
        }
        
    } failure:^(NSError *error) {
        if ([XWNetworking isHaveNetwork]) {
            [MBProgressHUD ToastInformation:@"服务器开小差了"];
        }else{
            [MBProgressHUD ToastInformation:@"网络似乎已断开..."];
        }
    } showHUD:YES];
}

//如何使用微信二维码
- (void)jishao{
    BaseWebViewController *webView=[[BaseWebViewController alloc]init];
    webView.urlStr=[NSString stringWithFormat:@"%@%@",H5HOSTURL,getqrcode];
    webView.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:webView animated:YES];
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
    NSString *url=[NSString stringWithFormat:@"%@%@",APPHOSTURL,uploadTouxiang];
    [XWNetworking uploadImagesWithURL:url parameters:nil name:@"upload" images:@[touxiangImage] fileNames:nil imageScale:0.8 imageType:nil progress:^(int64_t bytesProgress, int64_t totalBytesProgress) {
        
    } success:^(id response) {
        if (response) {
            NSInteger statusCode=[response integerForKey:@"code"];
            if (statusCode==0) {
                NSString *errorMsg=[response stringForKey:@"message"];
                [MBProgressHUD ToastInformation:errorMsg];
            }else if (statusCode==1){
                WeakSelf;
                weakSelf.meModel=[MeModel mj_objectWithKeyValues:[response objectForKey:@"data"]];
                [weakSelf saveMeModelMessage:self.meModel];
                [weakSelf.myTableView reloadData];
                [NotiCenter postNotificationName:@"changeUserInfor" object:nil];
                [MBProgressHUD showSuccess:@"上传成功"];
            }
        }
        
    } failure:^(NSError *error) {
        if ([XWNetworking isHaveNetwork]) {
            [MBProgressHUD ToastInformation:@"服务器开小差了"];
        }else{
            [MBProgressHUD ToastInformation:@"网络似乎已断开..."];
        }
    } showHUD:YES];
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
        _myTableView.tableHeaderView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.001)];
        _myTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
        
        [_myTableView registerNib:[UINib nibWithNibName:NSStringFromClass([MyMessageCell class]) bundle:nil] forCellReuseIdentifier:tableviewCellIndentifer];
        [self.view addSubview:_myTableView];
        _myTableView.sd_layout.leftSpaceToView(self.view,0).topSpaceToView(self.view,64).rightSpaceToView(self.view,0).bottomSpaceToView(self.view,0);
        
        [self addMJheader];

    }
    return _myTableView;
}

#pragma mark 增加addMJ_Head
- (void)addMJheader{
    MJHeader *mjHeader=[MJHeader headerWithRefreshingBlock:^{
        NSString *url=[NSString stringWithFormat:@"%@%@",APPHOSTURL,personinfo];
        [XWNetworking getJsonWithUrl:url params:nil responseCache:^(id responseCache) {
            if (responseCache) {
                [self saveData:responseCache];
            }
        } success:^(id response) {
            [self saveData:response];
            [self endFreshAndLoadMore];
        } fail:^(NSError *error) {
            if ([XWNetworking isHaveNetwork]) {
                [MBProgressHUD ToastInformation:@"服务器开小差了"];
            }else{
                [MBProgressHUD ToastInformation:@"网络似乎已断开..."];
            }
            [self endFreshAndLoadMore];
        } showHud:NO];
    }];
    _myTableView.mj_header=mjHeader;
}

//保存数据
- (void)saveData:(id)response{
    if (response) {
        NSInteger statusCode=[response integerForKey:@"code"];
        if (statusCode==0) {
            NSString *errorMsg=[response stringForKey:@"message"];
            [MBProgressHUD ToastInformation:errorMsg];
        }else if (statusCode==1){
            self.meModel=[MeModel mj_objectWithKeyValues:[response objectForKey:@"data"]];
            [self saveMeModelMessage:self.meModel];
            [self.myTableView reloadData];
        }
    }
}



#pragma mark 关闭mjrefreshing
- (void)endFreshAndLoadMore{
    [_myTableView.mj_header endRefreshing];
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

/**
 *  友盟统计页面打开开始时间
 *
 */
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"名片信息"];
}
/**
 *  友盟统计页面关闭时间
 *
 */
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"名片信息"];
}



@end
