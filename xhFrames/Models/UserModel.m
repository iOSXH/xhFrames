//
//  UserModel.m
//  xianghui
//
//  Created by xianghui on 2018/10/17.
//  Copyright © 2018 xianghui. All rights reserved.
//

#import "UserModel.h"

@implementation UserModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"uid" : @"userId"};
}


@end


@implementation AccountModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"User" : @"userInfo"};
}

@end
