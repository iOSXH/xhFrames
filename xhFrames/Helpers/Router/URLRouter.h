//
//  URLRouter.h
//  xianghui
//
//  Created by xianghui on 2018/8/16.
//  Copyright © 2018年 xianghui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "URLRouterHeader.h"

@interface URLRouter : NSObject

DECLARE_SINGLETON(URLRouter, sharedRouter)


#pragma mark base
/**
 当前APP最底层的viewcontriller

 @return UIViewController
 */
+ (UIViewController *)currentRootViewController;


/**
 当前APP目前的NavigationController

 @return UINavigationController
 */
+ (UINavigationController *)currentNavigationController;



#pragma mark URL

/**
 根据path生成URL

 @param path path
 @return URL
 */
+ (NSURL *)urlRouterWithPath:(NSString *)path;


/**
 生成URL

 @param path path
 @param component component
 @param params 参数
 @return URL
 */
- (NSURL *)urlRouterWithPath:(NSString *)path component:(NSString *)component params:(NSDictionary *)params;


#pragma mark Router

/**
 根据Path继续路由跳转

 @param path path
 */
+ (void)routerUrlWithPath:(NSString *)path;
+ (void)routerUrlWithPath:(NSString *)path params:(NSDictionary *)params;
+ (void)routerUrlWithURL:(NSURL *)url;
+ (void)routerUrlWithURLStr:(NSString *)urlStr;

+ (void)routerUrlWithPath:(NSString *)path  fromNav:(UINavigationController *)nav;
+ (void)routerUrlWithPath:(NSString *)path params:(NSDictionary *)params fromNav:(UINavigationController *)nav;

+ (void)routerUrlWithUrl:(NSURL *)url extra:(NSDictionary *)extra fromNav:(UINavigationController *)nav complete:(XHRouterCompleteBlock)completeBlock;

- (void)routerUrlWithUrl:(NSURL *)url extra:(NSDictionary *)extra options:(XHRouterOption)options fromNav:(UINavigationController *)nav complete:(XHRouterCompleteBlock)completeBlock;


@end
