//
//  LanguagesManager.m
//  xhFrames
//
//  Created by hui xiang on 2018/11/13.
//  Copyright © 2018 xianghui. All rights reserved.
//

#import "LanguagesManager.h"

static NSString *const kAppleLanguageKey = @"AppleLanguages";
static NSString *const kUserLanguageKey = @"kUserLanguageKey";



@interface LanguagesManager ()

@property (nonatomic, strong) NSDictionary *languagesConfig;


@property (nonatomic, assign) LanguagesType currentLanguagesType;
@property (nonatomic, strong) NSString *languageType;

@end

@implementation LanguagesManager

IMPLEMENT_SINGLETON(LanguagesManager, sharedManager)

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
            self.currentLanguagesType = LanguagesType_System;
        }
        
    }
    return self;
}

- (NSDictionary *)languagesConfig{
    if (!_languagesConfig) {
        _languagesConfig = @{
                             @(LanguagesType_SimpleChinese):@"zh-Hans",
                             @(LanguagesType_English):@"en"
                             };
    }
    return _languagesConfig;
}


- (void)setCurrentLanguagesType:(LanguagesType)currentLanguagesType{
    _currentLanguagesType = currentLanguagesType;
    
    if (self.languagesChangedBlock) {
        self.languagesChangedBlock(currentLanguagesType);
    }
    
    if ([self.delegate respondsToSelector:@selector(languagesDidChanged:)]) {
        [self.delegate languagesDidChanged:currentLanguagesType];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kLanguageDidChangeNotificationKey object:nil];
    
    
    [self resetLanguageType];
}

- (void)resetLanguage:(LanguagesType)type{
    
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
    
    self.currentLanguagesType = LanguagesType_System;
}

- (NSString *)currentLanguage{
    NSString *languageStr = [[NSUserDefaults standardUserDefaults] objectForKey:kUserLanguageKey];
    
    return languageStr;
}


- (NSString *)appLanguage{
    NSArray *appLanguages = [[NSUserDefaults standardUserDefaults] objectForKey:kAppleLanguageKey];
    NSString *languageStr = [appLanguages firstObject];
    return languageStr;
}


- (void)resetLanguageType{
    NSInteger type = LanguagesType_SimpleChinese;
    if (self.currentLanguagesType == LanguagesType_System) {
        
        NSString *appLanguage = self.appLanguage;
        
        NSDictionary *configs = self.languagesConfig;
        
        NSNumber *lKey = nil;
        
        for (NSNumber *key in configs.allKeys) {
            NSString *value = [configs objectForKey:key];
            if ([value isEqualToString:appLanguage]) {
                lKey = key;
                break;
            }
        }
        
        if (lKey) {
            type = [lKey integerValue];
        }
    }
    
    NSString *lType = [self.languagesConfig objectForKey:@(type)];
    
    self.languageType = getString(lType);
}

@end
