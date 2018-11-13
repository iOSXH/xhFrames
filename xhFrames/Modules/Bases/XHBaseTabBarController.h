//
//  XHBaseTabBarController.h
//  xianghui
//
//  Created by xianghui on 2018/8/13.
//  Copyright © 2018年 xh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XHBaseTabBar.h"

@interface XHBaseTabBarController : UITabBarController<YWTabBarDelegate>


@property (nonatomic, strong) XHBaseTabBar *myTabBar;


@property (nonatomic, strong, readonly) UINavigationController *currentNavigationController;

@end
