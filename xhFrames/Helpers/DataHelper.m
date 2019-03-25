//
//  DataHelper.m
//  xianghui
//
//  Created by xianghui on 2018/8/14.
//  Copyright © 2018年 xh. All rights reserved.
//

#import "DataHelper.h"
#import <YYCache.h>


@interface DataHelper ()

@property (nonatomic, strong) YYCache *cache;

@end

@implementation DataHelper

+ (void)deleteDataWithName:(NSString *)name{
    
    NSString *cacheFolder = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *path = [cacheFolder stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_db", name]];

    [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
}

- (instancetype)initWithName:(NSString *)name{
    self = [super init];
    if (self) {
        
        NSString *cacheFolder = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
        NSString *path = [cacheFolder stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_db", name]];
        
        self.cache = [[YYCache alloc] initWithPath:path];
    }
    return self;
}

- (void)setObject:(id<NSCoding>)object forKey:(NSString *)key{
    [self.cache setObject:object forKey:key];
}

- (id<NSCoding>)objectForKey:(NSString *)key{
    return [self.cache objectForKey:key];
}

- (void)removeObjectForKey:(NSString *)key{
    [self.cache removeObjectForKey:key];
}


@end



@implementation CommonDataHelper

IMPLEMENT_SINGLETON(CommonDataHelper, sharedHelper)

- (instancetype)init{
    self = [super initWithName:APPBundleName];
    if (self) {

    }
    return self;
}

@end


