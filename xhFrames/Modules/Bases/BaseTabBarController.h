//
//  BaseTabBarController.h
//  xianghui
//
//  Created by xianghui on 2018/8/13.
//  Copyright © 2018年 xh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseTabBar.h"

@interface BaseTabBarController : UITabBarController<YWTabBarDelegate>


@property (nonatomic, strong) BaseTabBar *myTabBar;


@property (nonatomic, strong, readonly) UINavigationController *currentNavigationController;

@end
