//
//  AppTrackHelper.m
//  xianghui
//
//  Created by xianghui on 2018/10/17.
//  Copyright © 2018 xianghui. All rights reserved.
//

#import "AppTrackHelper.h"
#import <UMAnalytics/MobClick.h>
#import <UMCommon/UMCommon.h>

@implementation AppTrackHelper



IMPLEMENT_SINGLETON(AppTrackHelper, sharedHelper);

- (void)configUmeng{
//    [UMConfigure initWithAppkey:kUMAPPKEY channel:@"App Store"];
    
    if (DebugMode) {
        [UMConfigure setLogEnabled:YES];
        [UMConfigure setEncryptEnabled:YES];
    }
}

+ (void)event:(NSString *)eventId attributes:(NSDictionary *)attributes{
    if (![eventId hasPrefix:@"UM"]) {
        eventId = [NSString stringWithFormat:@"UM%@", eventId];
    }
    [MobClick event:eventId attributes:attributes];
}

+ (void)beginLogPageView:(NSString *)pageName{
    [MobClick beginLogPageView:pageName];
}

+ (void)endLogPageView:(NSString *)pageName{
    [MobClick endLogPageView:pageName];
}

@end
