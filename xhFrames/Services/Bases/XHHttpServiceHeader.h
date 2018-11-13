//
//  XHHttpServiceHeader.h
//  xianghui
//
//  Created by xianghui on 2018/8/14.
//  Copyright © 2018年 xh. All rights reserved.
//

#ifndef XHHttpServiceHeader_h
#define XHHttpServiceHeader_h

static NSTimeInterval const kXHHttpTimeoutInterval = 10;

static NSString * const kXHCostomErrorDomain = @"kXHCostomErrorDomain";//app 内部定义错误
static NSString * const kXHAPICostomErrorDomain = @"kXHAPICostomErrorDomain";// api 返回错误
static NSString * const kXHHttpErrorDomain = @"kXHHttpAPIErrorDomain";// http 错误
static NSString * const kXHWeiXinErrorDomain = @"kXHWeiXinAPIErrorDomain"; // 微信api错误
static NSString * const kXHAliPayErrorDomain = @"kXHAliPayErrorDomain";//支付宝api错误
static NSString * const kXHILiveErrorDomain = @"kXHILiveErrorDomain";//腾讯云api错误

static inline NSError * errorBuild(NSInteger errorCode, NSString *domain, NSString *errorMsg){
    NSMutableDictionary *useinfo = [NSMutableDictionary dictionary];
    if (errorMsg) {
        [useinfo setObject:errorMsg forKey:NSLocalizedDescriptionKey];
    }
    NSError *error = [[NSError alloc] initWithDomain:domain code:errorCode userInfo:useinfo];
    return error;
}

static inline NSString * errorMsg(NSError *error, NSString *defaultMsg){
    if (!error) {
        return defaultMsg;
    }
    
    NSString *errorMsg = [error.userInfo objectForKey:NSLocalizedDescriptionKey];
    
    
    
    if (![error.domain hasPrefix:@"kYW"]) {
#if DebugMode == 0
        errorMsg = nil;
#endif
        if (![AFNetworkReachabilityManager sharedManager].reachable) {
            errorMsg = @"网络不给力，点击屏幕重试";
        }else{
#if DebugMode == 0
            errorMsg = @"服务器或网络出问题了，点击屏幕重试";
#endif
        }
    }
    
    errorMsg = errorMsg?:defaultMsg;
    return errorMsg;
}

static inline NSInteger ywAppVersion(){
    
    static dispatch_once_t onceQueue;
    static NSInteger currentVersion = 0;
    dispatch_once(&onceQueue, ^{
        NSArray *array = [APPVersion componentsSeparatedByString:@"."];
        for (NSInteger i = 0; i < array.count; i ++) {
            NSInteger count = [[array objectAtIndex:i] integerValue];
            if (i == 0) {
                currentVersion += count*100000;
            }else if (i == 1){
                currentVersion += count*100;
            }else{
                currentVersion += count;
            }
        }
    });
    return currentVersion;
}

typedef enum : NSUInteger {
    XHHttpMethodGet = 0,
    XHHttpMethodPost,
    XHHttpMethodHEAD,
    XHHttpMethodPUT,
    XHHttpMethodDELETE,
    XHHttpMethodPATCH,
} XHHttpMethod;

typedef enum : NSUInteger {
    XHErrorCode_Cancel = -101,          ///< 取消操作
    XHErrorCode_Custom = -200,          ///< 自定义错误
    XHErrorCode_AuthorizationFail = -1, ///< 授权失败
    XHErrorCode_Success = 1,            ///< 成功
    XHErrorCode_Error = 400,            ///< 程序执行出错
    XHErrorCode_UnLogin = -100,         ///< 非登录用户访问
    XHErrorCode_PageNotFound = 404,     ///< 接口地址找不到
    XHErrorCode_PermissionDenied = 405 ,///< 权限不足
} XHErrorCode;

typedef enum : NSUInteger {
    XHNetWorkStatusUnknown = -1,
    XHNetWorkStatusNotReachable = 0,
    XHNetWorkStatusReachableWWAN = 1,
    XHNetWorkStatusReachableWiFi = 2,
} XHNetWorkStatus;

#endif /* XHHttpServiceHeader_h */
