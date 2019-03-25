//
//  BaseHttpService.h
//  xianghui
//
//  Created by xianghui on 2018/8/13.
//  Copyright © 2018年 xh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseHttpRequest.h"
#import "HttpApiHeader.h"



static NSString * const kNetWorkChangeNotification = @"kNetWorkChangeNotification";

typedef void(^HttpCompleteBlock)(ResultModel *requestResult, NSError *error);
typedef void(^NetWorkStatusChangeBlock)(NetWorkStatus netWorkSatus);
typedef void(^HttpProgressBlock)(double progress);

@interface BaseHttpService : NSObject


@property (nonatomic, assign, readonly) BOOL isNetReachable;
@property (nonatomic, assign, readonly) NetWorkStatus netWorkSatus;

@property (nonatomic, copy) NetWorkStatusChangeBlock netChangeBlock;

+ (instancetype)shareService;


/**
 HTTP POST 请求
 
 @param path 请求地址
 @param params 参数
 @param completeBlock 成功回调
 @return WWBaseHttpRequest
 */
- (BaseHttpRequest *)postRequestWithPath:(NSString *)path
                             parameter:(NSDictionary *)params
                              complete:(HttpCompleteBlock)completeBlock;

/**
 HTTP GET 请求
 
 @param path 请求地址
 @param params 参数
 @param completeBlock 成功回调
 @return BaseHttpRequest
 */
- (BaseHttpRequest *)getRequestWithPath:(NSString *)path
                            parameter:(NSDictionary *)params
                             complete:(HttpCompleteBlock)completeBlock;


/**
 Http请求
 
 @param method 请求方式 get、post...
 @param path 请求地址（没有baseUrl）
 @param params 参数
 @param completeBlock 成功回调
 @return BaseHttpRequest
 */
- (BaseHttpRequest *)requestWithMethod:(HttpMethod)method
                                path:(NSString *)path
                           parameter:(NSDictionary *)params
                            complete:(HttpCompleteBlock)completeBlock;

- (BaseHttpRequest *)requestWithMethod:(HttpMethod)method
                             baseUrl:(NSString *)baseUrl
                                path:(NSString *)path
                           parameter:(NSDictionary *)params
                            complete:(HttpCompleteBlock)completeBlock;



- (BaseHttpRequest *)uploadBaseUrl:(NSString *)baseUrl
                              path:(NSString *)path
                              data:(NSData *)data
                          fileName:(NSString *)fileName
                          complete:(HttpCompleteBlock)completeBlock
                          progress:(HttpProgressBlock)progressBlock;

@end
