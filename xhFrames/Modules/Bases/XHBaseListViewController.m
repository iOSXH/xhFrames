//
//  XHBaseListViewController.m
//  xianghui
//
//  Created by xianghui on 2018/8/13.
//  Copyright © 2018年 xh. All rights reserved.
//

#import "XHBaseListViewController.h"
#import "XHHttpServiceHeader.h"
#import "XHRefreshHeader.h"

@interface XHBaseListViewController ()<XHBaseCellProtocol>

@property (nonatomic, strong) UIScrollView *contentView;

@property (nonatomic, assign) BOOL flag;

@property (nonatomic, strong) UIRefreshControl *refreshControl;

@end

@implementation XHBaseListViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    
    if (self.cellType == XHCellTypeTableCell) {
        self.contentView = self.tableView;
        
        [self.view addSubview:self.tableView];
        [self.tableView autoPinEdgesToSuperviewEdgesWithInsets:self.contentInsets];
        
        if (self.cellClass && [self.cellClass respondsToSelector:@selector(CellReuseIdentifier)]) {
            [self.tableView registerClass:self.cellClass forCellReuseIdentifier:[self.cellClass CellReuseIdentifier]];
            
            if ([self.cellClass respondsToSelector:@selector(estimatedCellHeight)]) {
                self.tableView.estimatedRowHeight = [self.cellClass estimatedCellHeight];
            }
            if ([self.cellClass respondsToSelector:@selector(CellHeight)]) {
                self.tableView.rowHeight = [self.cellClass CellHeight];
            }
        }
        
        
    }else if (self.cellType == XHCellTypeCollectionCell){
        self.contentView = self.collectionView;
        
        [self.view addSubview:self.collectionView];
        [self.collectionView autoPinEdgesToSuperviewEdgesWithInsets:self.contentInsets];
        
        if (self.cellClass) {
            [self.collectionView registerClass:self.cellClass forCellWithReuseIdentifier:[self.cellClass CellReuseIdentifier]];
        }
    }
//    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self.view sendSubviewToBack:self.contentView];
    self.contentView.emptyDataSetSource = self;
    self.contentView.emptyDataSetDelegate = self;
}


- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    if (self.appearRefresh) {
        if (!self.flag) {
            self.flag = YES;
            return;
        }
        [self startRefreshAll];
    }
    
}


#pragma setter/getter
- (UIEdgeInsets )contentInsets{
    return UIEdgeInsetsZero;
}

- (UITableViewStyle)tableViewStyle{
    return UITableViewStylePlain;
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:self.tableViewStyle];
        [_tableView configureForAutoLayout];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.tableFooterView = [UIView new];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

- (UICollectionViewFlowLayout *)collectionLayout{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    return layout;
}

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:self.collectionLayout];
        [_collectionView configureForAutoLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor clearColor];
    }
    return _collectionView;
}

#pragma mark 父类方法
- (void)refresh{
    [self startRefreshAll];
}

#pragma mark - WWRefreshProtocol
@synthesize cellType = _cellType;
@synthesize cellClass = _cellClass;
@synthesize refreshing = _refreshing;
@synthesize nextId = _nextId;
@synthesize limit = _limit;
@synthesize datas = _datas;
@synthesize error = _error;
@synthesize removeAllDatas = _removeAllDatas;
@synthesize appearRefresh = _appearRefresh;
@synthesize headerType = _headerType;
@synthesize footerType = _footerType;
@synthesize noneString = _noneString;


- (XHCellType)cellType{
    return XHCellTypeTableCell;
}

- (XHHeaderRefreshType)headerType{
    return XHHeaderRefreshTypeMJ;
}

- (XHFooterRefreshType)footerType{
    return XHFooterRefreshTypeMJ;
}

- (NSString *)noneString{
    return @"暂无数据";
}


- (void)setupRefresh{
    
    self.nextId = nil;
    self.limit = 20;
    self.datas = [[NSMutableArray alloc] init];
    
    @weakify(self);
    
    if (self.headerType == XHHeaderRefreshTypeSystem) {
        self.refreshControl = [[UIRefreshControl alloc] init];
        [self.refreshControl addTarget:self action:@selector(headerRefresh) forControlEvents:UIControlEventValueChanged];
        [self.contentView addSubview:self.refreshControl];
    }else if (self.headerType == XHHeaderRefreshTypeMJ){
        XHRefreshHeader *refreshHeader = [XHRefreshHeader headerWithRefreshingBlock:^{
            @strongify(self);
            [self headerRefresh];
        }];
        self.contentView.mj_header = refreshHeader;
    }
    
    if (self.footerType == XHFooterRefreshTypeMJ) {
        
        MJRefreshAutoNormalFooter *refreshFooter = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            @strongify(self);
            [self refreshData];
        }];
        [refreshFooter setTitle:@"" forState:MJRefreshStateNoMoreData];
        refreshFooter.hidden = YES;
        self.contentView.mj_footer = refreshFooter;
    }
}


- (void)headerRefresh{
    self.nextId = nil;
    [self refreshData];
    
}


- (void)startRefreshing:(BOOL)animated{
    if (animated && self.contentView.window) {
        if (self.headerType == XHHeaderRefreshTypeSystem) {
            [self.refreshControl beginRefreshing];
        }else if (self.headerType == XHHeaderRefreshTypeMJ){
            [self.contentView.mj_header beginRefreshing];
        }
    }
    [self headerRefresh];
}

- (void)startRefreshAll{
    NSString *nextId = self.nextId;
    NSInteger limit = self.limit;
    NSInteger dataCnt = self.datas.count;
    if (dataCnt < limit) {
        dataCnt = limit;
    }
    self.nextId = nil;
    self.limit = dataCnt + 1;
    self.removeAllDatas = YES;
    [self refreshData];
    self.nextId = nextId;
    self.limit = limit;
}

- (void)refreshData{
    self.refreshing = YES;
    [self.contentView reloadEmptyDataSet];
    @weakify(self);
    [self refreshWithNextId:self.nextId limit:self.limit success:^(NSString *nextId, NSArray *datas) {
        @strongify(self);
        if (!self.nextId || self.removeAllDatas) {
            [self.datas removeAllObjects];
            self.removeAllDatas = NO;
        }
        if (datas && datas.count > 0) {
            [self.datas addObjectsFromArray:datas];
        }
        
        BOOL hasMore = nextId && ![nextId isEqualToString:@"-1"];
        if (hasMore) {
            self.nextId = nextId;
        }
        [self endRefresh:nil more:hasMore];
        
    } failure:^(id data, NSError *error) {
        
        [self endRefresh:error more:YES];
    }];
}

- (void)endRefresh:(NSError *)error more:(BOOL)more{
    self.error = error;
    self.refreshing = NO;
    if ([self.contentView respondsToSelector:@selector(reloadData)]) {
        [self.contentView performSelector:@selector(reloadData)];
    }
    if (self.headerType == XHHeaderRefreshTypeSystem) {
        if (self.refreshControl.isRefreshing) {
            
            [self.refreshControl endRefreshing];
        }
    }else if (self.headerType == XHHeaderRefreshTypeMJ){
        if (self.contentView.mj_header.isRefreshing) {
            [self.contentView.mj_header endRefreshing];
        }
    }
    
    
    if (self.footerType) {
        if (self.datas.count <= 0) {
            more = NO;
        }
        if (!more) {
            [self.contentView.mj_footer endRefreshingWithNoMoreData];
            self.contentView.mj_footer.hidden = YES;
        }else{
            [self.contentView.mj_footer endRefreshing];
            self.contentView.mj_footer.hidden = NO;
        }
        
    }
    
    [self refreshEnd];
}


- (void)refreshWithNextId:(NSString *)nextId limit:(NSInteger)limit success:(successBlock)success failure:(failureBlock)failure{
    
}

- (void)refreshEnd{
    
}

#pragma mark XHBaseCellDelegate
- (void)baseCell:(id)cell actionWithSender:(id)sender type:(NSInteger)type data:(id)data{
    
}

- (void)baseCell:(id)cell actionWithSender:(id)sender type:(NSInteger)type data:(id)data complete:(completeBlock)complete{
    
}


#pragma mark DZNEmptyDataSetSource
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *text = self.error?errorMsg(self.error, @"点击重试"):self.noneString;
    if (self.refreshing) {
        text = @"加载中...";
    }
    
    UIColor *color = [TXSakuraManager tx_colorWithPath:self.error?kThemeKey_TXC02:kThemeKey_TXC04];
    
    NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:sizeScale(self.error?17:15, YES)], NSForegroundColorAttributeName: color};
    return [[NSAttributedString alloc] initWithString:text attributes:attribute];
}


- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView{
    if (self.refreshing) {
        return nil;
    }
    return self.error?kImageNamed(@"icon_common_nowifi"):kImageNamed(@"icon_common_none");
}


- (CGFloat)spaceHeightForEmptyDataSet:(UIScrollView *)scrollView{
    return sizeScale(self.error?28:16, YES);
}

- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView{
    return -kNavigationBarHeight;
}

#pragma mark DZNEmptyDataSetDelegate
- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView{
    return YES;
}

- (void)emptyDataSet:(UIScrollView *)scrollView didTapView:(UIView *)view{
    if (self.refreshing) {
        return;
    }
    [self startRefreshing:YES];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datas.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    XHBaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[self.cellClass CellReuseIdentifier]];
    cell.baseDelegate = self;
    cell.indexPath = indexPath;
    id data = [self.datas objectAtIndex:indexPath.row];
    [cell updateViewWithModel:data];
    return cell;
}



#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    //#warning Incomplete implementation, return the number of sections
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    //#warning Incomplete implementation, return the number of items
    return self.datas.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    XHBaseCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[self.cellClass CellReuseIdentifier] forIndexPath:indexPath];
    id data = [self.datas objectAtIndex:indexPath.row];
    
    [cell updateViewWithModel:data];
    
    return cell;
}


- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    if (!self.datas || self.datas.count == 0) {
        return UIEdgeInsetsZero;
    }
    
    return [self.cellClass ItemInsets];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return [self.cellClass ItemSize];
}

//两行cell之间的最小间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return [self.cellClass ItemMinLineSpacing];
}

//两个cell之间的最小间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return [self.cellClass ItemMinInterSpacing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
