//
//  CommonHelper.m
//  xianghui
//
//  Created by xianghui on 2018/8/13.
//  Copyright © 2018年 xh. All rights reserved.
//

#import "CommonHelper.h"
#import "HttpServiceHeader.h"
#import <lottie-ios/Lottie/Lottie.h>
#import "IntrinsicView.h"
#import <AssetsLibrary/AssetsLibrary.h>

@implementation CommonHelper

@end


@implementation ToastHelper

+ (void)showToastHUD:(NSString *)msg{
    
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    MBProgressHUD *hub = [MBProgressHUD showHUDAddedTo:window animated:YES];
    hub.mode = MBProgressHUDModeText;
    hub.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hub.bezelView.color = [[UIColor blackColor] colorWithAlphaComponent:0.6];
    hub.bezelView.layer.cornerRadius = 8;
    hub.label.textColor = [UIColor whiteColor];
    hub.label.numberOfLines = 0;
    hub.label.textAlignment = NSTextAlignmentLeft;
    hub.label.font = [UIFont systemFontOfSize:15];
    hub.label.text = msg;
//    hub.userInteractionEnabled = NO;
    [hub hideAnimated:YES afterDelay:3.0];
    
    [hub bk_whenTapped:^{
        [hub hideAnimated:YES];
    }];
}

+ (void)showMessage:(NSString *)msg{
    if (emptyString(msg)) {
        return;
    }
    [self showToastHUD:msg];
}

+ (void)showSuccess:(NSString *)msg{
    
    if (emptyString(msg)) {
        return;
    }
    [self showToastHUD:msg];
}

+ (void)showError:(NSError *)error defaultMsg:(NSString *)defaultMsg{
    NSString *msg = errorMsg(error, defaultMsg);
    if (emptyString(msg)) {
        return;
    }
    [self showToastHUD:msg];
}

@end

@interface  HUDHelper ()

@property (nonatomic, strong) NSMutableDictionary *hudsDic;

@end

@implementation HUDHelper

IMPLEMENT_SINGLETON(HUDHelper, sharedHelper)

- (instancetype)init{
    self = [super init];
    if (self) {
        [UIActivityIndicatorView appearanceWhenContainedIn:[MBProgressHUD class], nil].color = [UIColor whiteColor];
        self.hudsDic = [[NSMutableDictionary alloc] init];
    }
    return self;
}

+ (NSString *)randomTag{
    NSString *tag = [NSString randomStringWithLength:4];
    NSMutableDictionary *hudsDic = [HUDHelper sharedHelper].hudsDic;
    if (hudsDic && hudsDic.count > 0) {
        if ([hudsDic.allKeys containsObject:tag]) {
            tag = [self randomTag];
        }
    }
    
    return tag;
}


+ (NSString *)showLoadingWithText:(NSString *)text inView:(UIView *)view{
    NSString *tag = [self randomTag];
    
    if (!view) {
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        view = window;
    }
    
    
    IntrinsicView *customView = [[IntrinsicView alloc] initWithFrame:CGRectMake(0, 0, 80, 60)];
    
    LOTAnimationView *refreshView = [LOTAnimationView animationNamed:@"refresh_white"];
    refreshView.loopAnimation = YES;
    refreshView.frame = CGRectMake(0, 0, 25, 25);
//    refreshView.transform = CGAffineTransformMakeScale(0.5, 0.5);
    [customView addSubview:refreshView];
    refreshView.center = customView.center;
    
    MBProgressHUD *hub = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hub.minSize = CGSizeMake(85, 85);
    hub.customView = customView;
    hub.mode = MBProgressHUDModeCustomView;
    hub.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hub.bezelView.color = [[UIColor blackColor] colorWithAlphaComponent:0.7];
    hub.label.textColor = [UIColor whiteColor];
    hub.label.font = [UIFont systemFontOfSize:13];
    hub.label.text = text;
    
    [refreshView playWithCompletion:^(BOOL animationFinished) {
        
    }];
    
    [[HUDHelper sharedHelper].hudsDic setObject:hub forKey:tag];
    
    return tag;
}

+ (void)hideLoadingView:(NSString *)tag{
    if (emptyString(tag)) {
        for (MBProgressHUD *hub in [HUDHelper sharedHelper].hudsDic.allValues) {
            [hub hideAnimated:NO];
        }
        [[HUDHelper sharedHelper].hudsDic removeAllObjects];
    }else{
        MBProgressHUD *hub = [[HUDHelper sharedHelper].hudsDic objectForKey:tag];
        if (hub) {
            [hub hideAnimated:YES];
            [[HUDHelper sharedHelper].hudsDic removeObjectForKey:tag];
        }
    }
}

+ (void)updateLoadingView:(NSString *)tag text:(NSString *)text{
    if (!emptyString(tag)) {
        
        MBProgressHUD *hub = [[HUDHelper sharedHelper].hudsDic objectForKey:tag];
        if (hub) {
            hub.label.text = text;
        }
    }
}

@end




@interface ImagePickerHelper ()



@end

@implementation ImagePickerHelper
{
    void (^saveImgBlock)(NSError *error);
}

IMPLEMENT_SINGLETON(ImagePickerHelper, sharedHelper)

+ (void)imagePickerWithCount:(NSInteger)count complete:(void (^)(NSArray *, NSError *))complete{
    
    
}

+ (void)imageCropPickerComplete:(void (^)(UIImage *, NSString *, NSError *))complete{
    
    
}


+ (NSString *)imageNameWithOrginImage:(UIImage *)image cropedRect:(CGRect)rect{
    //http://s.same.com/image/518979f5f843cbacfc0444e98286f7e6__c0_89_640_640__w640_h819.jpg
    //    NSString *imageName = [NSString stringWithFormat:@"ios%@%.0f_w%.0f_h%.0f.png", [NSString randomStringWithLength:4], [NSDate date].timeIntervalSince1970*1000, self.imageData.size.width, self.imageData.size.height];
    
    if (!image) {
        return nil;
    }
    
    //    BOOL cropError = NO;
    //    if (rect.origin.x < 0
    //        || rect.origin.y < 0
    //        || rect.origin.x + rect.size.width > image.size.width
    //        || rect.origin.y + rect.size.height > image.size.height) {
    //        cropError = YES;
    //    }
    //
    //    if (cropError) {
    //        rect = CGRectMake(0, 0, image.size.width, image.size.height);
    //    }
    
    
    //    NSString *imageName = [NSString stringWithFormat:@"ios%@%.0f__c%.0f_%.0f_%.0f_%.0f__w%.0f_h%.0f.png", [NSString randomSmallStringWithLength:4], [NSDate date].timeIntervalSince1970*1000, rect.origin.x, rect.origin.y, rect.size.width, rect.size.height, image.size.width, image.size.height];
    
    NSString *imageName = [NSString stringWithFormat:@"ios%@%.0f__w%.0f_h%.0f.png", [NSString randomSmallStringWithLength:4], [NSDate date].timeIntervalSince1970*1000, image.size.width, image.size.height];
    
    return imageName;
}










- (void)saveImage:(UIImage *)img complete:(void (^)(NSError *error))complete{
    if (img) {
        ALAuthorizationStatus status = [ALAssetsLibrary authorizationStatus];
        if (status == ALAuthorizationStatusAuthorized) {
            saveImgBlock = complete;
            NSData* imdata =  UIImagePNGRepresentation (img); // get PNG representation
            UIImage* im2 = [UIImage imageWithData:imdata]; // wrap UIImage around PNG representat
            UIImageWriteToSavedPhotosAlbum(im2,  self,
                                           @selector(thisImage:hasBeenSavedInPhotoAlbumWithError:usingContextInfo:),
                                           NULL);
        }else if (status == ALAuthorizationStatusNotDetermined){
            ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
            [library enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
                // Got access! Show login
                if (group) {
                    [self saveImage:img complete:complete];
                }
                *stop = YES;
                
                
            } failureBlock:^(NSError *error) {
                // User denied access
                [self saveImage:img complete:complete];
            }];
        }
        else{
            NSError *error = errorBuild(1, kCostomErrorDomain, kLocString(@"保存失败，请检查权限"));
            if (complete) {
                complete(error);
            }
        }
        
    }else{
        NSError *error = errorBuild(0, kCostomErrorDomain, @"");
        if (complete) {
            complete(error);
        }
    }
}

- (void)thisImage:(UIImage *)image hasBeenSavedInPhotoAlbumWithError:(NSError *)error usingContextInfo:(void*)ctxInfo {
    
    if (error) {
        NSError *err = errorBuild(0, kCostomErrorDomain, kLocString(@"保存失败"));
        if (saveImgBlock) {
            saveImgBlock(err);
        }
    }else{
        if (saveImgBlock) {
            saveImgBlock(nil);
        }
    }
}


@end
