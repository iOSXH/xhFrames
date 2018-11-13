//
//  MineViewController.m
//  sentiment
//
//  Created by xianghui on 2018/10/25.
//  Copyright © 2018 xianghui. All rights reserved.
//

#import "MineViewController.h"
#import "SettingTableViewCell.h"

@interface MineViewController ()

@property (nonatomic, strong) UIImageView *coverImgView;

@property (nonatomic, strong) UIImageView *avatarImgView;
@property (nonatomic, strong) UILabel *nicknameLab;
@property (nonatomic, strong) UILabel *joinLab;

@end

@implementation MineViewController

- (NSString *)navBgThemeColorKey{
    return nil;
}

- (UITableViewStyle)tableViewStyle{
    return UITableViewStyleGrouped;
}

- (XHHeaderRefreshType)headerType{
    return XHHeaderRefreshTypeNone;
}

- (Class)cellClass{
    return [SettingTableViewCell class];
}


- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.sakura.backgroundColor(kThemeKey_BGC06);
    self.appearRefresh = YES;
    [self setupRefresh];
    [self setupHeader];
    
    [self startRefreshing:NO];
}

- (void)setupHeader{
    
    self.tableView.showsVerticalScrollIndicator = NO;
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }else{
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, IS_IPHONE_X?141:117)];
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:bgView.bounds];
    imgView.image = IS_IPHONE_X?kImageNamed(@"icon_mine_top_bgx"):kImageNamed(@"icon_mine_top_bg");
    [bgView addSubview:imgView];
    self.coverImgView = imgView;
    
    
    self.avatarImgView = [UIImageView newAutoLayoutView];
    self.avatarImgView.clipsToBounds = YES;
    self.avatarImgView.contentMode = UIViewContentModeScaleAspectFill;
    self.avatarImgView.layer.masksToBounds = YES;
    self.avatarImgView.layer.cornerRadius = 25;
    [bgView addSubview:self.avatarImgView];
    [self.avatarImgView autoSetDimensionsToSize:CGSizeMake(50, 50)];
    [self.avatarImgView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:22];
    [self.avatarImgView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:sizeScale(15, YES)];
    
    self.nicknameLab = [UILabel newAutoLayoutView];
    self.nicknameLab.sakura.textColor(kThemeKey_TXC01);
    self.nicknameLab.font = [UIFont boldSystemFontOfSize:18];
    self.nicknameLab.textAlignment = NSTextAlignmentLeft;
    [bgView addSubview:self.nicknameLab];
    [self.nicknameLab autoSetDimension:ALDimensionHeight toSize:25];
    [self.nicknameLab autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.avatarImgView withOffset:2];
    [self.nicknameLab autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.avatarImgView withOffset:10];
    [self.nicknameLab autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:sizeScale(15, YES)];
    
    self.joinLab = [UILabel newAutoLayoutView];
    self.joinLab.sakura.textColor(kThemeKey_TXC01);
    self.joinLab.font = [UIFont systemFontOfSize:13];
    self.joinLab.textAlignment = NSTextAlignmentLeft;
    [bgView addSubview:self.joinLab];
    [self.joinLab autoSetDimension:ALDimensionHeight toSize:18];
    [self.joinLab autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.nicknameLab withOffset:2];
    [self.joinLab autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.avatarImgView withOffset:10];
    [self.joinLab autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:sizeScale(15, YES)];
    
    self.tableView.tableHeaderView = bgView;
}


#pragma mark UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    CGFloat offsetY = scrollView.contentOffset.y;
    
    CGFloat scale = 1;
    CGFloat viewY = 0;
    CGFloat coententHeight = IS_IPHONE_X?141:117;
    if (offsetY < 0) {
        scale = (coententHeight - offsetY)/(coententHeight);
        viewY = offsetY;
    }
    
    self.coverImgView.top = viewY;
    self.coverImgView.transform = CGAffineTransformMakeScale(scale, scale);
    
}

#pragma mark UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.datas.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *ary = [self.datas objectAtIndex:section];
    return ary.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [[UIView alloc] init];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, sizeScale(7, YES))];
    footer.sakura.backgroundColor(kThemeKey_BGC06);
    return footer;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return sizeScale(7, YES);
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [SettingTableViewCell CellHeight];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *ary = [self.datas objectAtIndex:indexPath.section];
    XHBaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[self.cellClass CellReuseIdentifier]];
    cell.baseDelegate = self;
    cell.indexPath = indexPath;
    id data = [ary objectAtIndex:indexPath.row];
    [cell updateViewWithModel:data];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSArray *ary = [self.datas objectAtIndex:indexPath.section];
    NSDictionary *data = [ary objectAtIndex:indexPath.row];
    NSURL *url = [data objectForKey:@"url"];
    if (url) {
        
        if ([url.path containsString:kURLRouter_ClearCache]) {
            [URLRouter routerUrlWithUrl:url extra:nil fromNav:self.navigationController complete:^(id result, NSError *error) {
                [self startRefreshing:NO];
            }];
            
            [AppTrackHelper event:kTrackAccountClearCacheClicked attributes:nil];
            
        }else{
            [URLRouter routerUrlWithURL:url];
            
            if ([url.path containsString:kURLRouter_Logout]) {
                [AppTrackHelper event:kTrackAccountLogoutClicked attributes:nil];
            }
        }
        
    }
}


#pragma mark refresh Protocol
- (void)refreshWithNextId:(NSString *)nextId limit:(NSInteger)limit success:(successBlock)success failure:(failureBlock)failure{
    
    UserModel *user = [AccountManager sharedManager].account.User;
    
    self.nicknameLab.text = user.nickName;
    self.joinLab.text = [NSString stringWithFormat:@"%@ 加入%@", [user.createTime stringWithFormat:@"yyyy-MM-dd"], APPName];
    [self.avatarImgView sd_setImageWithURL:[NSURL URLWithString:user.avatar]];
    
    
    CGFloat  size =  [[SDImageCache sharedImageCache] getSize];
    CGFloat totalSize = size/1024.0/1024.0;
    NSString *cacheSize = [NSString stringWithFormat:@"%.2fMB", totalSize];
    
    
    NSArray *arrays = @[
                        @[
                            @{@"leftTitle":@"清除缓存",
                              @"rightTitle":cacheSize,
                              @"url":[URLRouter urlRouterWithPath:kURLRouter_ClearCache]
                              },
//                            @{@"leftTitle":@"推荐APP给好友",
//                              @"url":[URLRouter urlRouterWithPath:kURLRouter_AppShare]
//                              },
                            @{@"leftTitle":@"声明条款",
                              @"url":[NSURL URLWithString:kUserAgreementURL]
                              },
                            @{@"leftTitle":@"版本",
                              @"rightTitle":getString(APPVersion),
                              @"hideRight":@(YES)
                              }],
                        @[
                            @{@"centerTitle":@"退出登录",
                              @"hideRight":@(YES),
                              @"url":[URLRouter urlRouterWithPath:kURLRouter_Logout]
                              }],
                        ];
    
    if (success) {
        success(nil, arrays);
    }
    
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
