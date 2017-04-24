//
//  GetGroupController.m
//  DaJiaBaoMall
//
//  Created by 大家保 on 2017/4/1.
//  Copyright © 2017年 大家保. All rights reserved.
//

#import "GetGroupController.h"
#import "GetGroupCell.h"
#import "CameraAndPhotoPicker.h"
#import "ErweiMaView.h"
#import "ToastErweiMaView.h"
#import "WechatGrop.h"

@interface GetGroupController ()<UICollectionViewDelegate,UICollectionViewDataSource,ErweiMaView_Delegate,ToastErweiMaView_Delegate>

@property (nonatomic,strong)UICollectionView *myCollectionView;

@property (nonatomic,strong) NSMutableArray *CollectionArray;

@property (nonatomic, strong) CameraAndPhotoPicker *picker;

@property (nonatomic,strong) JCAlertView *alertView;

@end

static NSString  * const Indentifer=@"CollectTion_Cell";

@implementation GetGroupController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.bgView.hidden=YES;
    [self initUI];
    [self.myCollectionView.mj_header beginRefreshing];
}


- (void)initUI{
    
    self.myCollectionView.hidden=NO;
    
    UIView *bottomView=[[UIView alloc]init];
    bottomView.backgroundColor=[UIColor clearColor];
    [self.view addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(50);
        make.bottom.mas_equalTo(0);
    }];
    
    
    UIButton *tixianButton=[[UIButton alloc]init];
    [tixianButton setTitle:@"上传我的群二维码" forState:0];
    [tixianButton setTitleColor:[UIColor colorWithHexString:@"#ff693a"] forState:0];
    [tixianButton.titleLabel setFont:font16];
    tixianButton.layer.cornerRadius=20;
    tixianButton.layer.borderColor=[UIColor colorWithHexString:@"#ff693a"].CGColor;
    tixianButton.layer.borderWidth=0.5;
    tixianButton.clipsToBounds=YES;
    tixianButton.backgroundColor=[UIColor whiteColor];
    [tixianButton addTarget:self action:@selector(postMyErweima:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:tixianButton];
    [tixianButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.centerX.mas_equalTo(0);
        make.width.mas_equalTo(210);
    }];
}

//保存数据
- (void)saveData:(id)response{
    if (response) {
        NSLog(@"群数据%@",response);
        NSInteger statusCode=[response integerForKey:@"code"];
        if (statusCode==0) {
            NSString *errorMsg=[response stringForKey:@"message"];
            [MBProgressHUD ToastInformation:errorMsg];
        }else if (statusCode==1){
            [self.CollectionArray removeAllObjects];
            NSArray<WechatGrop *> *catogoryArr=[WechatGrop mj_objectArrayWithKeyValuesArray:response[@"data"]];
            [self.CollectionArray addObjectsFromArray:catogoryArr];
            [self.myCollectionView reloadData];
        }
    }
}


//上传我的二维码
- (void)postMyErweima:(UIButton *)sender{
    UIAlertController *alertController=[UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cancelAction=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *camera=[UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.picker getPhotoWithCamera:^(UIImage *selectedImage) {
            [self saveTouxiang:selectedImage];
        } editing:NO faild:^{
            [self alertWithMessage:@"请在iphone的“设置-隐私-相机”选项中，允许圈圈使用您的相机"];
        } showIn:self];
    }];
    UIAlertAction *photo=[UIAlertAction actionWithTitle:@"从相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.picker getPhotoWithPhotoLib:^(UIImage *selecteImage) {
            [self saveTouxiang:selecteImage];
        } editing:NO faild:^{
            [self alertWithMessage:@"请在iphone的“设置-隐私-照片”选项中，允许圈圈访问您的手机相册"];
        } showIn:self];
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:camera];
    [alertController addAction:photo];
    [self presentViewController:alertController animated:YES completion:nil];
}

//加载相册图片
- (void)saveTouxiang:(UIImage *)touxiangImage{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        ErweiMaView *cell=[[[NSBundle mainBundle]loadNibNamed:@"ErweiMaView" owner:nil options:nil]lastObject];
        cell.delegate=self;
        cell.frame=CGRectMake(0, 0, 280, 280*440/300.0);
        cell.erweiMaImageView.image=touxiangImage;
        _alertView=[[JCAlertView alloc]initWithCustomView:cell dismissWhenTouchedBackground:NO];
        [_alertView show];
    });
}

//上传图片代理
- (void)clickView:(ErweiMaView *)view clickCancel:(UIButton *)sender{
    [_alertView dismissWithCompletion:nil];
};

- (void)clickView:(ErweiMaView *)view clickPost:(UIButton *)sender postImage:(UIImage *)postImage wechatName:(NSString *)name{
    [_alertView dismissWithCompletion:^{
        [self postImage:postImage andWechatName:name];
    }];
};

//上传图片到服务器
- (void)postImage:(UIImage *)postImage andWechatName:(NSString *)name{
    NSString *url=[NSString stringWithFormat:@"%@%@",APPHOSTURL,uploadWXGroup];
    NSDictionary *dic=@{@"name":name};
    [XWNetworking uploadImagesWithURL:url parameters:dic name:@"upload" images:@[postImage] fileNames:nil imageScale:0.6 imageType:nil progress:^(int64_t bytesProgress, int64_t totalBytesProgress) {
        
    } success:^(id response) {
        if (response) {
            NSInteger statusCode=[response integerForKey:@"code"];
            if (statusCode==0) {
                NSString *errorMsg=[response stringForKey:@"message"];
                [MBProgressHUD ToastInformation:errorMsg];
            }else if (statusCode==1){
                [MBProgressHUD showSuccess:@"群二维码已提交成功，正等待审核"];
            }
        }
        
    } failure:^(NSError *error) {
        [MBProgressHUD ToastInformation:@"服务器开小差了"];
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



#pragma mark - CollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.CollectionArray.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    WechatGrop *grop=self.CollectionArray[indexPath.item];
    GetGroupCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:Indentifer forIndexPath:indexPath];
    [cell setModel:grop];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    WechatGrop *grop=self.CollectionArray[indexPath.item];
    ToastErweiMaView *cell=[[[NSBundle mainBundle]loadNibNamed:@"ToastErweiMaView" owner:nil options:nil]lastObject];
    cell.delegate=self;
    cell.frame=CGRectMake(0, 0, 280, 280*450/310.0);
    [cell.erweimaImageView sd_setImageWithURL:[NSURL URLWithString:grop.images] placeholderImage:[UIImage imageNamed:@"空白图"]];
    _alertView=[[JCAlertView alloc]initWithCustomView:cell dismissWhenTouchedBackground:NO];
    [_alertView show];
};



#pragma mark 群操作
//取消操作
- (void)clickView:(ToastErweiMaView *)view clickToastCancel:(UIButton *)sender{
    [_alertView dismissWithCompletion:nil];
};

//保存图片
- (void)clickView:(ToastErweiMaView *)view clickSave:(UIButton *)sender andIndex:(NSInteger)index{
    [_alertView dismissWithCompletion:^{
        WechatGrop *grop=self.CollectionArray[index];
        UIImage *saveImage=[[UIImage alloc]initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:grop.images]]];
        if (saveImage) {
            [MBProgressHUD showHUDWithTitle:@"正在保存..."];
            UIImageWriteToSavedPhotosAlbum(saveImage, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
        }
    }];
};

/**
 *  是否保存成功回调
 */
- (void)image: (UIImage *) image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo{
    if(error){
        [MBProgressHUD ToastInformation:@"二维码保存失败"];
    }else{
        [MBProgressHUD showSuccess:@"二维码保存成功"];
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake((SCREEN_WIDTH-46)/3, ((SCREEN_WIDTH-46)/3-20)*896/674.0+24+34);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 20;
}

- (CameraAndPhotoPicker *)picker{
    if (!_picker) {
        _picker=[[CameraAndPhotoPicker alloc]init];
        _picker.saveToLocal=YES;
    }
    return _picker;
}


- (UICollectionView *)myCollectionView{
    if (!_myCollectionView) {
        //添加collectionview
        UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc]init];
        layout.scrollDirection=UICollectionViewScrollDirectionVertical;
        layout.sectionInset=UIEdgeInsetsMake(20, 13, 70, 13);
        _myCollectionView=[[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        self.myCollectionView.backgroundColor=[UIColor whiteColor];
        [_myCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([GetGroupCell class]) bundle:nil] forCellWithReuseIdentifier:Indentifer];
        _myCollectionView.delegate=self;
        _myCollectionView.dataSource=self;
        _myCollectionView.backgroundColor=[UIColor whiteColor];
        [self.view addSubview:_myCollectionView];
        _myCollectionView.sd_layout.leftSpaceToView(self.view,0).topSpaceToView(self.view,10).rightSpaceToView(self.view,0).bottomSpaceToView(self.view,0);
        [self addMJheader];
    }
    return _myCollectionView;
}

#pragma mark 增加addMJ_Head
- (void)addMJheader{
    MJHeader *mjHeader=[MJHeader headerWithRefreshingBlock:^{
        NSString *url=[NSString stringWithFormat:@"%@%@",APPHOSTURL,getWechatGroup];
        [XWNetworking getJsonWithUrl:url params:nil success:^(id response) {
            [self saveData:response];
            [self endFreshAndLoadMore];
        } fail:^(NSError *error) {
            [MBProgressHUD ToastInformation:@"服务器开小差了"];
            [self endFreshAndLoadMore];
        } showHud:NO];
    }];
    _myCollectionView.mj_header=mjHeader;
}


#pragma mark 关闭mjrefreshing
- (void)endFreshAndLoadMore{
    [_myCollectionView.mj_header endRefreshing];
}


- (NSMutableArray *)CollectionArray{
    if (_CollectionArray==nil) {
        _CollectionArray=[NSMutableArray array];
    }
    return _CollectionArray;
}

/**
 *  友盟统计页面打开开始时间
 *
 */
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"加群"];
}
/**
 *  友盟统计页面关闭时间
 *
 */
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"加群"];
}


@end
