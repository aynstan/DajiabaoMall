//
//  SDPhotoBrowser.m
//  photobrowser
//
//  Created by aier on 15-2-3.
//  Copyright (c) 2015年 aier. All rights reserved.
//

#import "SDPhotoBrowser.h"
#import "UIImageView+WebCache.h"
#import "SDBrowserImageView.h"
#import <Photos/Photos.h>
#import <AssetsLibrary/AssetsLibrary.h>
//  ============在这里方便配置样式相关设置===========
#import "SDPhotoBrowserConfig.h"
//  =============================================

@implementation SDPhotoBrowser {
    UIScrollView *_scrollView;
    BOOL _hasShowedFistView;
    UIPageControl *pageControl;
    //UILabel *_indexLabel;
    UIButton *_saveButton;
    UIActivityIndicatorView *_indicatorView;
    BOOL _willDisappear;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = SDPhotoBrowserBackgrounColor;
    [self setupScrollView];
    [self setupToolbars];
}

//操作视图
- (void)setupToolbars{
    // 1. 序标
//    UILabel *indexLabel = [[UILabel alloc] init];
//    indexLabel.bounds = CGRectMake(0, 0, 80, 30);
//    indexLabel.textAlignment = NSTextAlignmentCenter;
//    indexLabel.textColor = [UIColor whiteColor];
//    indexLabel.font = [UIFont boldSystemFontOfSize:20];
//    indexLabel.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
//    indexLabel.layer.cornerRadius = indexLabel.bounds.size.height * 0.5;
//    indexLabel.clipsToBounds = YES;
//    if (self.imageCount > 1) {
//        indexLabel.text = [NSString stringWithFormat:@"1/%ld", (long)self.imageCount];
//    }
//    _indexLabel = indexLabel;
//    [self addSubview:indexLabel];
    
    
    pageControl= [[UIPageControl alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-300)/2.0, SCREEN_HEIGHT-40, 300, 20)];
    //设置表示的页数
    pageControl.numberOfPages =self.imageCount;
    //设置选中的页数
    pageControl.currentPage =self.currentImageIndex;
    //设置未选中点的颜色
    pageControl.pageIndicatorTintColor = [UIColor colorWithWhite:1 alpha:0.3];
    //设置选中点的颜色
    pageControl.currentPageIndicatorTintColor = [UIColor colorWithWhite:1 alpha:1];
    //禁用触摸响应
    [pageControl setUserInteractionEnabled:NO];
    [self.view addSubview:pageControl];
    
    // 2.保存按钮
//    UIButton *saveButton = [[UIButton alloc] init];
//    [saveButton setTitle:@"保存" forState:UIControlStateNormal];
//    [saveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    saveButton.backgroundColor = [UIColor colorWithRed:0.1f green:0.1f blue:0.1f alpha:0.90f];
//    saveButton.layer.cornerRadius = 5;
//    saveButton.clipsToBounds = YES;
//    [saveButton addTarget:self action:@selector(saveImage) forControlEvents:UIControlEventTouchUpInside];
//    _saveButton = saveButton;
//    [self addSubview:saveButton];
}


//UIScrollView
- (void)setupScrollView{
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.delegate = self;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.pagingEnabled = YES;
    _scrollView.tag=1000;
    [self.view addSubview:_scrollView];
    for (int i = 0; i < self.imageCount; i++) {
        SDBrowserImageView *imageView = [[SDBrowserImageView alloc] init];
        imageView.tag = i;
        // 单击图片
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(photoClick:)];
        // 双击放大图片
        UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewDoubleTaped:)];
        doubleTap.numberOfTapsRequired = 2;
        [singleTap requireGestureRecognizerToFail:doubleTap];
        //长按保存
        UILongPressGestureRecognizer *longPress=[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(saveImage)];
        [doubleTap requireGestureRecognizerToFail:longPress];
        
        [imageView addGestureRecognizer:longPress];
        [imageView addGestureRecognizer:singleTap];
        [imageView addGestureRecognizer:doubleTap];
        [_scrollView addSubview:imageView];
    }
    [self initAuto];
    [self setupImageOfImageViewForIndex:self.currentImageIndex];
    
}

- (void)initAuto{
    CGRect rect = self.view.bounds;
    rect.size.width += SDPhotoBrowserImageViewMargin * 2;
    _scrollView.bounds = rect;
    _scrollView.center = self.view.center;
    CGFloat y = 0;
    CGFloat w = _scrollView.frame.size.width - SDPhotoBrowserImageViewMargin * 2;
    CGFloat h = _scrollView.frame.size.height;
    [_scrollView.subviews enumerateObjectsUsingBlock:^(SDBrowserImageView *obj, NSUInteger idx, BOOL *stop) {
        CGFloat x = SDPhotoBrowserImageViewMargin + idx * (SDPhotoBrowserImageViewMargin * 2 + w);
        obj.frame = CGRectMake(x, y, w, h);
    }];
    _scrollView.contentSize = CGSizeMake(_scrollView.subviews.count * _scrollView.frame.size.width, 0);
    _scrollView.contentOffset = CGPointMake(self.currentImageIndex * _scrollView.frame.size.width, 0);
    if (!_hasShowedFistView) {
        [self showFirstImage];
    }
    //_indexLabel.center = CGPointMake(self.bounds.size.width * 0.5, 35);
    _saveButton.frame = CGRectMake(self.view.bounds.size.width-75, self.view.bounds.size.height - 70, 50, 25);
}


//保存图片
- (void)saveImage{
    UIAlertController *imageAlert=[UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cancel=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *saveAlertAction=[UIAlertAction actionWithTitle:@"保存图片" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        PHAuthorizationStatus author = [PHPhotoLibrary authorizationStatus];
        if (author == ALAuthorizationStatusRestricted || author == ALAuthorizationStatusDenied) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self alertWithMessage:@"请在iphone的“设置-隐私-照片”选项中，允许圈圈访问您的手机相册"];
            });
        }else if(author == ALAuthorizationStatusNotDetermined){
            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                if (status == PHAuthorizationStatusRestricted || status == PHAuthorizationStatusDenied){
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self alertWithMessage:@"请在iphone的“设置-隐私-照片”选项中，允许圈圈访问您的手机相册"];
                    });
                }else if (status == PHAuthorizationStatusAuthorized){
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self save];
                    });
                }
            }];
        }else if(author == ALAuthorizationStatusAuthorized){
            [self save];
        }
    }];
    [imageAlert addAction:saveAlertAction];
    [imageAlert addAction:cancel];
    [self presentViewController:imageAlert animated:YES completion:nil];
}

//保存
- (void)save{
    int index = _scrollView.contentOffset.x / _scrollView.bounds.size.width;
    UIImageView *currentImageView = _scrollView.subviews[index];
    UIImageWriteToSavedPhotosAlbum(currentImageView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] init];
    indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    indicator.center = self.view.center;
    _indicatorView = indicator;
    _indicatorView.hidesWhenStopped=YES;
    [[UIApplication sharedApplication].keyWindow addSubview:indicator];
    [indicator startAnimating];
}

//权限提醒
- (void)alertWithMessage:(NSString *)toastMessage{
    UIAlertController *phoneAlert=[UIAlertController alertControllerWithTitle:@"提醒" message:toastMessage preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel=[UIAlertAction actionWithTitle:@"我知道了" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [phoneAlert addAction:cancel];
    [self presentViewController:phoneAlert animated:YES completion:nil];
}


//保存图片回调
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    [_indicatorView stopAnimating];
    [_indicatorView removeFromSuperview];
    if (error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD showSuccess:@"保存失败"];
        });
    }else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD showSuccess:@"图片已保存到相册"];
        });
    }
}

// 加载图片
- (void)setupImageOfImageViewForIndex:(NSInteger)index{
    SDBrowserImageView *imageView = _scrollView.subviews[index];
    self.currentImageIndex = index;
    if (imageView.hasLoadedImage) return;
    if ([self highQualityImageURLForIndex:index]) {
        [imageView setImageWithURL:[self highQualityImageURLForIndex:index] placeholderImage:[self placeholderImageForIndex:index]];
    } else {
        imageView.image = [self placeholderImageForIndex:index];
    }
    imageView.hasLoadedImage = YES;
}

- (void)photoClick:(UITapGestureRecognizer *)recognizer{
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (void)imageViewDoubleTaped:(UITapGestureRecognizer *)recognizer{
    SDBrowserImageView *imageView = (SDBrowserImageView *)recognizer.view;
    CGFloat scale;
    if (imageView.isScaled) {
        scale = 1.0;
    } else {
        scale = 2.0;
    }
    SDBrowserImageView *view = (SDBrowserImageView *)recognizer.view;
    [view doubleTapToZommWithScale:scale];
}


- (void)showFirstImage{
    [UIView animateWithDuration:SDPhotoBrowserShowImageAnimationDuration animations:^{
        _hasShowedFistView = YES;
        _scrollView.hidden = NO;
    } completion:^(BOOL finished) {
        
    }];
}

- (UIImage *)placeholderImageForIndex:(NSInteger)index{
    if ([self.delegate respondsToSelector:@selector(photoBrowser:placeholderImageForIndex:)]) {
        return [self.delegate photoBrowser:self placeholderImageForIndex:index];
    }
    return nil;
}

- (NSURL *)highQualityImageURLForIndex:(NSInteger)index{
    if ([self.delegate respondsToSelector:@selector(photoBrowser:highQualityImageURLForIndex:)]) {
        return [self.delegate photoBrowser:self highQualityImageURLForIndex:index];
    }
    return nil;
}

#pragma mark - scrollview代理方法

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    int index = (scrollView.contentOffset.x + _scrollView.bounds.size.width * 0.5) / _scrollView.bounds.size.width;
    // 有过缩放的图片在拖动一定距离后清除缩放
    CGFloat margin = 150;
    CGFloat x = scrollView.contentOffset.x;
    if ((x - index * self.view.bounds.size.width) > margin || (x - index * self.view.bounds.size.width) < - margin) {
        SDBrowserImageView *imageView = _scrollView.subviews[index];
        if (imageView.isScaled) {
            [UIView animateWithDuration:0.5 animations:^{
                imageView.transform = CGAffineTransformIdentity;
            } completion:^(BOOL finished) {
                [imageView eliminateScale];
            }];
        }
    }
    if (!_willDisappear) {
        pageControl.currentPage=index;
        //_indexLabel.text = [NSString stringWithFormat:@"%d/%ld", index + 1, (long)self.imageCount];
    }
    [self setupImageOfImageViewForIndex:index];
}

//隐藏电池栏
- (BOOL)prefersStatusBarHidden{
    return YES;
}

@end
