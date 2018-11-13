//
//  XHRefreshHeader.m
//  xianghui
//
//  Created by xianghui on 2018/10/23.
//  Copyright © 2018 xianghui. All rights reserved.
//

#import "XHRefreshHeader.h"
#import <lottie-ios/Lottie/Lottie.h>

@interface XHRefreshHeader ()

@property (nonatomic, strong) UIView *topBgView;
@property (nonatomic, strong) LOTAnimationView *refreshPullView;
@property (nonatomic, strong) LOTAnimationView *refreshView;
@property (nonatomic, strong) UILabel *refreshLab;

@end

@implementation XHRefreshHeader

#pragma mark - 重写方法
#pragma mark 在这里做一些初始化配置（比如添加子控件）
- (void)prepare
{
    [super prepare];
    
    self.mj_h = 50;
    
    self.sakura.backgroundColor(kThemeKey_BGC03);
    
    self.topBgView = [[UIView alloc] init];
    self.topBgView.sakura.backgroundColor(kThemeKey_BGC03);
    [self addSubview:self.topBgView];
    
    self.refreshView = [LOTAnimationView animationNamed:@"refresh"];
    self.refreshView.loopAnimation = YES;
    [self addSubview:self.refreshView];
    
    self.refreshPullView = [LOTAnimationView animationNamed:@"refresh_pull"];
    [self addSubview:self.refreshPullView];
    
    self.refreshLab = [[UILabel alloc] init];
    self.refreshLab.sakura.textColor(kThemeKey_TXC07);
    self.refreshLab.font = [UIFont systemFontOfSize:11];
    self.refreshLab.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.refreshLab];
}


#pragma mark 在这里设置子控件的位置和尺寸
- (void)placeSubviews
{
    [super placeSubviews];
    
    self.refreshView.frame = self.refreshPullView.frame = CGRectMake(SCREEN_WIDTH/2 - 25/2, 8, 25, 25);
    
    self.refreshLab.frame = CGRectMake(0, 34, SCREEN_WIDTH, 16);
}


#pragma mark 监听scrollView的contentOffset改变
- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change
{
    [super scrollViewContentOffsetDidChange:change];
    
    
    CGFloat dif = -self.scrollView.mj_offsetY - self.mj_h;
    if (dif < 0) {
        dif = 0;
    }
    self.topBgView.frame = CGRectMake(0, -dif, self.mj_w, dif);
}

#pragma mark 监听scrollView的contentSize改变
- (void)scrollViewContentSizeDidChange:(NSDictionary *)change
{
    [super scrollViewContentSizeDidChange:change];
    
}

#pragma mark 监听scrollView的拖拽状态改变
- (void)scrollViewPanStateDidChange:(NSDictionary *)change
{
    [super scrollViewPanStateDidChange:change];
    
}

#pragma mark 监听控件的刷新状态
- (void)setState:(MJRefreshState)state
{
    MJRefreshCheckState;
    
    
    switch (state) {
        case MJRefreshStateIdle:{
            self.refreshPullView.hidden = NO;
            self.refreshView.hidden = YES;
            if (self.refreshView.isAnimationPlaying) {
                [self.refreshView stop];
            }
            self.refreshLab.text = @"下拉刷新";
        }
            break;
        case MJRefreshStatePulling:{
            self.refreshPullView.hidden = YES;
            self.refreshView.hidden = NO;
            if (!self.refreshView.isAnimationPlaying) {
                [self.refreshView play];
            }
            self.refreshLab.text = @"松开刷新";
        }
            break;
        case MJRefreshStateRefreshing:{
            self.refreshPullView.hidden = YES;
            if (self.refreshPullView.isAnimationPlaying) {
                [self.refreshPullView stop];
            }
            self.refreshView.hidden = NO;
            if (!self.refreshView.isAnimationPlaying) {
                [self.refreshView play];
            }
            self.refreshLab.text = @"刷新中...";
        }
            break;
        default:
            break;
    }
}



#pragma mark 监听拖拽比例（控件被拖出来的比例）
- (void)setPullingPercent:(CGFloat)pullingPercent
{
    [super setPullingPercent:pullingPercent];
    
    // 1.0 0.5 0.0
    // 0.5 0.0 0.5
    
    if (!self.refreshPullView.hidden) {
        
        CGFloat progress = pullingPercent;
        if (progress < 0) {
            progress = 0;
        }else if (progress > 1){
            progress = 1;
        }
        
        [self.refreshPullView setAnimationProgress:progress];
    }
}

@end
