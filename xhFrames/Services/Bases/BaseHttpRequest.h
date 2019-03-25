//
//  BaseHttpRequest.h
//  xianghui
//
//  Created by xianghui on 2018/8/14.
//  Copyright © 2018年 xh. All rights reserved.
//

#import "YTKRequest.h"
#import "HttpServiceHeader.h"

@interface BaseHttpRequest : YTKRequest


@property (nonatomic, strong) NSString *basePath;
@property (nonatomic, assign) HttpMethod baseMethod;
@property (nonatomic, strong) NSDictionary *baseParams;
@property (nonatomic, strong) NSDictionary *baseHeaders;
@property (nonatomic, strong) NSString *basePathUrl;

+ (BaseHttpRequest *)buildRequestWithMethod:(HttpMethod)method
                                     path:(NSString *)path
                                   params:(NSDictionary *)params;

@end


@interface BaseHttpUploadRequest : BaseHttpRequest

@property (nonatomic, strong) NSData *data;
@property (nonatomic, assign) NSInteger fileType; /// 0 图片 其它待拓展
@property (nonatomic, strong) NSString *fileName;

+ (BaseHttpUploadRequest *)buildRequestWithMethod:(HttpMethod)method
                                           path:(NSString *)path
                                           data:(NSData *)data;

@end


@interface ResultModel : NSObject

@property (nonatomic, strong) NSString *msg;
@property (nonatomic, assign) NSInteger code;
@property (nonatomic, strong) id data;

@property (nonatomic, strong) NSString *seq_id;

@end


@interface XHPageModel : NSObject

@property (nonatomic, assign) NSInteger limit;
@property (nonatomic, assign) NSInteger offset;
@property (nonatomic, assign) NSInteger total;
@property (nonatomic, assign) NSInteger pages;

- (BOOL)hasNextPage;

@end


@interface XHListDataModel : NSObject

@property (nonatomic, strong) NSArray *list;

@property (nonatomic, assign) NSInteger limit;
@property (nonatomic, assign) NSInteger next_id;

@end
