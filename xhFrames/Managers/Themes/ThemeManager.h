//
//  ThemeManager.h
//  xianghui
//
//  Created by xianghui on 2017/12/11.
//  Copyright © 2017年 xh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ThemeKeys.h"
#import <SakuraKit/TXSakuraKit.h>

@interface ThemeManager : NSObject

DECLARE_SINGLETON(ThemeManager, sharedManager)

- (void)registerDefaultTheme;


@end
