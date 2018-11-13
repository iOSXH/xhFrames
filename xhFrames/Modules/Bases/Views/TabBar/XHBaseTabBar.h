//
//  XHBaseTabBar.h
//  xianghui
//
//  Created by xianghui on 2018/8/13.
//  Copyright © 2018年 xh. All rights reserved.
//

#import <UIKit/UIKit.h>


@class XHBaseTabBar;

@protocol YWTabBarDelegate <NSObject>

@optional
- (void)tabBar:(XHBaseTabBar *)tabBar didSelectIndex:(NSInteger)index;

- (void)tabBar:(XHBaseTabBar *)tabBar didDoubleSelectIndex:(NSInteger)index;

- (BOOL)tabBar:(XHBaseTabBar *)tabBar shouldSelectIndex:(NSInteger)index;


- (void)tabBar:(XHBaseTabBar *)tabBar didSelectJoin:(UIButton *)sender;

@end



@interface XHBaseTabBar : UITabBar

@property(nonatomic, weak) id<YWTabBarDelegate> myDelegate;

@property (nonatomic, assign) NSInteger selectedIndex;


- (void)resetSubViews;

- (void)resetBadge:(BOOL)flag atIndex:(NSInteger)index;

@end
