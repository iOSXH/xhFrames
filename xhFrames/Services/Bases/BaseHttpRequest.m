//
//  BaseHttpRequest.m
//  xianghui
//
//  Created by xianghui on 2018/8/14.
//  Copyright © 2018年 xh. All rights reserved.
//

#import "BaseHttpRequest.h"

@implementation BaseHttpRequest

+ (BaseHttpRequest *)buildRequestWithMethod:(HttpMethod)method path:(NSString *)path params:(NSDictionary *)params{
    BaseHttpRequest *request = [[BaseHttpRequest alloc] init];
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
    return kHttpTimeoutInterval;
}

- (YTKRequestSerializerType)requestSerializerType{
    return YTKRequestSerializerTypeJSON;
}

- (YTKResponseSerializerType)responseSerializerType{
    return YTKResponseSerializerTypeJSON;
}


@end



@implementation BaseHttpUploadRequest

+ (BaseHttpUploadRequest *)buildRequestWithMethod:(HttpMethod)method path:(NSString *)path data:(NSData *)data{
    BaseHttpUploadRequest *request = [[BaseHttpUploadRequest alloc] init];
    request.basePath = path;
    request.baseMethod = method;
    request.baseHeaders = [AccountManager sharedManager].apiHeader;
    
    request.data = data;
    
    return request;
}

- (AFConstructingBlock)constructingBodyBlock{
    return ^(id<AFMultipartFormData> formData) {
        NSString *name = self.fileName;
        NSString *formKey = self.fileName;
        NSString *type = @"image/jpeg";
        [formData appendPartWithFileData:self.data name:formKey fileName:name mimeType:type];
    };
}

@end


@implementation ResultModel

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


