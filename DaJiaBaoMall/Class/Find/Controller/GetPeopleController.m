//
//  GetPeopleController.m
//  DaJiaBaoMall
//
//  Created by 大家保 on 2017/4/1.
//  Copyright © 2017年 大家保. All rights reserved.
//

#import "GetPeopleController.h"
#import "MXPullDownMenu.h"
#import "GetPeopleCell.h"
#import "XW_AddressManager.h"
#import "XWPersonModel.h"

@interface GetPeopleController ()<MXPullDownMenuDelegate,UITableViewDelegate,UITableViewDataSource,GetPeopleCell_Delegate>{
    MXPullDownMenu *menu;
    UIButton *allSlected;
    UIButton *daoruButton;
}

@property (nonatomic,strong)UITableView *myTableView;

@property (nonatomic,strong)NSMutableArray *dataSourceArray;

@property (nonatomic,strong)NSMutableArray *selectedArray;

@property (nonatomic,assign) NSInteger maxSize;

@end

static NSString *const tableviewContentCell=@"ContentCell";

@implementation GetPeopleController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.bgView.hidden=YES;
    [self initUI];
    [self.myTableView.mj_header beginRefreshing];
    [menu updateContentWithArray:[NSMutableArray arrayWithArray:@[@[@"北京",@"上海",@"天津",@"广州",@"深圳"],@[@"男",@"女"]]]];
}

//界面初始化
- (void)initUI{
    
    UIView *headView=[[UIView alloc]initWithFrame:CGRectMake(0, 10, SCREEN_WIDTH, 44)];
    headView.backgroundColor=[UIColor whiteColor];
    
    UILabel *show=[[UILabel alloc]initWithFrame:CGRectMake(12, 0, SCREEN_WIDTH, 44)];
    show.text=@"您的获客剩余名额为：10人";
    show.font=font13;
    show.textColor=[UIColor darkGrayColor];
    [headView addSubview:show];
    
    [self.view addSubview:headView];
    
    UILabel *line=[[UILabel alloc]initWithFrame:CGRectMake(0, headView.y+headView.height, SCREEN_WIDTH, 0.5)];
    line.backgroundColor=RGB(231, 231, 232);
    [self.view addSubview:line];
    
    menu=[[MXPullDownMenu alloc]initWithArray:nil selectedColor:[UIColor redColor] frame:CGRectMake(0, line.y+line.height, SCREEN_WIDTH, 44) backGroundViewInView:self.view];
    menu.delegate=self;
    [self.view addSubview:menu];
    
    allSlected=[[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-56, 0, 56, 44)];
    [allSlected addTarget:self action:@selector(selectAll:) forControlEvents:UIControlEventTouchUpInside];
    [allSlected setImage:[UIImage imageNamed:@"unclick"] forState:0];
    [allSlected setImage:[UIImage imageNamed:@"click"] forState:UIControlStateSelected];
    [menu addSubview:allSlected];
    
    [self.myTableView setHidden:NO];
    
    UIView *bottomView=[[UIView alloc]init];
    bottomView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:bottomView];
    bottomView.sd_layout.leftSpaceToView(self.view,0).rightSpaceToView(self.view,0).bottomSpaceToView(self.view,0).heightIs(50);
    
    UILabel *bottomLine=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
    bottomLine.backgroundColor=RGB(231, 231, 232);
    [bottomView addSubview:bottomLine];
    
    UIButton *clearButton=[[UIButton alloc]initWithFrame:CGRectMake(0, 0.5, SCREEN_WIDTH*2/5.0, 49.5)];
    [clearButton setTitle:@"清除已倒入的号码" forState:0];
    [clearButton addTarget:self action:@selector(clearAll:) forControlEvents:UIControlEventTouchUpInside];
    [clearButton setTitleColor:[UIColor darkGrayColor] forState:0];
    [clearButton.titleLabel setFont:font15];
    [bottomView addSubview:clearButton];
    
    daoruButton=[[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH*2/5.0, 0.5, SCREEN_WIDTH*3/5.0, 49.5)];
    [daoruButton setTitle:@"立即获客（0人）" forState:0];
    [daoruButton addTarget:self action:@selector(daoru:) forControlEvents:UIControlEventTouchUpInside];
    [daoruButton setTitleColor:[UIColor darkGrayColor] forState:0];
    [daoruButton.titleLabel setFont:font15];
    [daoruButton setBackgroundColor:[UIColor orangeColor]];
    [bottomView addSubview:daoruButton];
}

//清除已导入的
- (void)clearAll:(UIButton *)sender{
    if (self.selectedArray.count==0) {
        [MBProgressHUD ToastInformation:@"暂无要清除的号码"];
        return;
    }
    [XW_AddressManager deletePersonArray:self.selectedArray SuccessBlock:^{
        
    } FaildBlcok:^{
        
    }];
}



//导入
- (void)daoru:(UIButton *)sender{
    if (self.selectedArray.count==0) {
        [MBProgressHUD ToastInformation:@"请先选择要导入的号码"];
        return;
    }
    [XW_AddressManager addPersonArray:self.selectedArray SuccessBlock:^{
        
    } FaildBlcok:^{
        
     }];
}


//MXPullDownMenuDelegate
- (void)PullDownMenu:(MXPullDownMenu *)pullDownMenu didSelectRowAtColumn:(NSInteger)column row:(NSInteger)row{
    NSLog(@"%ld    %ld",column,row);
};

//GetPeopleCell_Delegate
- (void)clickCell:(GetPeopleCell *)cell onButtonIndex:(NSInteger)index{
    
    XWPersonModel *model=self.dataSourceArray[index];
    model.checked=!model.checked;
    
    GetPeopleCell  *selctedCell=[self.myTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
    selctedCell.model=model;
    
    if (model.checked) {
        [self.selectedArray addObject:model];
    }else{
        [self.selectedArray removeObject:model];
    }
    
    allSlected.selected=(self.selectedArray.count==self.dataSourceArray.count);
    
    [self.myTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    
    [daoruButton setTitle:[NSString stringWithFormat:@"立即获客（%ld人）",self.selectedArray.count] forState:0];
};

//全选
- (void)selectAll:(UIButton *)sender{
    [menu dissMissBackGround];
    sender.selected=!sender.selected;
    
    if (self.selectedArray.count==self.dataSourceArray.count) {
        //全不选
        [self.selectedArray removeAllObjects];
        for (int i=0; i<[self.myTableView numberOfRowsInSection:0]; i++) {
            XWPersonModel *model=self.dataSourceArray[i];
            model.checked=NO;
        }
    }else{
        //全选
        [self.selectedArray removeAllObjects];
        for (int i=0; i<[self.myTableView numberOfRowsInSection:0]; i++) {
            XWPersonModel *model=self.dataSourceArray[i];
            model.checked=YES;
            [self.selectedArray addObject:model];
        }
    }
    [self.myTableView reloadData];
    [daoruButton setTitle:[NSString stringWithFormat:@"立即获客（%ld人）",self.selectedArray.count] forState:0];
}

#pragma mark uitableview delegate;
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GetPeopleCell *cell=[tableView dequeueReusableCellWithIdentifier:tableviewContentCell];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.delegate=self;
    cell.butoonIndex=indexPath.row;
    cell.model=self.dataSourceArray[indexPath.row];
    return cell;
}


- (CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSourceArray.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark 增加addMJ_Head
- (void)addMJheader{
    MJHeader *mjHeader=[MJHeader headerWithRefreshingBlock:^{
        [self endFreshAndLoadMore];
    }];
    _myTableView.mj_header=mjHeader;
}

#pragma mark 增加addMJ_Footer
- (void)addMJ_Footer{
    MJFooter *mjFooter=[MJFooter footerWithRefreshingBlock:^{
        [self endFreshAndLoadMore];
    }];
    _myTableView.mj_footer=mjFooter;
}

#pragma mark 关闭mjrefreshing
- (void)endFreshAndLoadMore{
    [_myTableView.mj_header endRefreshing];
    if (self.dataSourceArray.count>=self.maxSize) {
        [_myTableView.mj_footer endRefreshingWithNoMoreData];
    }else{
        [_myTableView.mj_footer endRefreshing];
    }
}

#pragma mark 懒加载
- (UITableView *)myTableView{
    if (!_myTableView) {
        _myTableView=[[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _myTableView.backgroundColor=[UIColor whiteColor];
        _myTableView.delegate=self;
        _myTableView.dataSource=self;
        _myTableView.tableFooterView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
        _myTableView.tableHeaderView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
        _myTableView.sectionFooterHeight=GetHeight(0.001);
        _myTableView.sectionHeaderHeight=GetHeight(0.0001);
        _myTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
        
        [_myTableView registerNib:[UINib nibWithNibName:NSStringFromClass([GetPeopleCell class]) bundle:nil] forCellReuseIdentifier:tableviewContentCell];
        [self.view addSubview:_myTableView];
        
        _myTableView.sd_layout.leftSpaceToView(self.view,0).topSpaceToView(self.view,menu.y+menu.height).rightSpaceToView(self.view,0).bottomSpaceToView(self.view,50);
        [self addMJheader];
    }
    return _myTableView;
}

- (NSMutableArray *)dataSourceArray{
    if (!_dataSourceArray) {
        _dataSourceArray=[NSMutableArray array];
        for (int i=0; i<5; i++) {
            XWPersonModel *nanPeople=[[XWPersonModel alloc]init];
            nanPeople.name=@"小魏";
            nanPeople.phone=@"18516766821";
            nanPeople.sex=@"男";
            nanPeople.checked=NO;
            [_dataSourceArray addObject:nanPeople];
        }
        for (int i=0; i<5; i++) {
            XWPersonModel *nvPeople=[[XWPersonModel alloc]init];
            nvPeople.name=@"娟娟";
            nvPeople.phone=@"18516772134";
            nvPeople.sex=@"女";
            nvPeople.checked=NO;
            [_dataSourceArray addObject:nvPeople];
        }
     }
    return _dataSourceArray;
}

- (NSMutableArray *)selectedArray{
    if (!_selectedArray) {
        _selectedArray=[NSMutableArray array];
    }
    return _selectedArray;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}




@end
