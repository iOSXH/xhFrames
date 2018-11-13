//
//  XHBaseHttpService.h
//  xianghui
//
//  Created by xianghui on 2018/8/13.
//  Copyright © 2018年 xh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XHHttpRequest.h"
#import "HttpApiHeader.h"



static NSString * const kXHNetWorkChangeNotification = @"kXHNetWorkChangeNotification";

typedef void(^XHHttpCompleteBlock)(XHResultModel *requestResult, NSError *error);
typedef void(^XHNetWorkStatusChangeBlock)(XHNetWorkStatus netWorkSatus);

@interface XHBaseHttpService : NSObject


@property (nonatomic, assign, readonly) BOOL isNetReachable;
@property (nonatomic, assign, readonly) XHNetWorkStatus netWorkSatus;

@property (nonatomic, copy) XHNetWorkStatusChangeBlock netChangeBlock;

+ (instancetype)shareService;


/**
 HTTP POST 请求
 
 @param path 请求地址
 @param params 参数
 @param completeBlock 成功回调
 @return WWHttpRequest
 */
- (XHHttpRequest *)postRequestWithPath:(NSString *)path
                             parameter:(NSDictionary *)params
                              complete:(XHHttpCompleteBlock)completeBlock;

/**
 HTTP GET 请求
 
 @param path 请求地址
 @param params 参数
 @param completeBlock 成功回调
 @return XHHttpRequest
 */
- (XHHttpRequest *)getRequestWithPath:(NSString *)path
                            parameter:(NSDictionary *)params
                             complete:(XHHttpCompleteBlock)completeBlock;


/**
 Http请求
 
 @param method 请求方式 get、post...
 @param path 请求地址（没有baseUrl）
 @param params 参数
 @param completeBlock 成功回调
 @return XHHttpRequest
 */
- (XHHttpRequest *)requestWithMethod:(XHHttpMethod)method
                                path:(NSString *)path
                           parameter:(NSDictionary *)params
                            complete:(XHHttpCompleteBlock)completeBlock;

- (XHHttpRequest *)requestWithMethod:(XHHttpMethod)method
                             baseUrl:(NSString *)baseUrl
                                path:(NSString *)path
                           parameter:(NSDictionary *)params
                            complete:(XHHttpCompleteBlock)completeBlock;

@end
