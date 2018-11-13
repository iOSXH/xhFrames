//
//  XHLanguagesManager.h
//  xhFrames
//
//  Created by hui xiang on 2018/11/13.
//  Copyright © 2018 xianghui. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    XHLanguagesType_System = 0,     ///< 跟随系统语言
    XHLanguagesType_SimpleChinese,  ///< 简体中文
    XHLanguagesType_English,        ///< 英文
} XHLanguagesType;

typedef void(^XHLanguagesChangedBlock)(XHLanguagesType type);

static NSString *const kLanguageDidChangeNotificationKey = @"kLanguageDidChangeNotificationKey";

@protocol XHLanguagesDelegate <NSObject>

@optional
- (void)languagesDidChanged:(XHLanguagesType)type;

@end

@interface XHLanguagesManager : NSObject

DECLARE_SINGLETON(XHLanguagesManager, sharedManager)


/**
 语言变更block
 */
@property (nonatomic, copy) XHLanguagesChangedBlock languagesChangedBlock;

/**
 语言变更代理
 */
@property (nonatomic, weak) id<XHLanguagesDelegate> delegate;

/**
 当前语言类型
 */
@property (nonatomic, assign, readonly) XHLanguagesType currentLanguagesType;
@property (nonatomic, strong, readonly) NSString *currentLanguage;


/**
 重置语言

 @param type 语言类型
 */
- (void)resetLanguage:(XHLanguagesType)type;



@end

