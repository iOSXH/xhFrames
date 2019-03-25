//
//  BaseNavigationController.m
//  xianghui
//
//  Created by xianghui on 2018/8/13.
//  Copyright © 2018年 xh. All rights reserved.
//

#import "BaseNavigationController.h"
#import "BaseViewController.h"

@interface BaseNavigationController ()<UINavigationControllerDelegate,UIGestureRecognizerDelegate>

@end

@implementation BaseNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[UINavigationBar appearance] setShadowImage:[[UIImage alloc] init]];
    
    
    self.delegate = self;
    self.interactivePopGestureRecognizer.delegate = self;
    self.interactivePopGestureRecognizer.enabled = NO;
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    
    if (self.viewControllers.count > 1) {
        self.interactivePopGestureRecognizer.enabled = YES;
    }else{
        self.interactivePopGestureRecognizer.enabled = NO;
    }
    
}


- (UIViewController *)childViewControllerForStatusBarStyle{
    return self.topViewController;
}



#pragma mark UIViewControllerRotation
- (BOOL)shouldAutorotate{
    return self.topViewController.shouldAutorotate;
}
- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return self.topViewController.supportedInterfaceOrientations;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    return self.topViewController.preferredInterfaceOrientationForPresentation;
}

#pragma mark UIGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    UIViewController *topVc = self.visibleViewController;
    
    if ([topVc isKindOfClass:[BaseViewController class]]) {
        if ([(BaseViewController *)topVc disableSwipBack]) {
            return NO;
        }
    }
    
    return YES;
    
    //    BOOL ok = YES;
    //    // 默认为支持右滑反回
    //
    //    if([self.topViewController isKindOfClass:[WWBaseViewController class]])
    //    {
    //        if([self.topViewController respondsToSelector:@selector(gestureRecognizerShouldBegin)])
    //        {
    //            WWBaseViewController *vc = (WWBaseViewController
    //                                        *)self.topViewController;
    //            ok = [vc gestureRecognizerShouldBegin];
    //        }
    //
    //    }
    //    return ok;
    
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
