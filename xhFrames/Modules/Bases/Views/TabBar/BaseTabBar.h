//
//  BaseTabBar.h
//  xianghui
//
//  Created by xianghui on 2018/8/13.
//  Copyright © 2018年 xh. All rights reserved.
//

#import <UIKit/UIKit.h>


@class BaseTabBar;

@protocol YWTabBarDelegate <NSObject>

@optional
- (void)tabBar:(BaseTabBar *)tabBar didSelectIndex:(NSInteger)index;

- (void)tabBar:(BaseTabBar *)tabBar didDoubleSelectIndex:(NSInteger)index;

- (BOOL)tabBar:(BaseTabBar *)tabBar shouldSelectIndex:(NSInteger)index;


- (void)tabBar:(BaseTabBar *)tabBar didSelectJoin:(UIButton *)sender;

@end



@interface BaseTabBar : UITabBar

@property(nonatomic, weak) id<YWTabBarDelegate> myDelegate;

@property (nonatomic, assign) NSInteger selectedIndex;

- (instancetype)initWithDelegate:(id<YWTabBarDelegate>)delegate;

- (void)resetSubViews;

- (void)resetBadge:(BOOL)flag atIndex:(NSInteger)index;

@end
