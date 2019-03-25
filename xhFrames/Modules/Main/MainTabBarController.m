//
//  MainTabBarController.m
//  sentiment
//
//  Created by xianghui on 2018/10/25.
//  Copyright © 2018 xianghui. All rights reserved.
//

#import "MainTabBarController.h"
#import "BaseNavigationController.h"
#import "MineViewController.h"
#import "LoginViewController.h"

#import "Test1ViewController.h"
#import "Test2ViewController.h"

@interface MainTabBarController ()

@end

@implementation MainTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[AccountManager sharedManager] initLoginState];
    
    MineViewController *mineVc = [[MineViewController alloc] init];
    BaseNavigationController *mineNav = [[BaseNavigationController alloc] initWithRootViewController:mineVc];
    mineVc.tabBarItem.title = @"";
    
    
    Test1ViewController *test1Vc = [[Test1ViewController alloc] init];
    BaseNavigationController *test1Nav = [[BaseNavigationController alloc] initWithRootViewController:test1Vc];
    test1Vc.tabBarItem.title = @"";
    
    Test2ViewController *test2Vc = [[Test2ViewController alloc] init];
    BaseNavigationController *test2Nav = [[BaseNavigationController alloc] initWithRootViewController:test2Vc];
    test2Vc.tabBarItem.title = @"";
    
    
    [self setViewControllers:@[test1Nav, test2Nav, mineNav]];
    
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveNotification:) name:kAccountLoginSuccessKey object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveNotification:) name:kAccountLogoutKey object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveNotification:) name:kAPPHomeTabDidSelectNotificationKey object:nil];
    
    
    
    
//    [[AccountManager sharedManager] setAppConfigBlock:^{
//        if ([AccountManager sharedManager].loginState != LoginState_In) {
//            [self gotoLoginAnimated:YES];
//        }else{
//
//        }
//    }];
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
            if ([vc isKindOfClass:[BaseViewController class]]) {
                [(BaseViewController *)vc refresh];
            }else if ([vc isKindOfClass:[UINavigationController class]]) {
                UIViewController *topVc = [[(UINavigationController *)vc viewControllers] firstObject];
                if ([topVc isKindOfClass:[BaseViewController class]]) {
                    [(BaseViewController *)topVc refresh];
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
    
    BaseNavigationController *nav = [[BaseNavigationController alloc] initWithRootViewController:loginVc];
    
    [self presentViewController:nav animated:flag completion:nil];
}


//- (BOOL)tabBar:(BaseTabBar *)tabBar shouldSelectIndex:(NSInteger)index{
//    
//    
//    if (index != 1 && [AccountManager sharedManager].loginState != LoginState_In) {
//        [self gotoLoginAnimated:YES];
//        return NO;
//    }
//    return YES;
//}

- (void)tabBar:(BaseTabBar *)tabBar didSelectIndex:(NSInteger)index{
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
