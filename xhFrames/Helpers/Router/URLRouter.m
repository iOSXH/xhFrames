//
//  URLRouter.m
//  xianghui
//
//  Created by xianghui on 2018/8/16.
//  Copyright © 2018年 xianghui. All rights reserved.
//

#import "URLRouter.h"
#import "AppDelegate.h"

#import "NSURL+QueryDictionary.h"

#import "XHHttpServiceHeader.h"

#import "XHBaseNavigationController.h"
#import "WebViewController.h"

@interface URLRouter ()

@property (nonatomic, assign) BOOL needCheckUser;

@end

@implementation URLRouter

IMPLEMENT_SINGLETON(URLRouter, sharedRouter)

- (instancetype)init{
    self = [super init];
    if (self){
        [self addNotifications];
    }
    return self;
}

- (void)dealloc{
    [self removeNotifications];
}

#pragma mark Notification
- (void)addNotifications{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveNotification:) name:UIApplicationWillEnterForegroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveNotification:) name:UIApplicationDidEnterBackgroundNotification object:nil];
}

- (void)removeNotifications{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveNotification:(NSNotification *)noti{
    if ([noti.name isEqualToString:UIApplicationWillEnterForegroundNotification]) {
        
    }else if ([noti.name isEqualToString:UIApplicationDidEnterBackgroundNotification]){
        
    }
}

#pragma mark base


+ (UIViewController *)currentRootViewController{
    UIViewController *tabbarVc = [UIAppDelegate window].rootViewController;
    
    return tabbarVc;
}

+ (UINavigationController *)currentNavigationController{
    
    UINavigationController *nav = nil;
    
    UIViewController *rootVc = [self currentRootViewController];
    
    if ([rootVc isKindOfClass:[UINavigationController class]]) {
        nav = (UINavigationController *)rootVc;
    }else if ([rootVc isKindOfClass:[UITabBarController class]]){
        UIViewController *currentVc = [(UITabBarController *)rootVc selectedViewController];
        if ([currentVc isKindOfClass:[UINavigationController class]]) {
            nav = (UINavigationController *)currentVc;
        }
    }
    
//    if (rootVc.presentedViewController && [rootVc.presentedViewController isKindOfClass:[UINavigationController class]]) {
//        nav = (UINavigationController *)rootVc.presentedViewController;
//    }
    
    return nav;
}



#pragma mark URL
+ (NSURL *)urlRouterWithPath:(NSString *)path{
    return [[URLRouter sharedRouter] urlRouterWithPath:path component:nil params:nil];
}

- (NSURL *)urlRouterWithPath:(NSString *)path component:(NSString *)component params:(NSDictionary *)params{
    NSURL *url = nil;
    
    if (!emptyString(path)) {
        url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",kAPPBaseURL,path]];
        if (!emptyString(component)) {
            url = [url URLByAppendingPathComponent:component];
        }
        if (params && params.count > 0) {
            url = [url uq_URLByAppendingQueryDictionary:params];
        }
    }
    return url;
}

#pragma mark Router
+ (void)routerUrlWithPath:(NSString *)path{
    [[URLRouter sharedRouter] routerUrlWithUrl:[URLRouter urlRouterWithPath:path] extra:nil options:XHRouterOption_New fromNav:nil complete:nil];
}

+ (void)routerUrlWithPath:(NSString *)path params:(NSDictionary *)params{
    [[URLRouter sharedRouter] routerUrlWithUrl:[[URLRouter sharedRouter] urlRouterWithPath:path component:nil params:params] extra:nil options:XHRouterOption_New fromNav:nil complete:nil];
}

+ (void)routerUrlWithURL:(NSURL *)url{
    [[URLRouter sharedRouter] routerUrlWithUrl:url extra:nil options:XHRouterOption_New fromNav:nil complete:nil];
}

+ (void)routerUrlWithURLStr:(NSString *)urlStr{
    [[URLRouter sharedRouter] routerUrlWithUrl:[urlStr URLByCheckCharacter] extra:nil options:XHRouterOption_New fromNav:nil complete:nil];
}

+ (void)routerUrlWithPath:(NSString *)path fromNav:(UINavigationController *)nav{
    [[URLRouter sharedRouter] routerUrlWithUrl:[URLRouter urlRouterWithPath:path] extra:nil options:XHRouterOption_New fromNav:nav complete:nil];
}

+ (void)routerUrlWithPath:(NSString *)path params:(NSDictionary *)params fromNav:(UINavigationController *)nav{
    [[URLRouter sharedRouter] routerUrlWithUrl:[[URLRouter sharedRouter] urlRouterWithPath:path component:nil params:params] extra:nil options:XHRouterOption_New fromNav:nav complete:nil];
}

+ (void)routerUrlWithUrl:(NSURL *)url extra:(NSDictionary *)extra fromNav:(UINavigationController *)nav complete:(XHRouterCompleteBlock)completeBlock{
    [[URLRouter sharedRouter] routerUrlWithUrl:url extra:extra options:XHRouterOption_New fromNav:nav complete:completeBlock];
}

- (void)routerUrlWithUrl:(NSURL *)url extra:(NSDictionary *)extra options:(XHRouterOption)options fromNav:(UINavigationController *)nav complete:(XHRouterCompleteBlock)completeBlock{
    if (!url) {
        if (completeBlock) {
            completeBlock(nil, errorBuild(XHErrorCode_Custom, kXHCostomErrorDomain, @"路由URL为空"));
        }
        return;
    }
    
    if (![self actionWithUrl:url extra:extra complete:completeBlock]) {
        
        UIViewController *vc = [self viewControllerWithUrl:url extra:extra];
        if (!vc) {
            if (completeBlock) {
                completeBlock(nil, errorBuild(XHErrorCode_Custom, kXHCostomErrorDomain, @"路由不存在"));
            }
            return;
        }
        
        
        vc.hidesBottomBarWhenPushed = YES;
        
        UINavigationController *navc = nav?:[URLRouter currentNavigationController];
        NSMutableArray *vcs = [NSMutableArray arrayWithArray:navc.viewControllers];
        
        if(options & XHRouterOption_Close){
            [vcs removeLastObject];
        }
        
        NSInteger existedIndex = -1;
        if ([vc isKindOfClass:[XHBaseViewController class]] && (options & XHRouterOption_Existed)) {
            XHBaseViewController *baseVc = (XHBaseViewController *)vc;
            for (NSInteger i = 0; i < vcs.count; i ++ ) {
                id obj = [vcs objectAtIndex:i];
                if ([baseVc isEqualToVc:obj]) {
                    existedIndex = i;
                    break;
                }
            }
            
            if(existedIndex >= 0 && (options & XHRouterOption_Refresh)){
                XHBaseViewController *existedVc = [vcs objectAtIndex:existedIndex];
                [existedVc refresh];
            }
        }
        
        if (existedIndex >= 0  && existedIndex < vcs.count) {
            NSArray *newVcs = [vcs subarrayWithRange:NSMakeRange(0, existedIndex+1)];
            [navc setViewControllers:newVcs animated:YES];
        }else{
            UIViewController *presentedVc = nil;
            if(options & XHRouterOption_Present){
                presentedVc = vc;
            }else if (options & XHRouterOption_PresentNav){
                XHBaseNavigationController *nav = [[XHBaseNavigationController alloc] initWithRootViewController:vc];
                presentedVc = nav;
            }
            if (presentedVc) {
                [[URLRouter currentRootViewController] presentViewController:presentedVc animated:YES completion:nil];
            }else{
                [vcs addObject:vc];
                [navc setViewControllers:vcs animated:YES];
            }
        }
        if (completeBlock) {
            completeBlock(nil, nil);
        }
    }
}



#pragma mark 根据URL匹配界面
- (UIViewController *)viewControllerWithUrl:(NSURL *)url extra:(NSDictionary *)extra{
    UIViewController *resultVc = nil;
    NSString *scheme = url.scheme;
    if ([scheme hasPrefix:@"http"]
        || [scheme hasPrefix:@"https"]) {
        WebViewController *webVc = [[WebViewController alloc] init];
        webVc.url = url;
        resultVc = webVc;
    }else if([scheme hasPrefix:kAPPScheme]) {
        NSString *path = url.path;
        if (emptyString(path)) {
            return nil;
        }
        if ([path containsString:@"/"]) {
            NSArray *paths = [path componentsSeparatedByString:@"/"];
            if (paths.count > 1) {
                path = [paths objectOrNilAtIndex:1];
            }
        }
        
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:[url uq_queryDictionary]];
        if (extra && extra.count > 0) {
            [params addEntriesFromDictionary:extra];
        }
        
        if ([path isEqualToString:kURLRouter_Search]) {
//            TSSearchViewController *vc = [[TSSearchViewController alloc] init];
//            resultVc = vc;
        }
        
        if (params.count > 0) {
            [resultVc modelSetWithDictionary:params];
        }
    }
    
    return resultVc;
}

#pragma mark 根据URL做处理
- (BOOL)actionWithUrl:(NSURL *)url extra:(NSDictionary *)extra complete:(XHRouterCompleteBlock)completeBlock{
    BOOL result = NO;

    NSString *scheme = url.scheme;

    if ([scheme hasPrefix:@"http"]
        || [scheme hasPrefix:@"https"]) {
        NSString *open = [url.uq_queryDictionary objectForKey:@"wwopen"];
        if ([open isEqualToString:@"system"]) {
            result = YES;
            [[UIApplication sharedApplication] openURL:url];
        }
    }else if([scheme hasPrefix:kAPPScheme]) {
        NSString *path = url.path;
        if (emptyString(path)) {
            return NO;
        }
        if ([path containsString:@"/"]) {
            NSArray *paths = [path componentsSeparatedByString:@"/"];
            if (paths.count > 1) {
                path = [paths objectOrNilAtIndex:1];
            }
        }
        
        if ([AccountManager sharedManager].loginState != LoginState_In) {
            [[AccountManager sharedManager] logout];
            return YES;
        }

        if ([path isEqualToString:kURLRouter_Logout]) {
            [[AccountManager sharedManager] logout];
            result = YES;
        }else if ([path isEqualToString:kURLRouter_Main]) {
            UINavigationController *nav = [URLRouter currentNavigationController];
            [nav popToRootViewControllerAnimated:YES];
            result = YES;
        }else if ([path isEqualToString:kURLRouter_HomeTab]){
            NSInteger index = [[url.uq_queryDictionary objectForKey:@"index"] integerValue];
            [[NSNotificationCenter defaultCenter] postNotificationName:kAPPHomeTabDidSelectNotificationKey object:@(index)];
            return YES;
        }else if ([path isEqualToString:kURLRouter_AppShare]){
#warning test
            [self systemShareWithItems:@[APPName] complete:completeBlock];
            return YES;
        }else if ([path isEqualToString:kURLRouter_ClearCache]){
            NSString *tag = [HUDHelper showLoadingWithText:@"清理中..." inView:[URLRouter currentNavigationController].visibleViewController.view];
            [self clearWebCache];
            [[SDImageCache sharedImageCache] clearDiskOnCompletion:^{
                [HUDHelper hideLoadingView:tag];
                [ToastHelper showMessage:@"成功清理缓存"];
                if (completeBlock) {
                    completeBlock(nil, nil);
                }
            }];
            
            return YES;
        }

    }else{
        result = YES;
        [[UIApplication sharedApplication] openURL:url];
    }

    return result;
}


#pragma mark 唤起微信小程序
- (void)weixinLaunchMiniProgram:(NSURL *)url extra:(NSDictionary *)extra complete:(XHRouterCompleteBlock)completeBlock{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithDictionary:[url uq_queryDictionary]];
    if (extra) {
        [params addEntriesFromDictionary:extra];
    }
    
}

#pragma mark 分享微信小程序
- (void)weixinShareMiniProgram:(NSURL *)url extra:(NSDictionary *)extra complete:(XHRouterCompleteBlock)completeBlock{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithDictionary:[url uq_queryDictionary]];
    if (extra) {
        [params addEntriesFromDictionary:extra];
    }
    
}

#pragma mark 分享微信图片
- (void)weixinShareImage:(NSURL *)url extra:(NSDictionary *)extra complete:(XHRouterCompleteBlock)completeBlock{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithDictionary:[url uq_queryDictionary]];
    if (extra) {
        [params addEntriesFromDictionary:extra];
    }
    
}


- (void)systemShareWithItems:(NSArray *)items complete:(XHRouterCompleteBlock)completeBlock{
    UIActivityViewController *activityController=[[UIActivityViewController alloc] initWithActivityItems:items applicationActivities:nil];
    activityController.completionWithItemsHandler = ^(UIActivityType  _Nullable activityType, BOOL completed, NSArray * _Nullable returnedItems, NSError * _Nullable activityError) {
        if (completed) {
            if (completeBlock) {
                completeBlock(nil, nil);
            }
        }else{
            if (completeBlock) {
                completeBlock(nil,activityError?:errorBuild(XHErrorCode_Cancel, kXHCostomErrorDomain, @"分享取消"));
            }
        }
    };
    [[URLRouter currentRootViewController] presentViewController:activityController animated:YES completion:nil];
}


- (void)clearWebCache{
    //清除cookies
    
    NSHTTPCookie *cookie;
    
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    
    for (cookie in [storage cookies])
        
    {
        
        [storage deleteCookie:cookie];
        
    }
    
    //    清除webView的缓存
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
}

@end
