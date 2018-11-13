//
//  AppTrackHelper.h
//  xianghui
//
//  Created by xianghui on 2018/10/17.
//  Copyright © 2018 xianghui. All rights reserved.
//

#import <Foundation/Foundation.h>


// 分享平台
//static NSString * const kTrackSharePlatform = @"share_platform";
// 分享平台
//static NSString * const kTrackShareResult = @"share_result";


// 内容
static NSString * const kTrackContent = @"content";


// 主页tab点击 参数 index 0 1 2
static NSString * const kTrackHomeTabClicked = @"HomeTabClicked";


// 用户清理缓存点击
static NSString * const kTrackAccountClearCacheClicked = @"AccountClearCacheClicked";
// 用户退出登录点击
static NSString * const kTrackAccountLogoutClicked = @"AccountLogoutClicked";
// 用户协议点击
static NSString * const kTrackAccountProtocolClicked = @"AccountProtocolClicked";




@interface AppTrackHelper : NSObject

DECLARE_SINGLETON(AppTrackHelper, sharedHelper);


/**
 配置友盟
 */
- (void)configUmeng;


/**
 事件埋点
 
 @param eventId 事件的id
 @param attributes 参数
 */
+ (void)event:(NSString *)eventId attributes:(NSDictionary *)attributes;


/**
 页面统计 进入页面
 
 @param pageName 页面的名字
 */
+ (void)beginLogPageView:(NSString *)pageName;

/**
 页面统计 离开页面
 
 @param pageName 页面名字
 */
+ (void)endLogPageView:(NSString *)pageName;

@end

