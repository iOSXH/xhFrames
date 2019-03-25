//
//  BaseTabBarController.m
//  xianghui
//
//  Created by xianghui on 2018/8/13.
//  Copyright © 2018年 xh. All rights reserved.
//

#import "BaseTabBarController.h"

@interface BaseTabBarController ()

@end

@implementation BaseTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //去除 TabBar 自带的顶部阴影
    [[UITabBar appearance] setBackgroundImage:[[UIImage alloc] init]];
    [[UITabBar appearance] setShadowImage:[[UIImage alloc] init]];
    
    
    self.myTabBar = [[BaseTabBar alloc] initWithFrame:self.tabBar.bounds];
    [self.myTabBar setMyDelegate:self];
    [self setValue:self.myTabBar forKey:@"tabBar"];
}

- (void)dealloc{
    DDLogDebug(@"%@ dealloc", NSStringFromClass([self class]));
}

- (UIViewController *)childViewControllerForStatusBarStyle{
    return self.selectedViewController;
}

#pragma getter/setter
- (UINavigationController *)currentNavigationController{
    UIViewController *vc = self.selectedViewController;
    if ([vc isKindOfClass:[UINavigationController class]]) {
        return (UINavigationController *)vc;
    }else{
        return nil;
    }
}


#pragma mark YWTabBarDelegate
- (void)tabBar:(BaseTabBar *)tabBar didSelectIndex:(NSInteger)index{
    if (self.selectedIndex != index) {
        [self setSelectedIndex:index];
    }
}

- (void)tabBar:(BaseTabBar *)tabBar didDoubleSelectIndex:(NSInteger)index{
}

- (BOOL)tabBar:(BaseTabBar *)tabBar shouldSelectIndex:(NSInteger)index{
    return YES;
}



#pragma mark UIViewControllerRotation
- (BOOL)shouldAutorotate{
    return self.selectedViewController.shouldAutorotate;
}
- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return self.selectedViewController.supportedInterfaceOrientations;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    return self.selectedViewController.preferredInterfaceOrientationForPresentation;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
