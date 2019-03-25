//
//  ExtendButton.h
//  xianghui
//
//  Created by xianghui on 2018/10/13.
//  Copyright © 2018 xianghui. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ExtendButton : UIButton


@property (nonatomic,assign) CGFloat clickExtendX;   ///< 按钮点击事件增加的点击区域的宽度，default 20
@property (nonatomic,assign) CGFloat clickExtendY;   ///< 按钮点击事件增加的点击区域的高度  default 20

@end

NS_ASSUME_NONNULL_END
