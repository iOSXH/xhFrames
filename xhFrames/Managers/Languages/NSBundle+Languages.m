//
//  NSBundle+Languages.m
//  xhFrames
//
//  Created by hui xiang on 2018/11/13.
//  Copyright © 2018 xianghui. All rights reserved.
//

#import "NSBundle+Languages.h"
#import <objc/runtime.h>

#import "LanguagesManager.h"


@interface LanguagesBundle : NSBundle

@end


@implementation NSBundle (Languages)

+ (BOOL)isChineseLanguage
{
    NSString *currentLanguage = [self currentLanguage];
    if ([currentLanguage hasPrefix:@"zh-Hans"]) {
        return YES;
    } else {
        return NO;
    }
}

+ (NSString *)currentLanguage
{
    return [[LanguagesManager sharedManager] currentLanguage] ? : [NSLocale preferredLanguages].firstObject;
}


+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //动态继承、交换，方法类似KVO，通过修改[NSBundle mainBundle]对象的isa指针，使其指向它的子类DABundle，这样便可以调用子类的方法；其实这里也可以使用method_swizzling来交换mainBundle的实现，来动态判断，可以同样实现。
        object_setClass([NSBundle mainBundle], [LanguagesBundle class]);
    });
}

@end



@implementation LanguagesBundle

- (NSString *)localizedStringForKey:(NSString *)key value:(NSString *)value table:(NSString *)tableName
{
    if ([LanguagesBundle kMainBundle]) {
        return [[LanguagesBundle kMainBundle] localizedStringForKey:key value:value table:tableName];
    } else {
        return [super localizedStringForKey:key value:value table:tableName];
    }
}

+ (NSBundle *)kMainBundle
{
    if ([NSBundle currentLanguage].length) {
        NSString *path = [[NSBundle mainBundle] pathForResource:[NSBundle currentLanguage] ofType:@"lproj"];
        if (path.length) {
            return [NSBundle bundleWithPath:path];
        }
    }
    return nil;
}

@end
