//
//  MainTabBarController.m
//  sentiment
//
//  Created by xianghui on 2018/10/25.
//  Copyright © 2018 xianghui. All rights reserved.
//

#import "MainTabBarController.h"
#import "XHBaseNavigationController.h"
#import "MineViewController.h"
#import "LoginViewController.h"

@interface MainTabBarController ()

@end

@implementation MainTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[AccountManager sharedManager] initLoginState];
    
    
    MineViewController *mineVc = [[MineViewController alloc] init];
    XHBaseNavigationController *mineNav = [[XHBaseNavigationController alloc] initWithRootViewController:mineVc];
    mineVc.tabBarItem.title = @"";
    
    [self setViewControllers:@[mineNav]];
    
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveNotification:) name:kAccountLoginSuccessKey object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveNotification:) name:kAccountLogoutKey object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveNotification:) name:kAPPHomeTabDidSelectNotificationKey object:nil];
    
    
//    [self.myTabBar setSelectedIndex:1];
    
    
    [[AccountManager sharedManager] setAppConfigBlock:^{
        if (![AccountManager appReview]) {
            if ([AccountManager sharedManager].loginState != LoginState_In) {
                [self gotoLoginAnimated:YES];
            }else{
//                [self.myTabBar setSelectedIndex:0];
            }
        }else{
            if ([AccountManager sharedManager].loginState == LoginState_In) {
//                [self.myTabBar setSelectedIndex:0];
            }
        }
    }];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
}


#pragma mark Notification
- (void)didReceiveNotification:(NSNotification *)noti{
    if ([noti.name isEqualToString:kAccountLogoutKey]) {
        [self resetTabAtIndex:1];
        [self gotoLoginAnimated:YES];
    }else if ([noti.name isEqualToString:kAccountLoginSuccessKey]) {
        
        [self resetTabAtIndex:0];
        
        
        for (UIViewController *vc in self.viewControllers) {
            if ([vc isKindOfClass:[XHBaseViewController class]]) {
                [(XHBaseViewController *)vc refresh];
            }else if ([vc isKindOfClass:[UINavigationController class]]) {
                UIViewController *topVc = [[(UINavigationController *)vc viewControllers] firstObject];
                if ([topVc isKindOfClass:[XHBaseViewController class]]) {
                    [(XHBaseViewController *)topVc refresh];
                }
            }
        }
        
    }else if ([noti.name isEqualToString:kAPPHomeTabDidSelectNotificationKey]){
        NSInteger index = [noti.object integerValue];
        
        [self resetTabAtIndex:index];
    }
}


- (void)resetTabAtIndex:(NSInteger)index{
    if (IOS_VERSION>=8 && IOS_VERSION<9) {  //注意：在IOS 8 系列手机上加上这段代码可以避免出现通过通知进行切换时出现黑色条现象
        [self.tabBar removeFromSuperview];
        [self setValue:nil forKey:@"tabBar"];
        [self setValue:self.myTabBar forKey:@"tabBar"];
    }
    
    NSTimeInterval dalay = 0;
    
    UINavigationController *nav = self.currentNavigationController;
    if (nav.viewControllers.count > 1) {
        [nav popToRootViewControllerAnimated:YES];
        dalay = 0.5;
    }else{
        [self.myTabBar setSelectedIndex:index];
    }
    
    if (self.selectedIndex != index) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(dalay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.myTabBar setSelectedIndex:index];
        });
    }
}

- (void)gotoLoginAnimated:(BOOL)flag{
    
    
    
    LoginViewController *loginVc = [[LoginViewController alloc] init];
    
    XHBaseNavigationController *nav = [[XHBaseNavigationController alloc] initWithRootViewController:loginVc];
    
    [self presentViewController:nav animated:flag completion:nil];
}


- (BOOL)tabBar:(XHBaseTabBar *)tabBar shouldSelectIndex:(NSInteger)index{
    
    
    if (index != 1 && [AccountManager sharedManager].loginState != LoginState_In) {
        [self gotoLoginAnimated:YES];
        return NO;
    }
    return YES;
}

- (void)tabBar:(XHBaseTabBar *)tabBar didSelectIndex:(NSInteger)index{
    [super tabBar:tabBar didSelectIndex:index];
    
    
    [AppTrackHelper event:kTrackHomeTabClicked attributes:@{@"index":@(index)}];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
