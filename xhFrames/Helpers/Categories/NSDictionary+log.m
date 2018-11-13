//
//  NSDictionary+log.m
//  Wawaji
//
//  Created by xianghui on 2018/7/5.
//  Copyright © 2018年  xh. All rights reserved.
//

#import "NSDictionary+log.h"

@implementation NSDictionary (log)

#if DebugMode == 1

- (NSString *)descriptionWithLocale:(id)locale{
    
    NSString *logStr = @"";
    
    if ([NSJSONSerialization isValidJSONObject:self]) {
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:&error];
        NSString *json = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        logStr = [json stringByReplacingOccurrencesOfString:@"\\" withString:@""];
    }
    
    return logStr;
}


#endif

@end


@implementation NSArray (log)


#if DebugMode == 1

- (NSString *)descriptionWithLocale:(id)locale{
    NSString *logStr = @"";
    
    if ([NSJSONSerialization isValidJSONObject:self]) {
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:&error];
        NSString *json = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
        logStr = [json stringByReplacingOccurrencesOfString:@"\\" withString:@""];
    }
    
    return logStr;
}

#endif

@end
