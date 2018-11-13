//
//  UserModel.h
//  xianghui
//
//  Created by xianghui on 2018/10/17.
//  Copyright © 2018 xianghui. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserModel : NSObject

@property (nonatomic, assign) NSInteger uid;                    ///< 用户id
@property (nonatomic, strong) NSString *nickName;               ///< 用户昵称
@property (nonatomic, strong) NSString *avatar;                 ///< 用户头像
@property (nonatomic, assign) NSInteger sex;                    ///< 用户性别 1 男
@property (nonatomic, strong) NSDate *createTime;               ///< 用户加入本APP时间
@property (nonatomic, strong) NSString *unionid;                ///<
@property (nonatomic, strong) NSString *openid;                 ///<
@property (nonatomic, strong) NSString *mobile;                 ///< 手机号
@property (nonatomic, assign) NSInteger parentId;               ///< 用户主账户id
@property (nonatomic, assign) NSInteger status;                 ///<


@end



@interface AccountModel : NSObject

@property (nonatomic, strong) UserModel *User;                ///< 用户
@property (nonatomic, strong) NSString *token;                  ///< 用户token
@property (nonatomic, assign) NSInteger isNew;                  ///< 用户

@end
