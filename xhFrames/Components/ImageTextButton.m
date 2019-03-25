//
//  ImageTextButton.m
//  xianghui
//
//  Created by xianghui on 2018/8/14.
//  Copyright © 2018年 xh. All rights reserved.
//

#import "ImageTextButton.h"

@implementation ImageTextButton
- (id)init{
    self = [super init];
    if (self) {
        [self bgImageView];
        [self imageView];
        [self titleLabel];
    }
    return self;
}


#pragma mark -setter

- (void)setTitle:(NSString *)title{
    self.titleLabel.text = title;
}

- (void)setImage:(UIImage *)image{
    self.imageView.image = image;
}

- (void)setBgImage:(UIImage *)image{
    self.bgImageView.image = image;
}

#pragma mark - lazyLoad

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [UILabel newAutoLayoutView];
        [self addSubview:_titleLabel];
    }
    return _titleLabel;
}

- (UILabel *)subTitleLabel{
    if (!_subTitleLabel) {
        _subTitleLabel = [UILabel newAutoLayoutView];
        [self addSubview:_subTitleLabel];
    }
    return _subTitleLabel;
}

- (UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [UIImageView newAutoLayoutView];
        [self addSubview:_imageView];
    }
    return _imageView;
}

- (UIImageView *)bgImageView{
    if(!_bgImageView){
        _bgImageView = [UIImageView newAutoLayoutView];
        [self addSubview:_bgImageView];
    }
    return _bgImageView;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
