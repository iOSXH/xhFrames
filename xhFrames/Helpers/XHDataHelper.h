//
//  XHDataHelper.h
//  xianghui
//
//  Created by xianghui on 2018/8/14.
//  Copyright © 2018年 xh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XHDataHelper : NSObject

+ (void)deleteDataWithName:(NSString *)name;

- (instancetype)initWithName:(NSString *)name;

- (id<NSCoding>)objectForKey:(NSString *)key;
- (void)setObject:(id<NSCoding>)object forKey:(NSString *)key;
- (void)removeObjectForKey:(NSString *)key;

@end



@interface XHCommonDataHelper : XHDataHelper

DECLARE_SINGLETON(XHCommonDataHelper, sharedHelper);

@end
