//
//  XHHttpRequest.m
//  xianghui
//
//  Created by xianghui on 2018/8/14.
//  Copyright © 2018年 xh. All rights reserved.
//

#import "XHHttpRequest.h"

@implementation XHHttpRequest

+ (XHHttpRequest *)buildRequestWithMethod:(XHHttpMethod)method path:(NSString *)path params:(NSDictionary *)params{
    XHHttpRequest *request = [[XHHttpRequest alloc] init];
    request.basePath = path;
    request.baseMethod = method;
    request.baseParams = params;
    
    request.baseHeaders = [AccountManager sharedManager].apiHeader;
    
    return request;
}

- (NSString *)requestUrl{
    return self.basePath;
}

- (NSString *)baseUrl{
    if (self.basePathUrl) {
        return self.basePathUrl;
    }
    return @"";
}

- (YTKRequestMethod)requestMethod{
    return (YTKRequestMethod)self.baseMethod;
}

- (id)requestArgument{
    return self.baseParams;
}

- (NSDictionary<NSString *,NSString *> *)requestHeaderFieldValueDictionary{
    return self.baseHeaders;
}

- (NSTimeInterval)requestTimeoutInterval{
    return kXHHttpTimeoutInterval;
}

- (YTKRequestSerializerType)requestSerializerType{
    return YTKRequestSerializerTypeJSON;
}

- (YTKResponseSerializerType)responseSerializerType{
    return YTKResponseSerializerTypeJSON;
}


@end


@implementation XHResultModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"msg" : @"message"};
}

@end

@implementation XHPageModel

- (BOOL)hasNextPage{
    BOOL has = YES;
    if (self.offset == 0 && self.offset == self.pages-1) {
        has = NO;
    }
    if (self.offset == self.pages) {
        has = NO;
    }
    return has;
}

@end


@implementation XHListDataModel



@end


