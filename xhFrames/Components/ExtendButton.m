//
//  ExtendButton.m
//  xianghui
//
//  Created by xianghui on 2018/10/13.
//  Copyright © 2018 xianghui. All rights reserved.
//

#import "ExtendButton.h"

@implementation ExtendButton

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.clickExtendX = 20;
        self.clickExtendY = 20;
    }
    return self;
}
//扩大关闭按钮的点击区域
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    CGRect bounds = self.bounds;
    bounds = CGRectInset(bounds, -self.clickExtendX, -self.clickExtendY);
    return CGRectContainsPoint(bounds, point);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
