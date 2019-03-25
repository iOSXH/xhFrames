//
//  BaseTabBtn.h
//  xianghui
//
//  Created by xianghui on 2018/8/13.
//  Copyright © 2018年 xh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseTabBtn : UIButton

- (instancetype)initWithFrame:(CGRect)frame config:(NSDictionary *)config;

- (void)resetBadge:(BOOL)flag;

@end
