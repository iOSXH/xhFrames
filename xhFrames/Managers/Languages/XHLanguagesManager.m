//
//  XHLanguagesManager.m
//  xhFrames
//
//  Created by hui xiang on 2018/11/13.
//  Copyright © 2018 xianghui. All rights reserved.
//

#import "XHLanguagesManager.h"

static NSString *const kAppleLanguageKey = @"AppleLanguages";
static NSString *const kUserLanguageKey = @"kUserLanguageKey";



@interface XHLanguagesManager ()

@property (nonatomic, strong) NSDictionary *languagesConfig;


@property (nonatomic, assign) XHLanguagesType currentLanguagesType;

@end

@implementation XHLanguagesManager

IMPLEMENT_SINGLETON(XHLanguagesManager, sharedManager)

- (instancetype)init{
    self = [super init];
    if (self) {
        NSString *currentLanguage = [self currentLanguage];
        if (currentLanguage && currentLanguage.length > 0) {
            NSDictionary *configs = self.languagesConfig;
            
            NSNumber *lKey = nil;
            
            for (NSNumber *key in configs.allKeys) {
                NSString *value = [configs objectForKey:key];
                if ([value isEqualToString:currentLanguage]) {
                    lKey = key;
                    break;
                }
            }
            
            if (lKey) {
                self.currentLanguagesType = [lKey integerValue];
            }
            
        }else{
            self.currentLanguagesType = XHLanguagesType_System;
        }
        
    }
    return self;
}

- (NSDictionary *)languagesConfig{
    if (!_languagesConfig) {
        _languagesConfig = @{
                             @(XHLanguagesType_SimpleChinese):@"zh-Hans",
                             @(XHLanguagesType_English):@"en"
                             };
    }
    return _languagesConfig;
}


- (void)setCurrentLanguagesType:(XHLanguagesType)currentLanguagesType{
    _currentLanguagesType = currentLanguagesType;
    
    if (self.languagesChangedBlock) {
        self.languagesChangedBlock(currentLanguagesType);
    }
    
    if ([self.delegate respondsToSelector:@selector(languagesDidChanged:)]) {
        [self.delegate languagesDidChanged:currentLanguagesType];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kLanguageDidChangeNotificationKey object:nil];
}

- (void)resetLanguage:(XHLanguagesType)type{
    
    NSString *languageStr = [self.languagesConfig objectForKey:@(type)];
    
    if (languageStr && languageStr.length > 0) {
        
        [[NSUserDefaults standardUserDefaults] setValue:languageStr forKey:kUserLanguageKey];
        [[NSUserDefaults standardUserDefaults] setValue:@[languageStr] forKey:kAppleLanguageKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        self.currentLanguagesType = type;
    }else{
        [self resetSystemLanguage];
    }
}

/**
 重置系统语言
 */
- (void)resetSystemLanguage{
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kUserLanguageKey];
    [[NSUserDefaults standardUserDefaults] setValue:nil forKey:kAppleLanguageKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    self.currentLanguagesType = XHLanguagesType_System;
}

- (NSString *)currentLanguage{
    NSString *languageStr = [[NSUserDefaults standardUserDefaults] objectForKey:kUserLanguageKey];
    
    return languageStr;
}

@end
