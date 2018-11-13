//
//  UIView+helper.h
//  xianghui
//
//  Created by xianghui on 2018/8/16.
//  Copyright © 2018年  xh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (helper)

- (void)startLoading;
- (void)stopLoading;
- (BOOL)isLoading;



/**
 给view绘制圆角
 适用于view的frame已经确定的情况下
 @param radius 圆角半径
 @param corners 圆角
 */
- (void)addRoundedCornerWithRadius:(CGFloat)radius corners:(UIRectCorner)corners;


+ (UIView *)lineLayoutView;

@end
