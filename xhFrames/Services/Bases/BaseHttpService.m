//
//  BaseHttpService.m
//  xianghui
//
//  Created by xianghui on 2018/8/13.
//  Copyright © 2018年 xh. All rights reserved.
//

#import "BaseHttpService.h"

@implementation BaseHttpService


- (BOOL)isNetReachable{
    return [AFNetworkReachabilityManager sharedManager].isReachable;
}

- (NetWorkStatus)netWorkSatus{
    return (NetWorkStatus)[AFNetworkReachabilityManager sharedManager].networkReachabilityStatus;
}

+ (instancetype)shareService{
    static dispatch_once_t onceQueue;
    static BaseHttpService *sharedInstance = nil;
    dispatch_once(&onceQueue, ^{
        sharedInstance = [[BaseHttpService alloc] init];
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
                self.netChangeBlock((NetWorkStatus)status);
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:kNetWorkChangeNotification object:nil];
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


- (void)analysisResultRequest:(YTKBaseRequest *)request complete:(HttpCompleteBlock)completeBlock{
    
    if (DebugMode) {
        DDLogDebug(@"请求结果：%@ %@", request.response.URL.path, request.responseObject);
    }
    
    
    NSInteger errorCode = 0;
    NSString *errorMsg = @"";
    NSDictionary *resultDic = request.responseJSONObject;
    ResultModel *resultModel = nil;
    if (resultDic && resultDic.count > 0) {
        
        if (![resultDic containsObjectForKey:@"code"]){
            resultDic = @{@"code":@(ServiceErrorCode_Success),
                          @"data":resultDic
                          };
        }
        
        
        resultModel = [[ResultModel alloc] init];
        [resultModel modelSetWithDictionary:resultDic];
        errorCode = resultModel.code;
        errorMsg = resultModel.msg;
    }else{
        errorCode = -10;
        errorMsg = @"获取不到数据";
    }
    
    
    if (errorCode == ServiceErrorCode_Success) {
        if (completeBlock) {
            completeBlock(resultModel, nil);
        }
    }else{
        if (errorCode == ServiceErrorCode_UnLogin) {
            [[AccountManager sharedManager] logout];
        }
        
        NSError *error = errorBuild(errorCode, kAPICostomErrorDomain, errorMsg);
        if (completeBlock) {
            completeBlock(resultModel, error);
        }
    }
}


- (BaseHttpRequest *)postRequestWithPath:(NSString *)path parameter:(NSDictionary *)params complete:(HttpCompleteBlock)completeBlock{
    return [self requestWithMethod:HttpMethodPost path:path parameter:params complete:completeBlock];
}


- (BaseHttpRequest *)getRequestWithPath:(NSString *)path parameter:(NSDictionary *)params complete:(HttpCompleteBlock)completeBlock{
    return [self requestWithMethod:HttpMethodGet path:path parameter:params complete:completeBlock];
}

- (BaseHttpRequest *)requestWithMethod:(HttpMethod)method path:(NSString *)path parameter:(NSDictionary *)params complete:(HttpCompleteBlock)completeBlock{
    return [self requestWithMethod:method baseUrl:nil path:path parameter:params complete:completeBlock];
}

- (BaseHttpRequest *)requestWithMethod:(HttpMethod)method baseUrl:(NSString *)baseUrl path:(NSString *)path parameter:(NSDictionary *)params complete:(HttpCompleteBlock)completeBlock{
    
    if (DebugMode) {
        DDLogDebug(@"请求开始：%@ 参数：%@", path, params);
    }
    
    BaseHttpRequest *request = [BaseHttpRequest buildRequestWithMethod:method path:path params:params];
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

- (BaseHttpRequest *)uploadBaseUrl:(NSString *)baseUrl path:(NSString *)path data:(NSData *)data fileName:(NSString *)fileName complete:(HttpCompleteBlock)completeBlock progress:(HttpProgressBlock)progressBlock{
    if (DebugMode) {
        DDLogDebug(@"开始上传：%@", path);
    }
    
    BaseHttpUploadRequest *request = [BaseHttpUploadRequest buildRequestWithMethod:HttpMethodPost path:path data:data];
    request.fileName = fileName;
    if (baseUrl) {
        request.basePathUrl = baseUrl;
        if (DebugMode) {
            DDLogDebug(@"上传开始baseURL：%@ ", baseUrl);
        }
    }
    [request startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        [self analysisResultRequest:request complete:completeBlock];
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        
        if (DebugMode) {
            DDLogDebug(@"上传结果出错:%@ %@ %@", request.response.URL, @(request.response.statusCode), request.responseString);
        }
        
        if (completeBlock) {
            completeBlock(nil, request.error);
        }
    }];
    
//    [request setProgressBlock:^(NSProgress * _Nonnull progress) {
//        if (DebugMode) {
//            DDLogDebug(@"上传进度:%@", progress);
//        }
//        if (progressBlock) {
//            progressBlock(progress.fractionCompleted);
//        }
//    }];
    
    return request;
}
@end
