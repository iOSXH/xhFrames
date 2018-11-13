//
//  HttpApiHeader.h
//  xianghui
//
//  Created by xianghui on 2018/8/14.
//  Copyright © 2018年 xh. All rights reserved.
//

#ifndef HttpApiHeader_h
#define HttpApiHeader_h



static NSString * const kApi_Base_V1 = @"/v1";

static inline NSString * kBaseApiV1Path(NSString *path){
    NSString *result = [NSString stringWithFormat:@"%@/%@", kApi_Base_V1, path];
    return result;
}


#pragma mark 用户api

static NSString * const kApi_User_LoginWechat = @"user/wechatLogin";                   ///< 用户微信登录
static NSString * const kApi_User_Logout = @"user/loginOut";                           ///< 用户登出



#pragma mark 事件api
static NSString * const kApi_Event_HotList = @"hot_event/list";                         ///< 热点事件列表
static NSString * const kApi_Event_NewsList = @"hot_event/list_resource";               ///< 热点事件文章列表
static NSString * const kApi_Event_Details = @"hot_event/statistics";                    ///< 热点事件详情


static NSString * const kApi_Article_Lists = @"article/list";                    ///< 股票文章列表



static NSString * const kApi_Subscribe_Add = @"subscribe/add";                    ///< 股票订阅
static NSString * const kApi_Subscribe_Cancel = @"subscribe/cancel";              ///< 股票订阅取消
static NSString * const kApi_Subscribe_List = @"subscribe/list";                  ///< 股票订阅列表



static NSString * const kApi_Search_AutoComplete = @"search/autoComplete";         ///< 搜索补全
static NSString * const kApi_Search_Hot = @"search/hotSearch";                     ///< 搜索热词
static NSString * const kApi_Search_History = @"search/getHistory";                ///< 搜索历史
static NSString * const kApi_Search_AddHistory = @"search/addHistory";             ///< 添加搜索历史
static NSString * const kApi_Search_ClearHistory = @"search/clearHistory";         ///< 清空搜索历史



#pragma mark 友盟api

static NSString * const kApi_Umeng_UpdateToken = @"umeng/updateUserToken";                          ///< 更新用户友盟设备token


#pragma mark 配置api

static NSString * const kApi_Config = @"internal/getConfig";                          ///< 配置



#endif /* HttpApiHeader_h */
