//
//  AccountManager.h
//  xianghui
//
//  Created by xianghui on 2018/10/13.
//  Copyright © 2018 xianghui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserModel.h"

static NSString * const kAccountLoginSuccessKey = @"kAccountLoginSuccessKey";
static NSString * const kAccountLogoutKey = @"kAccountLogoutKey";

static NSString * const kAccountUserInfoDidChangeKey = @"kAccountUserInfoDidChangeKey";

static NSString * const kAppConfigInfoDidChangeKey = @"kAppConfigInfoDidChangeKey";



static NSString * const kAppConfigInfoKey_IOSReviewBuild = @"ios_review_build";


typedef enum : NSUInteger {
    LoginState_Unknow,
    LoginState_In,
    LoginState_Out,
} LoginState;

typedef void(^TSAppConfigBlock)();

@interface AccountManager : NSObject

DECLARE_SINGLETON(AccountManager, sharedManager)

@property (nonatomic, strong, readonly) AccountModel *account;

@property (nonatomic, strong, readonly) NSDictionary *apiHeader;

@property (nonatomic, assign) LoginState loginState;         ///< 登录状态 0 undefined  1 登录 2 登出

@property (nonatomic, strong) NSString *deviceToken;

@property (nonatomic, strong, readonly) NSDictionary *appConfigs;

@property (nonatomic, copy) TSAppConfigBlock appConfigBlock;

+ (BOOL)appReview;


/**
 初始化登录状态  启动app时调用 保持登录状态
 */
- (void)initLoginState;


/**
 登录成功 并保存用户数据
 
 @param data 用户数据
 */
- (void)loginSuccessWithData:(NSDictionary *)data;


/**
 登出
 */
- (void)logout;


/**
 更新account
 
 @param user 用户model
 */
- (void)updateAccountWithUser:(UserModel *)user;


/**
 存储用户数据
 
 @param data 数据
 @param key key
 */
- (void)saveUserData:(id)data forKey:(NSString *)key;


/**
 获取本地用户数据
 
 @param key key
 @return 数据
 */
- (id)userDatafromKey:(NSString *)key;



- (void)updateAppConfig:(NSDictionary *)dic;

- (void)updateDeviceToken;

@end

