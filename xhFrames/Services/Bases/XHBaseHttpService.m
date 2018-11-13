//
//  XHBaseHttpService.m
//  xianghui
//
//  Created by xianghui on 2018/8/13.
//  Copyright © 2018年 xh. All rights reserved.
//

#import "XHBaseHttpService.h"

@implementation XHBaseHttpService


- (BOOL)isNetReachable{
    return [AFNetworkReachabilityManager sharedManager].isReachable;
}

- (XHNetWorkStatus)netWorkSatus{
    return (XHNetWorkStatus)[AFNetworkReachabilityManager sharedManager].networkReachabilityStatus;
}

+ (instancetype)shareService{
    static dispatch_once_t onceQueue;
    static XHBaseHttpService *sharedInstance = nil;
    dispatch_once(&onceQueue, ^{
        sharedInstance = [[XHBaseHttpService alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        [self initConfig];
        
        [[AFNetworkReachabilityManager sharedManager] startMonitoring];
        [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status){
            if (self.netChangeBlock) {
                self.netChangeBlock((XHNetWorkStatus)status);
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:kXHNetWorkChangeNotification object:nil];
        }];
    }
    return self;
}

- (void)initConfig{
    NSString *baseUrl = kApi_Base_Url;
    
    if (DevelopMode) {
        baseUrl = kApi_Base_Url_Dev;
    }
    
    YTKNetworkConfig *config = [YTKNetworkConfig sharedConfig];
    config.baseUrl = baseUrl;
    config.debugLogEnabled = NO;
    
    if (DebugMode) {
        DDLogDebug(@"请求baseURL：%@ ", baseUrl);
    }
    
    
}


- (void)analysisResultRequest:(YTKBaseRequest *)request complete:(XHHttpCompleteBlock)completeBlock{
    
    if (DebugMode) {
        DDLogDebug(@"请求结果：%@ %@", request.response.URL.path, request.responseObject);
    }
    
    
    NSInteger errorCode = 0;
    NSString *errorMsg = @"";
    NSDictionary *resultDic = request.responseJSONObject;
    XHResultModel *resultModel = nil;
    if (resultDic && resultDic.count > 0) {
        
        if (![resultDic containsObjectForKey:@"code"]){
            resultDic = @{@"code":@(XHErrorCode_Success),
                          @"data":resultDic
                          };
        }
        
        
        resultModel = [[XHResultModel alloc] init];
        [resultModel modelSetWithDictionary:resultDic];
        errorCode = resultModel.code;
        errorMsg = resultModel.msg;
    }else{
        errorCode = -10;
        errorMsg = @"获取不到数据";
    }
    
    
    if (errorCode == XHErrorCode_Success) {
        if (completeBlock) {
            completeBlock(resultModel, nil);
        }
    }else{
        if (errorCode == XHErrorCode_UnLogin) {
            [[AccountManager sharedManager] logout];
        }
        
        NSError *error = errorBuild(errorCode, kXHAPICostomErrorDomain, errorMsg);
        if (completeBlock) {
            completeBlock(resultModel, error);
        }
    }
}


- (XHHttpRequest *)postRequestWithPath:(NSString *)path parameter:(NSDictionary *)params complete:(XHHttpCompleteBlock)completeBlock{
    return [self requestWithMethod:XHHttpMethodPost path:path parameter:params complete:completeBlock];
}


- (XHHttpRequest *)getRequestWithPath:(NSString *)path parameter:(NSDictionary *)params complete:(XHHttpCompleteBlock)completeBlock{
    return [self requestWithMethod:XHHttpMethodGet path:path parameter:params complete:completeBlock];
}

- (XHHttpRequest *)requestWithMethod:(XHHttpMethod)method path:(NSString *)path parameter:(NSDictionary *)params complete:(XHHttpCompleteBlock)completeBlock{
    return [self requestWithMethod:method baseUrl:nil path:path parameter:params complete:completeBlock];
}

- (XHHttpRequest *)requestWithMethod:(XHHttpMethod)method baseUrl:(NSString *)baseUrl path:(NSString *)path parameter:(NSDictionary *)params complete:(XHHttpCompleteBlock)completeBlock{
    
    if (DebugMode) {
        DDLogDebug(@"请求开始：%@ 参数：%@", path, params);
    }
    
    XHHttpRequest *request = [XHHttpRequest buildRequestWithMethod:method path:path params:params];
    if (baseUrl) {
        request.basePathUrl = baseUrl;
        if (DebugMode) {
            DDLogDebug(@"请求开始baseURL：%@ ", baseUrl);
        }
    }
    [request startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        [self analysisResultRequest:request complete:completeBlock];
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        
        if (DebugMode) {
            DDLogDebug(@"请求结果出错:%@ %@ %@", request.response.URL, @(request.response.statusCode), request.responseString);
        }
        
        if (completeBlock) {
            completeBlock(nil, request.error);
        }
    }];
    
    return request;
}



@end
