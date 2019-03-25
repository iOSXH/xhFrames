//
//  ThemeManager.m
//  yuwancumain
//
//  Created by xianghui on 2017/12/11.
//  Copyright © 2017年 xh. All rights reserved.
//

#import "ThemeManager.h"

@implementation ThemeManager

IMPLEMENT_SINGLETON(ThemeManager, sharedManager)

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)registerDefaultTheme{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(themeDidChanged) name:TXSakuraSkinChangeNotification object:nil];
    [TXSakuraManager registerLocalSakuraWithNames:@[kThemeName_Default]];
    
    [TXSakuraManager shiftSakuraWithName:kThemeName_Default type:TXSakuraTypeMainBundle];
}


- (void)themeDidChanged{
}


- (void)changeThemeBtnDidClicked:(UIButton *)sender{
    sender.selected = !sender.selected;
//    [TXSakuraManager shiftSakuraWithName:sender.selected?kThemeName_Pink:kThemeName_Default type:TXSakuraTypeMainBundle];
}

@end
