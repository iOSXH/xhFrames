//
//  UserService.m
//  xianghui
//
//  Created by xianghui on 2018/10/16.
//  Copyright © 2018 xianghui. All rights reserved.
//

#import "UserService.h"
#import "BaseHttpService.h"
//#import <UMShare/UMShare.h>

@implementation UserService

IMPLEMENT_SINGLETON(UserService, sharedService)

- (void)userLoginWithAccessToken:(NSString *)accessToken refreshToken:(NSString *)refreshToken openId:(NSString *)openId type:(NSInteger)type changeToken:(NSInteger)changeToken success:(void (^)(NSDictionary * _Nonnull, NSString * _Nonnull))success failure:(void (^)(NSError * _Nonnull))failure{
//
    [[BaseHttpService shareService] postRequestWithPath:kApi_User_LoginWechat parameter:@{@"code":accessToken,@"refreshToken":refreshToken,@"openId":openId,@"changeToken":@(changeToken)} complete:^(ResultModel *requestResult, NSError *error) {
        if (error) {
            if (failure) {
                failure(error);
            }
        }else{
            if (success) {
                success(requestResult.data, requestResult.msg);
            }
        }
    }];
}


- (void)userLoginWithWechatSuccess:(void (^)(NSString * _Nonnull))success failure:(void (^)(NSError * _Nonnull))failure state:(nonnull void (^)(NSInteger))state{

//    [[UMSocialManager defaultManager] getUserInfoWithPlatform:UMSocialPlatformType_WechatSession currentViewController:nil completion:^(id result, NSError *error) {
//        
//        if (error) {
//            if (failure) {
//                failure(error);
//            }
//            return;
//        }
//        
//        if (state) {
//            state(1);
//        }
//        
//        UMSocialUserInfoResponse *resp = result;
//        
//        [[UserService sharedService] userLoginWithAccessToken:resp.accessToken refreshToken:resp.refreshToken openId:resp.openid type:10 changeToken:1 success:^(NSDictionary * _Nonnull account, NSString * _Nonnull msg) {
//            
//            [[AccountManager sharedManager] loginSuccessWithData:account];
//            
//            if (success) {
//                success(msg);
//            }
//        } failure:failure];
//    }];
}


- (void)userLogoutSuccess:(void (^)(NSString *))success failure:(void (^)(NSError *))failure{
    
    if ([AccountManager appReview]) {
        return;
    }
    
    [[BaseHttpService shareService] postRequestWithPath:kApi_User_Logout parameter:nil complete:^(ResultModel *requestResult, NSError *error) {
        if (error) {
            if (failure) {
                failure(error);
            }
        }else{
            if (success) {
                success(requestResult.msg);
            }
        }
    }];
}

- (void)userUpdateUmengPushToken:(NSString *)token success:(void (^)(NSString *))success failure:(void (^)(NSError *))failure{
    [[BaseHttpService shareService] postRequestWithPath:kBaseApiV1Path(kApi_Umeng_UpdateToken) parameter:@{@"deviceToken":getString(token)} complete:^(ResultModel *requestResult, NSError *error) {
        if (error) {
            if (failure) {
                failure(error);
            }
        }else{
            if (success) {
                success(requestResult.msg);
            }
        }
    }];
}

- (void)appConfigsWithKeys:(NSArray *)keys success:(void (^)(NSDictionary *, NSString *))success failure:(void (^)(NSError *))failure{
//    if (keys.count <= 0) {
//        keys = @[kAppConfigInfoKey_IOSReviewBuild];
//    }
    
    [[BaseHttpService shareService] postRequestWithPath:kApi_Config parameter:(keys.count<=0?@{}:@{@"keys":keys}) complete:^(ResultModel *requestResult, NSError *error) {
        if (error) {
            if (failure) {
                failure(error);
            }
        }else{
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];

            for (NSDictionary *config in requestResult.data) {
                NSString *key = [config objectForKey:@"key"];
                [dic setObject:config forKey:key];
            }
            
            [[AccountManager sharedManager] updateAppConfig:dic];
            
            if (success) {
                success(dic, requestResult.msg);
            }
        }
    }];
    
}

@end
