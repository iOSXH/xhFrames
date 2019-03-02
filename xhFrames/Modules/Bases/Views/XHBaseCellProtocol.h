//
//  XHBaseCellProtocol.h
//  xianghui
//
//  Created by xianghui on 2018/8/15.
//  Copyright © 2018年 xh. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^completeBlock)(id data, NSError *error);

@protocol XHBaseCellDelegate <NSObject>

@optional
- (void)baseCell:(id)cell actionWithSender:(id)sender type:(NSInteger)type data:(id)data;

- (void)baseCell:(id)cell actionWithSender:(id)sender type:(NSInteger)type data:(id)data complete:(completeBlock)complete;

@end


@protocol XHBaseCellProtocol <NSObject>


@optional

#pragma mark 通用
@property (nonatomic, weak) id<XHBaseCellDelegate> baseDelegate;  ///< 代理
@property (nonatomic, strong) NSIndexPath *indexPath;             ///< 位置信息

@property (nonatomic, strong) NSArray *colorViews;         ///< cell高亮或点击状态时需要保持背景颜色的views

/**
 初始化子视图
 */
- (void)initSubViews;


/**
 更新界面 数据显示

 @param model 数据对象
 */
- (void)updateViewWithModel:(id)model;


/**
 cell重用标识

 @return 标识
 */
+ (NSString *)CellReuseIdentifier;

#pragma mark UITableViewCell

/**
 cell高度

 @return 高度
 */
+ (CGFloat)CellHeight;


/**
 cell动态预估高度

 @return 高度
 */
+ (CGFloat)estimatedCellHeight;


#pragma mark UITableViewHeaderFooterView

/**
 头部/尾部高度

 @return 高度
 */
+ (CGFloat)HeaderFooterHeight;


#pragma mark UICollectionViewCell

/**
 内边距

 @return insert
 */
+ (UIEdgeInsets)ItemInsets;


/**
 行间距

 @return 高度
 */
+ (CGFloat)ItemMinLineSpacing;


/**
 列间距

 @return 高度
 */
+ (CGFloat)ItemMinInterSpacing;


/**
 大小

 @return size
 */
+ (CGSize)ItemSize;

@end


