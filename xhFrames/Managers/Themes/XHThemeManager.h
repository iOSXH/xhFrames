//
//  XHThemeManager.h
//  xianghui
//
//  Created by xianghui on 2017/12/11.
//  Copyright © 2017年 xh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XHThemeKeys.h"
#import <SakuraKit/TXSakuraKit.h>

@interface XHThemeManager : NSObject

DECLARE_SINGLETON(XHThemeManager, sharedManager)

- (void)registerDefaultTheme;


@end
