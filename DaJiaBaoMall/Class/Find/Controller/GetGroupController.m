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
}


- (void)initUI{
    
    self.myCollectionView.hidden=NO;
    
    UIView *bottomView=[[UIView alloc]init];
    bottomView.backgroundColor=RGB(231, 231, 232);
    [self.view addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(50);
        make.bottom.mas_equalTo(0);
    }];
    
    
    UIButton *tixianButton=[[UIButton alloc]init];
    [tixianButton setTitle:@"上传我的二维码" forState:0];
    [tixianButton setTitleColor:[UIColor blueColor] forState:0];
    [tixianButton.titleLabel setFont:font17];
    
    [tixianButton addTarget:self action:@selector(postMyErweima:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:tixianButton];
    [tixianButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-20);
        make.centerY.mas_equalTo(0);
        make.left.mas_equalTo(20);
    }];
}

//上传我的二维码
- (void)postMyErweima:(UIButton *)sender{
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
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        ErweiMaView *cell=[[[NSBundle mainBundle]loadNibNamed:@"ErweiMaView" owner:nil options:nil]lastObject];
        cell.delegate=self;
        cell.frame=CGRectMake(0, 0, 300, 400);
        cell.erweiMaImageView.image=touxiangImage;
        _alertView=[[JCAlertView alloc]initWithCustomView:cell dismissWhenTouchedBackground:NO];
        [_alertView show];
    });
}

//上传图片代理
- (void)clickView:(ErweiMaView *)view clickCancel:(UIButton *)sender{
    [_alertView dismissWithCompletion:nil];
};

- (void)clickView:(ErweiMaView *)view clickPost:(UIButton *)sender{
    [_alertView dismissWithCompletion:^{
        
    }];
};



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
    return 12;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    GetGroupCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:Indentifer forIndexPath:indexPath];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    ToastErweiMaView *cell=[[[NSBundle mainBundle]loadNibNamed:@"ToastErweiMaView" owner:nil options:nil]lastObject];
    cell.delegate=self;
    cell.frame=CGRectMake(0, 0, 300, 400);
    cell.erweimaImageView.image=[UIImage imageNamed:@"会员头像"];
    _alertView=[[JCAlertView alloc]initWithCustomView:cell dismissWhenTouchedBackground:NO];
    [_alertView show];
};

#pragma mark 群操作
//取消操作
- (void)clickView:(ToastErweiMaView *)view clickToastCancel:(UIButton *)sender{
    [_alertView dismissWithCompletion:nil];
};

//保存图片
- (void)clickView:(ToastErweiMaView *)view clickSave:(UIButton *)sender{
    [_alertView dismissWithCompletion:^{
        UIImageWriteToSavedPhotosAlbum([UIImage imageNamed:@"会员头像"], self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
    }];
};

/**
 *  是否保存成功回调
 */
- (void)image: (UIImage *) image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo{
    if(error){
        [MBProgressHUD showError:@"二维码保存失败"];
    }else{
        [MBProgressHUD showSuccess:@"二维码保存成功"];
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake((SCREEN_WIDTH-40)/3, (SCREEN_WIDTH-40)/3*125/100.0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
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
        layout.sectionInset=UIEdgeInsetsMake(20, 10, 20, 10);
        _myCollectionView=[[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        self.myCollectionView.backgroundColor=[UIColor whiteColor];
        [_myCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([GetGroupCell class]) bundle:nil] forCellWithReuseIdentifier:Indentifer];
        _myCollectionView.delegate=self;
        _myCollectionView.dataSource=self;
        _myCollectionView.backgroundColor=[UIColor whiteColor];
        [self.view addSubview:_myCollectionView];
        _myCollectionView.sd_layout.leftSpaceToView(self.view,0).topSpaceToView(self.view,10).rightSpaceToView(self.view,0).bottomSpaceToView(self.view,50);
    }
    return _myCollectionView;
}

- (NSMutableArray *)CollectionArray{
    if (_CollectionArray==nil) {
        _CollectionArray=[NSMutableArray array];
    }
    return _CollectionArray;
}


@end
