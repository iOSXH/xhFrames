//
//  URLRouterHeader.h
//  xianghui
//
//  Created by xianghui on 2018/8/16.
//  Copyright © 2018年 xianghui. All rights reserved.
//

#ifndef URLRouterHeader_h
#define URLRouterHeader_h


#pragma mark 枚举 enum
/**
 URL路由参数
 
 - XHRouterOption_New: 添加新页面
 - XHRouterOption_Existed: 如果存在跳转到已存在界面 否则New
 - XHRouterOption_Refresh: 如果存在刷新该页面 否则New
 - XHRouterOption_Close: 如果存在关闭当前页面
 */
typedef NS_ENUM(NSInteger, XHRouterOption) {
    
    XHRouterOption_New = 1 << 0,
    
    XHRouterOption_Existed = 1 << 1,
    
    XHRouterOption_Refresh = 1 << 2,
    
    XHRouterOption_Close   = 1 << 3,
    
    XHRouterOption_Present   = 1 << 4,
    
    XHRouterOption_PresentNav   = 1 << 5,
};


#pragma mark Block
typedef void(^XHRouterCompleteBlock)(id result, NSError *error);

#pragma mark static NSString


static NSString * const kAPPScheme = @"sentiment";
static NSString * const kAPPBaseURL = @"sentiment://sentiment.xianghui.com";


static NSString * const kAPPHomeTabDidSelectNotificationKey = @"kAPPHomeTabDidSelectNotificationKey";

static NSString * const kURLRouter_HomeTab = @"home_tab";                           ///< 系统消息界面

#pragma mark 页面路由key
static NSString * const kURLRouter_Main = @"main";                                  ///< 返回主页

static NSString * const kURLRouter_Search = @"search";                              ///< 搜索
static NSString * const kURLRouter_CompanyDetail = @"company_details";              ///< 公司详情 ?article_id=xxx&picture_url==
static NSString * const kURLRouter_NewsDetail = @"news_details";                    ///< 资讯详情
static NSString * const kURLRouter_EventDetail = @"event_details";                  ///< 事件详情
static NSString * const kURLRouter_ArticleDetail = @"article_details";              ///< 文章详情


#pragma mark action路由key
static NSString * const kURLRouter_NewsShare = @"news_share";                       ///< 资讯详情分享
static NSString * const kURLRouter_AppShare = @"app_share";                         ///< 资讯详情分享
static NSString * const kURLRouter_ClearCache = @"clear_cache";                     ///< 清理缓存


#pragma mark private路由key
static NSString * const kURLRouter_WXLaunchMiniProgram = @"wx-launch-miniProgram";              ///< 唤起微信小程序
static NSString * const kURLRouter_WXShareMiniProgram = @"wx-share-miniProgram";                ///< 分享微信小程序
static NSString * const kURLRouter_WXShareImage = @"wx-share-image";                            ///< 分享微信图片


static NSString * const kURLRouter_Logout = @"logout";                                          ///< 退出



#endif /* URLRouterHeader_h */
