//
//  AccountManager.m
//  xianghui
//
//  Created by xianghui on 2018/10/13.
//  Copyright © 2018 xianghui. All rights reserved.
//

#import "AccountManager.h"
#import "DataHelper.h"
#import "BaseHttpService.h"


static NSString * const kAccountLastLoginUidKey = @"kAccountLastLoginUidKey";
static NSString * const kAccountKey = @"account";

static NSString * const kAccountLoginUidsKey = @"kAccountLoginUidsKey";


static NSString * const kAppConfigKey = @"kAppConfigKey";


@interface AccountManager ()
@property (nonatomic, strong) AccountModel *account;      ///< 用户数据

@property (nonatomic, strong) DataHelper *dataHelper;     ///< 数据存储工具

@property (nonatomic, assign) NSInteger lastLoginUid;       ///< 上传登录的uid


@property (nonatomic, strong) NSDictionary *appConfigs;

@end

@implementation AccountManager

IMPLEMENT_SINGLETON(AccountManager, sharedManager);


- (instancetype)init{
    self = [super init];
    if (self) {
        [[BaseHttpService shareService] setNetChangeBlock:^(NetWorkStatus netWorkSatus) {
            if (netWorkSatus != NetWorkStatusNotReachable) {
                [self updateAppConfigs];
            }
        }];
    }
    return self;
}



#pragma mark getter/setter
- (NSDictionary *)apiHeader{
    
    NSString *token = getString(self.account.token);
    
    NSDictionary *header = @{@"CONTENT-TYPE":@"application/json",
                             @"DEVICE_ID":[NSString uniqID],
                             @"X_CLIENT_PLATFORM":@"iOS",
                             @"API_AUTHORIZATION":token
                             };
    
    return header;
}


- (NSInteger)lastLoginUid{
    NSInteger uid = [[NSUserDefaults standardUserDefaults] integerForKey:kAccountLastLoginUidKey];
    return uid;
}

- (void)setLastLoginUid:(NSInteger)lastLoginUid{
    [[NSUserDefaults standardUserDefaults] setInteger:lastLoginUid forKey:kAccountLastLoginUidKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    if (lastLoginUid > 0) {
        NSMutableSet *loginUids = [NSMutableSet setWithSet:(NSSet *)[[CommonDataHelper sharedHelper] objectForKey:kAccountLoginUidsKey]];
        [loginUids addObject:[NSString stringWithFormat:@"%@", @(lastLoginUid)]];
        [[CommonDataHelper sharedHelper] setObject:loginUids forKey:kAccountLoginUidsKey];
    }
}

- (void)setLoginState:(LoginState)loginState{
    _loginState = loginState;
    
    if (loginState == LoginState_In) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kAccountLoginSuccessKey object:nil];
        [self updateDeviceToken];
    }else if (loginState == LoginState_Out){
        [[NSNotificationCenter defaultCenter] postNotificationName:kAccountLogoutKey object:nil];
    }
}



#pragma mark public method
- (void)updateAccountWithUser:(UserModel *)user{
    self.account.User = user;
    NSDictionary *data = [self.account modelToJSONObject];
    [self.dataHelper setObject:data forKey:kAccountKey];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kAccountUserInfoDidChangeKey object:nil];
}

- (void)initLoginState{
    if (self.loginState != LoginState_Unknow) {
        return;
    }
    
    NSInteger lastLoginUid = self.lastLoginUid;
    if (lastLoginUid > 0) {
        
        self.dataHelper = [[DataHelper alloc] initWithName:[NSString stringWithFormat:@"%@_%@", kAccountKey, @(lastLoginUid)]];
        
        NSDictionary *data = (NSDictionary *)[self.dataHelper objectForKey:kAccountKey];
        AccountModel *account = [AccountModel modelWithDictionary:data];
        
        if (account.User.uid > 0) {
            
            self.account = account;
            
            self.loginState = LoginState_In;
        }
        
    }else{
        
    }
    
    [self updateAppConfigs];
}


- (void)updateAppConfigs{
    [[UserService sharedService] appConfigsWithKeys:nil success:nil failure:nil];
}

- (void)loginSuccessWithData:(NSDictionary *)data{
    
    AccountModel *account = [AccountModel modelWithDictionary:data];
    if (account) {
        self.dataHelper = [[DataHelper alloc] initWithName:[NSString stringWithFormat:@"%@_%@", kAccountKey, @(account.User.uid)]];
        
        [self.dataHelper setObject:data forKey:kAccountKey];
        
        [self setLastLoginUid:account.User.uid];
        
        self.account = account;
        
        self.loginState = LoginState_In;
    }else{
        [self logout];
    }
}

- (void)logout{
//    if (self.loginState == LoginState_Out) {
//        return;
//    }
    if (self.loginState == LoginState_In && !emptyString(self.account.token)) {
        [[UserService sharedService] userLogoutSuccess:nil failure:nil];
    }
    
    self.loginState = LoginState_Out;
    self.account = nil;
    self.lastLoginUid = 0;
}


- (void)saveUserData:(id)data forKey:(NSString *)key{
    [self.dataHelper setObject:data forKey:key];
}

- (id)userDatafromKey:(NSString *)key{
    return [self.dataHelper objectForKey:key];
}


- (void)updateAppConfig:(NSDictionary *)dic{
    self.appConfigs = dic;
    
    [[CommonDataHelper sharedHelper] setObject:dic forKey:kAppConfigKey];
    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kAppConfigInfoDidChangeKey object:nil];
    
    if (self.appConfigBlock) {
        self.appConfigBlock();
        self.appConfigBlock = nil;
    }
}


+ (BOOL)appReview{
    BOOL review = NO;
    NSDictionary *appConfigs = [AccountManager sharedManager].appConfigs;
    if (appConfigs.count > 0) {
        NSDictionary *dic = [appConfigs objectForKey:kAppConfigInfoKey_IOSReviewBuild];
        if (dic.count > 0) {
            NSString *value = [dic objectForKey:@"value"];
            if ([value isEqualToString:getString(APPBuild)]) {
                review = YES;
            }
        }
    }else{
        review = YES;
    }
    
    return review;
}


- (void)updateDeviceToken{
    if (emptyString(self.deviceToken)) {
        return;
    }
    
    [[UserService sharedService] userUpdateUmengPushToken:self.deviceToken success:nil failure:nil];
}

@end
