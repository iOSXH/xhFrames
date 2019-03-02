//
//  XHCommonHeader.h
//  xianghui
//
//  Created by xianghui on 2018/8/13.
//  Copyright © 2018年 xh. All rights reserved.
//

#ifndef XHCommonHeader_h
#define XHCommonHeader_h

#define APPName    [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"]
#define APPVersion [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]
#define APPBuild   [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]
#define APPIconPath   [[[[NSBundle mainBundle] infoDictionary] valueForKeyPath:@"CFBundleIcons.CFBundlePrimaryIcon.CFBundleIconFiles"] lastObject]
#define APPIcon    [UIImage imageNamed:APPIconPath]
#define APPBundleIdentifier [[NSBundle mainBundle] bundleIdentifier]
#define APPBundleName   [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleExecutableKey]

#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_RETINA ([[UIScreen mainScreen] scale] >= 2.0)
//判断是否为iPhoneX及以上机型 ios11
//#define IS_GREATER_IPHONEX ([[[UIApplication sharedApplication] delegate] window].safeAreaInsets.bottom > 0.0)

#define IOS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue] //系统版本-float

#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))

#define kStatusBarHeight ([[UIApplication sharedApplication] statusBarFrame].size.height)
#define IS_IPHONE_X (kStatusBarHeight >= 44.0f)
#define kNavigationBarNormalHeight (44)
#define kNavigationBarHeight (kNavigationBarNormalHeight + kStatusBarHeight)
#define kBottomSafeAreaHeight (IS_IPHONE_X?34:0)
//#define kSafeAreaBottomHeight ([[[UIApplication sharedApplication] delegate] window].safeAreaInsets.bottom)
#define kTabBarNormalHeight (49)
#define kTabBarHeight (kTabBarNormalHeight+kBottomSafeAreaHeight)

#pragma mark - 图片资源获取
#define kIMGFROMBUNDLE( X )     [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:X ofType:@""]]
#define kImageNamed( X )         [UIImage imageNamed:X]

#define kScale (SCREEN_WIDTH/375.0)
#define kIPadScale (IS_IPAD?1:kScale)


#define kMinScale (SCREEN_MIN_LENGTH/375.0)
#define kIPadMinScale (IS_IPAD?1:kMinScale)


#pragma mark - 单例
#define DECLARE_SINGLETON(cls_name, method_name)\
+ (cls_name*)method_name;


#define IMPLEMENT_SINGLETON(cls_name, method_name)\
+ (cls_name *)method_name {\
static cls_name *method_name;\
static dispatch_once_t onceToken;\
dispatch_once(&onceToken, ^{\
method_name = [[cls_name alloc] init];\
});\
return method_name;\
}


#pragma mark - 静态方法
static inline CGFloat sizeScale(CGFloat size, BOOL adjustIpad){
    size = size * (adjustIpad?kIPadMinScale:kMinScale);
    return size;
}

static inline UIFont* systemFontScale(CGFloat size, BOOL adjustIpad){
    UIFont *font = [UIFont systemFontOfSize:sizeScale(size, YES)];
    return font;
}


static inline BOOL emptyString(NSString *str){
    if (!str) {
        return YES;
    }
    if (![str isKindOfClass:[NSString class]]) {
        return YES;
    }
    
    if (str.length == 0) {
        return YES;
    }
    
    return NO;
}

static inline NSString * getString(id str){
    if (!str || [str isKindOfClass:[NSNull class]]) {
        return @"";
    }
    if (![str isKindOfClass:[NSString class]]) {
        return [NSString stringWithFormat:@"%@", str];
    }
    return str;
}


#pragma mark - 基本数据常量
#if DebugMode
static const DDLogLevel ddLogLevel = DDLogLevelDebug;
#else
static const DDLogLevel ddLogLevel = DDLogLevelOff;
#endif

static const int kDefaultMargin = 7;


#pragma mark - 字符串常量

static NSString *const Font_TimesNewRoman = @"Times New Roman";

static NSString * const kApi_Base_Url = @"https://sentiment-miniapp.tigerobo.com"; ///< 生产环境
static NSString * const kApi_Base_Url_Dev = @"http://10.0.3.33:8080";       ///< 测试环境

static NSString * const kUMAPPKEY = @"5bd191ceb465f5d19200008d";            ///< 友盟APPKEY
static NSString * const kWXAPPID = @"wx96617c9e3ce7a75f";                   ///< 微信APPID
static NSString * const kWXAPPKEY = @"9e16c3c0417b9ec50ddc8b0015909242";    ///< 微信APPKEY

static NSString * const kFanYiAPPKEY = @"6a028ed09028d601";    ///< 翻译APPKEY

static NSString * const kBUGLYAPPID = @"5d13442bae";                   ///< buglyAPPID


static NSString * const kUserAgreementURL = @"https://sentiment-article.oss-cn-shanghai.aliyuncs.com/html/sentiment-agreement.html";


static NSString * const kWXMinProgramName = @"gh_8a9f35964317";                         ///< 微信小程序id
static NSString * const kWXMinProgramPage_UserProfile = @"/pages/u-p/main";    ///< 微信小程序-个人主页
static NSString * const kWXMinProgramPage_CommentUser = @"/pages/c-u/main";    ///< 微信小程序-评价一个用户
static NSString * const kWXMinProgramPage_Kefu = @"/pages/tokefu/main";                 ///< 微信小程序-去客服引导页


static NSString * const kIAPProductID = @"com.xianghui.vip.product.%@";              ///< IAP产品id



static NSString * const kImageDefaultAvatar = @"icon_user_avatarDefault";                        ///< 默认头像
static NSString * const kImageDefaultCover = @"icon_user_coverDefault";                          ///< 默认cover

#pragma mark - 枚举
typedef enum{
    UserSex_undefine = 0,
    UserSex_Man,
    UserSex_Woman
}UserSex;

#pragma mark - 通知中心keys
static NSString * const kNotification = @"kNotification";




#endif /* XHCommonHeader_h */
