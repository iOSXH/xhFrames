//
//  ImageTextButton.h
//  xianghui
//
//  Created by xianghui on 2018/8/14.
//  Copyright © 2018年 xh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageTextButton : UIControl
@property (nonatomic,strong) UILabel *titleLabel;      ///< 标题
@property (nonatomic,strong) UILabel *subTitleLabel;   ///< 子标题
@property (nonatomic,strong) UIImageView *imageView;   ///< 前视图
@property (nonatomic,strong) UIImageView *bgImageView; ///< 背景视图

/**
 设置标题
 设置titleLabel的text
 
 @param title 标题
 */
- (void)setTitle:(NSString *)title;
/**
 设置imageView的image
 
 @param image UIImage对象
 */
- (void)setImage:(UIImage *)image;


/**
 设置bgImageView的image
 
 @param image UIImage对象
 */
- (void)setBgImage:(UIImage *)image;
@end
