//
//  XHBaseViewController.h
//  xianghui
//
//  Created by xianghui on 2018/8/13.
//  Copyright © 2018年 xh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XHBaseViewController : UIViewController


@property (nonatomic, assign) BOOL mainVc;///< 主tabbarview
@property (nonatomic, assign) BOOL disableSwipBack;///< 禁止侧滑返回
@property (nonatomic, assign) BOOL navBarHidden; ///< 导航栏隐藏

@property (nonatomic, strong) NSString *navTitleThemeColorKey; ///< 导航栏标题颜色key
@property (nonatomic, strong) NSString *navBgThemeColorKey; ///< 导航栏背景颜色key nil时透明
@property (nonatomic, strong) NSString *navItemColorKey; ///< 导航栏左右按钮颜色key


@property (nonatomic, assign) BOOL disableUMPageLog; ///< 禁止友盟页面统计


/// 页面第一次调用didAppear时回调
@property(nonatomic, copy) void (^ViewFirstAppearBlock)();


/**
 设置导航栏左右按钮
 
 @param title 标题
 @param imageName 图片名
 @param left 位置
 */
- (void)addBarItemWithTitle:(NSString *)title imageName:(NSString *)imageName isLeft:(BOOL)left;


/**
 导航栏左边按钮点击事件  子类继承  默认pop
 
 @param sender sender
 */
- (void)leftItemDidClicked:(id)sender;


/**
 导航栏右边按钮点击事件  子类继承
 
 @param sender sender
 */
- (void)rightItemDidClicked:(id)sender;


- (void)refresh;

- (BOOL)isEqualToVc:(XHBaseViewController *)vc;

@end
