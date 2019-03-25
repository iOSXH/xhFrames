//
//  CommonHelper.h
//  xianghui
//
//  Created by xianghui on 2018/8/13.
//  Copyright © 2018年 tiger. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommonHelper : NSObject

@end


@interface ToastHelper : NSObject

+ (void)showMessage:(NSString *)msg;
+ (void)showSuccess:(NSString *)msg;
+ (void)showError:(NSError *)error defaultMsg:(NSString *)defaultMsg;

@end

@interface HUDHelper : NSObject

DECLARE_SINGLETON(HUDHelper, sharedHelper)

+ (NSString *)showLoadingWithText:(NSString *)text inView:(UIView *)view;
+ (void)hideLoadingView:(NSString *)tag;
+ (void)updateLoadingView:(NSString *)tag text:(NSString *)text;


@end



@interface ImagePickerHelper : NSObject

DECLARE_SINGLETON(ImagePickerHelper, sharedHelper)

+ (void)imagePickerWithCount:(NSInteger)count complete:(void (^)(NSArray *images, NSError *error))complete;


+ (void)imageCropPickerComplete:(void (^)(UIImage *image, NSString *imageName, NSError *error))complete;


- (void)saveImage:(UIImage *)img complete:(void (^)(NSError *error))complete;
@end
