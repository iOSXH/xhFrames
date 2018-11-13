//
//  NSString+helper.h
//  xianghui
//
//  Created by xianghui on 2018/8/14.
//  Copyright © 2018年  xh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (helper)

#pragma mark 类方法

/**
 随机字符串

 @param length 长度
 @return 字符串
 */
+ (NSString *)randomStringWithLength: (NSUInteger)length;
+ (NSString *)randomSmallStringWithLength: (NSUInteger)length;


/**
 字符串长度 英文1个 中文2个

 @return 长度
 */
- (NSUInteger)textLength;


/**
 根据图片地址获取裁剪位置大小

 @return 裁剪位置大小
 */
- (CGRect)imageCropRect;


/**
 裁剪过的图片url

 @return 图片url
 */
- (NSURL *)URLAutoCrop;


/**
 根据图片地址获取原图大小

 @return 原图大小
 */
- (CGSize)imageSize;


/**
 图片缩略图

 @param size 缩略大小
 @return 图片地址
 */
- (NSURL *)URLWithSize:(CGSize)size;


/**
 对七牛图片资源url进行处理
 
 @param size 裁剪的大小
 @param contentMode 模式
 @param cornerRadius 圆角
 @return 图片url
 */
//- (NSURL *)URLWithsize:(CGSize)size contentMode:(UIViewContentMode)contentMode cornerRadius:(CGFloat)cornerRadius;


/**
 根据日期生成星座

 @param date 日期
 @return 星座字符串
 */
+ (NSString *)astroWithDate:(NSDate *)date;



/**
 中文URL处理

 @return url
 */
- (NSURL *)URLByCheckCharacter;



/**
 日期格式化

 @param date 日期
 @return 格式化后的字符串
 */
+ (NSString *)timeStringWithDate:(NSDate *)date;


+ (NSString *)timeString:(NSTimeInterval)time;


+ (NSString *)timeString:(NSTimeInterval)time format:(NSString *)format;


/**
 距离格式化

 @param dis 距离 单位m
 @return 字符串
 */
+ (NSString *)distanceStrWithDis:(NSInteger)dis;




+ (NSString *)uniqID;
+ (NSString *)advertisingUUID;
+ (NSString *)macString;

@end
