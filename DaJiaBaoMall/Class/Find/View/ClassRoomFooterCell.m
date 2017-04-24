//
//  ClassRoomFooterCell.m
//  DaJiaBaoMall
//
//  Created by 大家保 on 2017/3/30.
//  Copyright © 2017年 大家保. All rights reserved.
//

#import "ClassRoomFooterCell.h"
#import "MediaCollectionViewCell.h"
#import "ClassContentModel.h"
#import "WXApi.h"


@interface ClassRoomFooterCell()<UICollectionViewDelegate,UICollectionViewDataSource,MediaCollectionViewCell_Delegate>

@property (nonatomic,strong)UICollectionView *myCollectionView;

@property (nonatomic,strong) NSMutableArray *CollectionArray;

@end

static NSString  * const Indentifer=@"CollectTion_Cell";

@implementation ClassRoomFooterCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initUI];
    }
    return self;
}

- (void)initUI{
    self.backgroundColor=[UIColor clearColor];
    //添加collectionview
    UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc]init];
    layout.scrollDirection=UICollectionViewScrollDirectionVertical;
    layout.sectionInset=UIEdgeInsetsMake(20, 10, 20, 10);
    self.myCollectionView=[[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
    self.myCollectionView.backgroundColor=[UIColor whiteColor];
    [self.myCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([MediaCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:Indentifer];
    self.myCollectionView.delegate=self;
    self.myCollectionView.dataSource=self;
    self.myCollectionView.scrollEnabled=NO;
    self.myCollectionView.backgroundColor=[UIColor whiteColor];
    [self.contentView addSubview:self.myCollectionView];
    
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [self.myCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
}



- (void)setModelArray:(NSMutableArray<ClassContentModel *> *)modelArray{
    _modelArray=modelArray;
    _CollectionArray=[NSMutableArray arrayWithArray:modelArray];
    [self.myCollectionView reloadData];
};



#pragma mark - CollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.CollectionArray.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    MediaCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:Indentifer forIndexPath:indexPath];
    [cell setModel:_CollectionArray[indexPath.row]];
    cell.clickTag=indexPath.row;
    cell.cellDelegate=self;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(clickCell:onTheCollectionViewIndex:)]) {
        [self.delegate clickCell:self onTheCollectionViewIndex:indexPath.row];
    }
};

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake((SCREEN_WIDTH-30)/2, (SCREEN_WIDTH-30)/2*199/165.0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}

//分享给朋友
- (void)clickCell:(MediaCollectionViewCell *)cell index:(NSInteger )clickIndex{
    ClassContentModel *contentModel=_CollectionArray[clickIndex];
    [self touch:contentModel];
};

#pragma mark 分享到朋友圈
- (void)touch:(ClassContentModel *)model{
    if ([WXApi isWXAppInstalled]) {
        WeakSelf;
        [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
            [weakSelf shareWebPageToPlatformType:platformType withModel:model] ;
        }];
    }else{
        UIAlertController *alertController=[UIAlertController alertControllerWithTitle:@"提醒" message:@"您尚未安装微信客户端，暂无法使用微信分享功能" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction=[UIAlertAction actionWithTitle:@"我知道了" style:UIAlertActionStyleCancel handler:nil];
        [alertController addAction:cancelAction];
        [KeyWindow.rootViewController presentViewController:alertController animated:YES completion:nil];
    }
}

- (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType withModel:(ClassContentModel *)shareModel{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    //创建网页内容对象
    NSString* thumbURL =  shareModel.image;
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:shareModel.title descr:shareModel.context thumImage:[NSData dataWithContentsOfURL:[NSURL URLWithString:thumbURL]]];
    //设置网页地址
    shareObject.webpageUrl = shareModel.url;
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        if (error) {
            [MBProgressHUD ToastInformation:@"分享失败"];
        }else{
            [MBProgressHUD ToastInformation:@"分享成功"];
        }
    }];
}



- (NSMutableArray *)CollectionArray{
    if (_CollectionArray==nil) {
        _CollectionArray=[NSMutableArray array];
    }
    return _CollectionArray;
}


- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.contentView.backgroundColor=[UIColor whiteColor];
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    [super setHighlighted:highlighted animated:animated];
    self.contentView.backgroundColor=[UIColor whiteColor];
}



@end
