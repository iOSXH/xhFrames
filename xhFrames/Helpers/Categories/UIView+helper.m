//
//  UIView+helper.m
//  xianghui
//
//  Created by xianghui on 2018/8/16.
//  Copyright © 2018年  xh. All rights reserved.
//

#import "UIView+helper.h"

@implementation UIView (helper)

- (void)startLoading{
    UIView *loadingView = [UIView newAutoLayoutView];
    loadingView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.6];
    loadingView.tag = 54321;
    [self addSubview:loadingView];
    [loadingView autoPinEdgesToSuperviewEdges];
    
    UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [indicatorView configureForAutoLayout];
    [loadingView addSubview:indicatorView];
    [indicatorView autoCenterInSuperview];
    
    [indicatorView startAnimating];
    
    self.userInteractionEnabled = NO;
}


- (void)stopLoading{
    UIView *loadingView = [self viewWithTag:54321];
    [loadingView removeFromSuperview];
    self.userInteractionEnabled = YES;
}


- (BOOL)isLoading{
    UIView *loadingView = [self viewWithTag:54321];
    if (loadingView) {
        return YES;
    }
    return NO;
}


- (void)addRoundedCornerWithRadius:(CGFloat)radius corners:(UIRectCorner)corners{
    self.layer.mask = nil;
    if (radius > 0) {
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:corners cornerRadii:CGSizeMake(radius, radius)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = self.bounds;
        maskLayer.path = path.CGPath;
        self.layer.mask = maskLayer;
    }
}



+ (UIView *)lineLayoutView{
    UIView *line = [UIView newAutoLayoutView];
    line.sakura.backgroundColor(kThemeKey_BGCLine);
    return line;
}

@end
