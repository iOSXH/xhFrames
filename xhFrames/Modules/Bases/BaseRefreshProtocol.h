//
//  BaseRefreshProtocol.h
//  xianghui
//
//  Created by xianghui on 2018/8/15.
//  Copyright © 2018年 xh. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger,RefreshHeaderType) {
    RefreshHeaderTypeNone,       ///< 没有上拉刷新
    RefreshHeaderTypeSystem,     ///< 系统自带上拉刷新
    RefreshHeaderTypeMJ,         ///< MJ上拉刷新效果 app统一的刷新效果
    RefreshHeaderTypeOther       ///< 自定义的上拉刷新效果 适合某一个页面的特殊刷新效果
};

typedef NS_ENUM(NSInteger,RefreshFooterType) {
    RefreshFooterTypeNone,    ///< 没有下拉刷新
    RefreshFooterTypeMJ,      ///< MJ下拉刷新效果 app统一的刷新效果
    RefreshFooterTypeOther    ///< 用户自定义的下拉刷新效果 适合某一个页面的特殊刷新效果
};

typedef NS_ENUM(NSInteger,BaseCellType) {
    BaseCellTypeNone,    ///< 无
    BaseCellTypeTableCell,      ///< tableviewcell
    BaseCellTypeCollectionCell    ///< collectionviewcell
};

typedef void(^successBlock)(NSString *nextId, NSArray *datas);
typedef void(^failureBlock)(id data,NSError *error);

@protocol BaseRefreshProtocol <NSObject>


@optional
//@required
@property (nonatomic, assign) BaseCellType cellType;              ///< cell类型
@property (nonatomic, assign) Class cellClass;                  ///< cell 类

@property (nonatomic, assign) BOOL refreshing;                  ///< 是否正在刷新

@property (nonatomic, strong) NSString *nextId;                 ///< 分页起始点
@property (nonatomic, assign) NSInteger limit;                  ///< 分页大小

@property (nonatomic, strong) NSMutableArray *datas;            ///< 当前页面数据
@property (nonatomic, strong) NSError *error;                   ///< 刷新数据错误

@property (nonatomic, assign) BOOL removeAllDatas;


@property (nonatomic, assign) BOOL appearRefresh;               ///< 页面出现时自动刷新

@property (nonatomic, assign) RefreshHeaderType headerType;   ///< 下拉刷新类型
@property (nonatomic, assign) RefreshFooterType footerType;   ///< 上拉刷新类型

@property (nonatomic, strong) NSString *noneString;

/**
 创建刷新组件
 */
- (void)setupRefresh;


/**
 开始刷新

 @param animated 是否有下拉刷新动画
 */
- (void)startRefreshing:(BOOL)animated;


/**
 刷新当前页面所有数据
 */
- (void)startRefreshAll;


- (void)headerRefresh;



/**
 刷新数据回调

 @param nextId 分页起始
 @param limit 分页大小
 @param success 成功回调
 @param failure 失败回调
 */
- (void)refreshWithNextId:(NSString *)nextId
                    limit:(NSInteger)limit
                  success:(successBlock)success
                  failure:(failureBlock)failure;




/**
 刷新结束回调
 */
- (void)refreshEnd;

@end
