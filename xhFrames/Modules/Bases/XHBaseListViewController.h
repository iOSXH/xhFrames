//
//  XHBaseListViewController.h
//  xianghui
//
//  Created by xianghui on 2018/8/13.
//  Copyright © 2018年 xh. All rights reserved.
//

#import "XHBaseViewController.h"
#import "XHRefreshProtocol.h"
#import "XHBaseTableViewCell.h"
#import "XHBaseCollectionViewCell.h"

@interface XHBaseListViewController : XHBaseViewController<DZNEmptyDataSetSource, DZNEmptyDataSetDelegate, YWRefreshProtocol, XHBaseCellDelegate,
UITableViewDelegate, UITableViewDataSource,
UICollectionViewDelegate, UICollectionViewDataSource>


@property (nonatomic, assign) UIEdgeInsets contentInsets; ///< 内边距

#pragma mark UITableView
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) UITableViewStyle tableViewStyle;


#pragma mark UICollectionView
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *collectionLayout;

@end
