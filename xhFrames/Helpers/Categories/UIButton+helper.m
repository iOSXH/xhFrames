//
//  UIButton+helper.m
//  xianghui
//
//  Created by JackLee on 2018/9/3.
//  Copyright © 2018年  xh. All rights reserved.
//

#import "UIButton+helper.h"

@implementation UIButton (helper)
- (void)setBigBtnBgColor:(UIColor *)bgColor{
    [self setBackgroundImage:[UIImage imageWithColor:bgColor] forState:UIControlStateNormal];
    [self setBackgroundImage:[UIImage imageWithColor:[bgColor colorWithAlphaComponent:0.7]] forState:UIControlStateHighlighted];
}



@end
