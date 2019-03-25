//
//  DataHelper.h
//  xianghui
//
//  Created by xianghui on 2018/8/14.
//  Copyright © 2018年 xh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataHelper : NSObject

+ (void)deleteDataWithName:(NSString *)name;

- (instancetype)initWithName:(NSString *)name;

- (id<NSCoding>)objectForKey:(NSString *)key;
- (void)setObject:(id<NSCoding>)object forKey:(NSString *)key;
- (void)removeObjectForKey:(NSString *)key;

@end



@interface CommonDataHelper : DataHelper

DECLARE_SINGLETON(CommonDataHelper, sharedHelper);

@end
