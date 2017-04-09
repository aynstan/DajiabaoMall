//
//  GetPeopleController.m
//  DaJiaBaoMall
//
//  Created by 大家保 on 2017/4/1.
//  Copyright © 2017年 大家保. All rights reserved.
//

#import "GetPeopleController.h"
#import "MXPullDownMenu.h"
#import "JSDropDownMenu.h"
#import "GetPeopleCell.h"
#import "XW_AddressManager.h"
#import "XWPersonModel.h"

@interface GetPeopleController ()<JSDropDownMenuDataSource,JSDropDownMenuDelegate,UITableViewDelegate,UITableViewDataSource,GetPeopleCell_Delegate>{
    //下拉框数据源
    NSMutableArray *_data1;
    NSMutableArray *_data2;
    NSMutableArray *_data3;
    //下拉框选中的index
    NSInteger _currentData1Index;
    NSInteger _currentData2Index;
    NSInteger _currentData3Index;
    NSInteger _currentData1SelectedIndex;
    //下拉控件
    JSDropDownMenu *menu;
    //全选
    UIButton *allSlected;
    //导入
    UIButton *daoruButton;
    //清除
    UIButton *clearButton;
    //选中的城市
    NSString *city;
    //选中的性别
    NSString *sex;
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
    city= [[_data1[_currentData1Index] objectForKey:@"data"] objectAtIndex:_currentData1SelectedIndex];
    sex= _data2[_currentData2Index];
    NSLog(@"选中的城市=%@,选中的性别=%@",city,sex);
    [self.myTableView.mj_header beginRefreshing];
}

//界面初始化
- (void)initUI{
    //头部
    UIView *headView=[[UIView alloc]initWithFrame:CGRectMake(0, 10, SCREEN_WIDTH, 44)];
    headView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:headView];
    //获客剩余人数
    UILabel *show=[[UILabel alloc]initWithFrame:CGRectMake(12, 0, SCREEN_WIDTH, 44)];
    show.text=@"您的获客剩余名额为：10人";
    show.font=font13;
    show.textColor=[UIColor darkGrayColor];
    [headView addSubview:show];
    //分割线
    UILabel *line=[[UILabel alloc]initWithFrame:CGRectMake(0, headView.y+headView.height, SCREEN_WIDTH, 0.5)];
    line.backgroundColor=RGB(231, 231, 232);
    [self.view addSubview:line];
    //下拉框
    [self initDropDown:CGPointMake(0, line.y+line.height)];
    //全选按钮
    allSlected=[[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-56, 0, 56, 44)];
    [allSlected addTarget:self action:@selector(selectAll:) forControlEvents:UIControlEventTouchUpInside];
    [allSlected setImage:[UIImage imageNamed:@"unclick"] forState:0];
    [allSlected setImage:[UIImage imageNamed:@"click"] forState:UIControlStateSelected];
    [menu addSubview:allSlected];
    //tableview
    [self.myTableView setHidden:NO];
    //底部视图
    UIView *bottomView=[[UIView alloc]init];
    bottomView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:bottomView];
    bottomView.sd_layout.leftSpaceToView(self.view,0).rightSpaceToView(self.view,0).bottomSpaceToView(self.view,0).heightIs(50);
    //底部视图分割线
    UILabel *bottomLine=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
    bottomLine.backgroundColor=RGB(231, 231, 232);
    [bottomView addSubview:bottomLine];
    //清楚按钮
    clearButton=[[UIButton alloc]initWithFrame:CGRectMake(0, 0.5, SCREEN_WIDTH*2/5.0, 49.5)];
    [clearButton setTitle:[NSString stringWithFormat:@"清除已倒入的号码(%d)",[[JQFMDB shareDatabase] jq_tableItemCount:@"contact"]] forState:0];
    [clearButton addTarget:self action:@selector(clearAll:) forControlEvents:UIControlEventTouchUpInside];
    [clearButton setTitleColor:[UIColor darkGrayColor] forState:0];
    [clearButton.titleLabel setFont:font14];
    [bottomView addSubview:clearButton];
    //导入按钮
    daoruButton=[[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH*2/5.0, 0.5, SCREEN_WIDTH*3/5.0, 49.5)];
    [daoruButton setTitle:@"立即获客（0人）" forState:0];
    [daoruButton addTarget:self action:@selector(daoru:) forControlEvents:UIControlEventTouchUpInside];
    [daoruButton setTitleColor:[UIColor darkGrayColor] forState:0];
    [daoruButton.titleLabel setFont:font14];
    [daoruButton setBackgroundColor:[UIColor orangeColor]];
    [bottomView addSubview:daoruButton];
}

//下拉框
- (void)initDropDown:(CGPoint)point{
    // 指定默认选中
    _currentData1Index = 0;
    _currentData1SelectedIndex = 0;
    //省市数据源
    NSString *path = [[NSBundle mainBundle] pathForResource:@"area" ofType:@"plist"];
    NSArray  *_arrayRoot = [[NSArray alloc]initWithContentsOfFile:path];
    NSMutableArray *privice =[NSMutableArray array];
    NSMutableArray *shi=[NSMutableArray array];
    for (NSDictionary * dic in _arrayRoot) {
        [privice addObject:dic[@"state"]];
        NSArray *shiArray=dic[@"cities"];
        NSMutableArray *cityArr=[NSMutableArray array];
        for (NSDictionary *shiDic in shiArray) {
            [cityArr addObject:shiDic[@"city"]];
        }
        [shi addObject:cityArr];
    }
    _data1=[[NSMutableArray alloc]initWithObjects:@{@"title":@"不限", @"data":@[@"全国"]}, nil];
    for (int i=0;i<privice.count;i++) {
        NSMutableDictionary *dic=[[NSMutableDictionary alloc]init];
        [dic setValue:privice[i] forKey:@"title"];
        [dic setValue:shi[i] forKey:@"data"];
        [_data1 addObject:dic];
    }
    _data2 = [NSMutableArray arrayWithObjects:@"不限", @"男", @"女", nil];
    _data3 = [NSMutableArray array];
    //下拉控件
    menu = [[JSDropDownMenu alloc] initWithOrigin:point andHeight:44 inView:self.view];
    menu.indicatorColor = RGB(83, 83, 83);
    menu.separatorColor = RGB(231, 231, 232);
    menu.textColor =RGB(83, 83, 83);
    menu.dataSource = self;
    menu.delegate = self;
    [self.view addSubview:menu];
}

//清除已导入的
- (void)clearAll:(UIButton *)sender{
    int count=[[JQFMDB shareDatabase] jq_tableItemCount:@"contact"];
    if (count==0) {
        [MBProgressHUD ToastInformation:@"暂无要清除的号码"];
        return;
    }
    [XW_AddressManager deletePersonArray:self.selectedArray SuccessBlock:^{
        [clearButton setTitle:[NSString stringWithFormat:@"清除已倒入的号码(%d)",[[JQFMDB shareDatabase] jq_tableItemCount:@"contact"]] forState:0];
        [[JQFMDB shareDatabase] close];
    } FaildBlcok:^{
        [clearButton setTitle:[NSString stringWithFormat:@"清除已倒入的号码(%d)",[[JQFMDB shareDatabase] jq_tableItemCount:@"contact"]] forState:0];
        [[JQFMDB shareDatabase] close];
    }];
}



//导入
- (void)daoru:(UIButton *)sender{
    if (self.selectedArray.count==0) {
        [MBProgressHUD ToastInformation:@"请先选择要导入的号码"];
        return;
    }
    [XW_AddressManager addPersonArray:self.selectedArray SuccessBlock:^{
        [clearButton setTitle:[NSString stringWithFormat:@"清除已倒入的号码(%d)",[[JQFMDB shareDatabase] jq_tableItemCount:@"contact"]] forState:0];
        [[JQFMDB shareDatabase] close];
    } FaildBlcok:^{
        [clearButton setTitle:[NSString stringWithFormat:@"清除已倒入的号码(%d)",[[JQFMDB shareDatabase] jq_tableItemCount:@"contact"]] forState:0];
        [[JQFMDB shareDatabase] close];
     }];
}



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
    
    [daoruButton setTitle:[NSString stringWithFormat:@"立即获客（%ld人）",(unsigned long)self.selectedArray.count] forState:0];
};

//全选
- (void)selectAll:(UIButton *)sender{
    sender.selected=!sender.selected;
    //隐藏背景
    [menu dissmissBG];
    
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
    [daoruButton setTitle:[NSString stringWithFormat:@"立即获客（%ld人）",(unsigned long)self.selectedArray.count] forState:0];
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
        
        XWPersonModel *nanPeople=[[XWPersonModel alloc]init];
        nanPeople.name=@"小魏";
        nanPeople.mobilephone=@"18516766820";
        nanPeople.sex=1;
        nanPeople.checked=NO;
        nanPeople.tokenId=[UserDefaults objectForKey:TOKENID];
        [_dataSourceArray addObject:nanPeople];
        
        
        XWPersonModel *nvPeople=[[XWPersonModel alloc]init];
        nvPeople.name=@"小娟";
        nvPeople.mobilephone=@"18516772134";
        nvPeople.sex=0;
        nvPeople.checked=NO;
        nvPeople.tokenId=[UserDefaults objectForKey:TOKENID];
        [_dataSourceArray addObject:nvPeople];
        
     }
    
    return _dataSourceArray;
}

- (NSMutableArray *)selectedArray{
    if (!_selectedArray) {
        _selectedArray=[NSMutableArray array];
    }
    return _selectedArray;
}

#pragma mark 下拉框的代理和数据源
- (NSInteger)numberOfColumnsInMenu:(JSDropDownMenu *)menu {
    return 3;
}

-(BOOL)displayByCollectionViewInColumn:(NSInteger)column{
    if (column==2) {
        return YES;
    }
    return NO;
}

-(BOOL)haveRightTableViewInColumn:(NSInteger)column{
    if (column==0) {
        return YES;
    }
    return NO;
}

-(CGFloat)widthRatioOfLeftColumn:(NSInteger)column{
    if (column==0) {
        return 1/3.0;
    }
    return 1;
}

-(NSInteger)currentLeftSelectedRow:(NSInteger)column{
    if (column==0) {
        return _currentData1Index;
    }
    if (column==1) {
        return _currentData2Index;
    }
    return 0;
}

- (NSInteger)menu:(JSDropDownMenu *)menu numberOfRowsInColumn:(NSInteger)column leftOrRight:(NSInteger)leftOrRight leftRow:(NSInteger)leftRow{
    if (column==0) {
        if (leftOrRight==0) {
            return _data1.count;
        } else{
            NSDictionary *menuDic = [_data1 objectAtIndex:leftRow];
            return [[menuDic objectForKey:@"data"] count];
        }
    } else if (column==1){
        return _data2.count;
    } else if (column==2){
        return _data3.count;
    }
    return 0;
}

- (NSString *)menu:(JSDropDownMenu *)menu titleForColumn:(NSInteger)column{
    switch (column) {
        case 0: return [[_data1[_currentData1Index] objectForKey:@"data"] objectAtIndex:_currentData1SelectedIndex];
            break;
        case 1: return _data2[_currentData2Index];
            break;
        case 2: //return _data3[_currentData3Index];
            return @"";
            break;
        default:
            return nil;
            break;
    }
}

- (NSString *)menu:(JSDropDownMenu *)menu titleForRowAtIndexPath:(JSIndexPath *)indexPath {
    if (indexPath.column==0) {
        if (indexPath.leftOrRight==0) {
            NSDictionary *menuDic = [_data1 objectAtIndex:indexPath.row];
            return [menuDic objectForKey:@"title"];
        } else{
            NSInteger leftRow = indexPath.leftRow;
            NSDictionary *menuDic = [_data1 objectAtIndex:leftRow];
            return [[menuDic objectForKey:@"data"] objectAtIndex:indexPath.row];
        }
    } else if (indexPath.column==1) {
        return _data2[indexPath.row];
    } else {
       // return _data3[indexPath.row];
        return @"";
    }
}

- (void)menu:(JSDropDownMenu *)menu didSelectRowAtIndexPath:(JSIndexPath *)indexPath {
    if (indexPath.column == 0) {
        if(indexPath.leftOrRight==0){
            _currentData1Index = indexPath.row;
            return;
        }else if(indexPath.leftOrRight==1){
            _currentData1SelectedIndex=indexPath.row;
        }
    } else if(indexPath.column == 1){
        _currentData2Index = indexPath.row;
    } else{
        _currentData3Index = indexPath.row;
    }
    [self menuDidChange];
}

#pragma mark 下拉框变化
- (void)menuDidChange{
   city= [[_data1[_currentData1Index] objectForKey:@"data"] objectAtIndex:_currentData1SelectedIndex];
   sex= _data2[_currentData2Index];
    NSLog(@"选中的城市=%@,选中的性别=%@",city,sex);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}




@end
