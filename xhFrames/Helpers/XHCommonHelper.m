//
//  XHCommonHelper.m
//  xianghui
//
//  Created by xianghui on 2018/8/13.
//  Copyright © 2018年 xh. All rights reserved.
//

#import "XHCommonHelper.h"
#import "XHHttpServiceHeader.h"
#import <lottie-ios/Lottie/Lottie.h>
#import "XHBaseNavView.h"

@implementation XHCommonHelper

@end


@implementation ToastHelper

+ (void)showToastHUD:(NSString *)msg{
    
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    MBProgressHUD *hub = [MBProgressHUD showHUDAddedTo:window animated:YES];
    hub.mode = MBProgressHUDModeText;
    hub.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hub.bezelView.color = [[UIColor blackColor] colorWithAlphaComponent:0.6];
    hub.bezelView.layer.cornerRadius = 8;
    hub.label.textColor = [UIColor whiteColor];
    hub.label.numberOfLines = 0;
    hub.label.textAlignment = NSTextAlignmentLeft;
    hub.label.font = [UIFont systemFontOfSize:15];
    hub.label.text = msg;
//    hub.userInteractionEnabled = NO;
    [hub hideAnimated:YES afterDelay:3.0];
    
    [hub bk_whenTapped:^{
        [hub hideAnimated:YES];
    }];
}

+ (void)showMessage:(NSString *)msg{
    if (emptyString(msg)) {
        return;
    }
    [self showToastHUD:msg];
}

+ (void)showSuccess:(NSString *)msg{
    
    if (emptyString(msg)) {
        return;
    }
    [self showToastHUD:msg];
}

+ (void)showError:(NSError *)error defaultMsg:(NSString *)defaultMsg{
    NSString *msg = errorMsg(error, defaultMsg);
    if (emptyString(msg)) {
        return;
    }
    [self showToastHUD:msg];
}

@end

@interface  HUDHelper ()

@property (nonatomic, strong) NSMutableDictionary *hudsDic;

@end

@implementation HUDHelper

IMPLEMENT_SINGLETON(HUDHelper, sharedHelper)

- (instancetype)init{
    self = [super init];
    if (self) {
        [UIActivityIndicatorView appearanceWhenContainedIn:[MBProgressHUD class], nil].color = [UIColor whiteColor];
        self.hudsDic = [[NSMutableDictionary alloc] init];
    }
    return self;
}

+ (NSString *)randomTag{
    NSString *tag = [NSString randomStringWithLength:4];
    NSMutableDictionary *hudsDic = [HUDHelper sharedHelper].hudsDic;
    if (hudsDic && hudsDic.count > 0) {
        if ([hudsDic.allKeys containsObject:tag]) {
            tag = [self randomTag];
        }
    }
    
    return tag;
}


+ (NSString *)showLoadingWithText:(NSString *)text inView:(UIView *)view{
    NSString *tag = [self randomTag];
    
    if (!view) {
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        view = window;
    }
    
    
    XHBaseNavView *customView = [[XHBaseNavView alloc] initWithFrame:CGRectMake(0, 0, 80, 60)];
    
    LOTAnimationView *refreshView = [LOTAnimationView animationNamed:@"refresh_white"];
    refreshView.loopAnimation = YES;
    refreshView.frame = CGRectMake(0, 0, 25, 25);
//    refreshView.transform = CGAffineTransformMakeScale(0.5, 0.5);
    [customView addSubview:refreshView];
    refreshView.center = customView.center;
    
    MBProgressHUD *hub = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hub.minSize = CGSizeMake(85, 85);
    hub.customView = customView;
    hub.mode = MBProgressHUDModeCustomView;
    hub.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hub.bezelView.color = [[UIColor blackColor] colorWithAlphaComponent:0.7];
    hub.label.textColor = [UIColor whiteColor];
    hub.label.font = [UIFont systemFontOfSize:13];
    hub.label.text = text;
    
    [refreshView playWithCompletion:^(BOOL animationFinished) {
        
    }];
    
    [[HUDHelper sharedHelper].hudsDic setObject:hub forKey:tag];
    
    return tag;
}

+ (void)hideLoadingView:(NSString *)tag{
    if (emptyString(tag)) {
        for (MBProgressHUD *hub in [HUDHelper sharedHelper].hudsDic.allValues) {
            [hub hideAnimated:NO];
        }
        [[HUDHelper sharedHelper].hudsDic removeAllObjects];
    }else{
        MBProgressHUD *hub = [[HUDHelper sharedHelper].hudsDic objectForKey:tag];
        if (hub) {
            [hub hideAnimated:YES];
            [[HUDHelper sharedHelper].hudsDic removeObjectForKey:tag];
        }
    }
}

+ (void)updateLoadingView:(NSString *)tag text:(NSString *)text{
    if (!emptyString(tag)) {
        
        MBProgressHUD *hub = [[HUDHelper sharedHelper].hudsDic objectForKey:tag];
        if (hub) {
            hub.label.text = text;
        }
    }
}

@end

