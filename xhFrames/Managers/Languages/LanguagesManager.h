//
//  LanguagesManager.h
//  xhFrames
//
//  Created by hui xiang on 2018/11/13.
//  Copyright © 2018 xianghui. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    LanguagesType_System = 0,     ///< 跟随系统语言
    LanguagesType_SimpleChinese,  ///< 简体中文
    LanguagesType_English,        ///< 英文
} LanguagesType;

typedef void(^LanguagesChangedBlock)(LanguagesType type);

static NSString *const kLanguageDidChangeNotificationKey = @"kLanguageDidChangeNotificationKey";

@protocol LanguagesDelegate <NSObject>

@optional
- (void)languagesDidChanged:(LanguagesType)type;

@end

@interface LanguagesManager : NSObject

DECLARE_SINGLETON(LanguagesManager, sharedManager)


/**
 语言变更block
 */
@property (nonatomic, copy) LanguagesChangedBlock languagesChangedBlock;

/**
 语言变更代理
 */
@property (nonatomic, weak) id<LanguagesDelegate> delegate;

/**
 当前语言类型
 */
@property (nonatomic, assign, readonly) LanguagesType currentLanguagesType;
@property (nonatomic, strong, readonly) NSString *currentLanguage;
@property (nonatomic, strong, readonly) NSString *appLanguage;


@property (nonatomic, strong, readonly) NSString *languageType;

/**
 重置语言

 @param type 语言类型
 */
- (void)resetLanguage:(LanguagesType)type;



@end

