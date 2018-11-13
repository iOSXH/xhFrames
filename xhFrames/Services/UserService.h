//
//  UserService.h
//  xianghui
//
//  Created by xianghui on 2018/10/16.
//  Copyright © 2018 xianghui. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface UserService : NSObject

DECLARE_SINGLETON(UserService, sharedService)



/**
 登录

 @param accessToken access_token,2小时有效，过期需要刷新获取
 @param refreshToken refresh_token,30天有效，过期需要用户重新授权
 @param openId 用户OPENID
 @param type 登录方式：10：微信app；11：web方式；12：小程序
 @param changeToken 是否顶掉其他设备的登录：0:不顶掉；1:顶掉
 @param success 成功回调
 @param failure 失败回调
 */
- (void)userLoginWithAccessToken:(NSString *)accessToken
                    refreshToken:(NSString *)refreshToken
                          openId:(NSString *)openId
                            type:(NSInteger)type
                     changeToken:(NSInteger)changeToken
                         success:(void (^)(NSDictionary *account, NSString *msg))success
                         failure:(void (^)(NSError *error))failure;


/**
 微信登录

 @param success 成功回调
 @param failure 失败回调
 */
- (void)userLoginWithWechatSuccess:(void (^)(NSString *msg))success
                           failure:(void (^)(NSError *error))failure
                           state:(void (^)(NSInteger state))state;



/**
 用户登出

 @param success 成功回调
 @param failure 失败回调
 */
- (void)userLogoutSuccess:(void (^)(NSString *msg))success
                  failure:(void (^)(NSError *error))failure;


/**
 更新友盟推送token

 @param token token
 @param success 成功回调
 @param failure 失败回调
 */
- (void)userUpdateUmengPushToken:(NSString *)token
                         success:(void (^)(NSString *msg))success
                         failure:(void (^)(NSError *error))failure;


/**
 获取配置

 @param keys 配置key
 @param success 成功回调
 @param failure 失败回调
 */
- (void)appConfigsWithKeys:(NSArray *)keys
                   success:(void (^)(NSDictionary *configs, NSString *msg))success
                   failure:(void (^)(NSError *error))failure;

@end

