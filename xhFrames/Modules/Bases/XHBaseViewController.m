//
//  XHBaseViewController.m
//  xianghui
//
//  Created by xianghui on 2018/8/13.
//  Copyright © 2018年 xh. All rights reserved.
//

#import "XHBaseViewController.h"

#import <KMNavigationBarTransition/UIViewController+KMNavigationBarTransition_internal.h>
#import <UIButton+WebCache.h>
#import <UMAnalytics/MobClick.h>


@interface XHBaseViewController ()

@end

@implementation XHBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.sakura.backgroundColor(kThemeKey_BGC01);
    if (self.navigationController.viewControllers.count > 1) {
        [self addBarItemWithTitle:nil imageName:@"icon_nav_back" isLeft:YES];
    }
    [self resetNavUI];
    
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(themeDidChange) name:TXSakuraSkinChangeNotification object:nil];

}


- (void)themeDidChange{
    [self resetNavUI];
    [self.km_transitionNavigationBar setBackgroundImage:[self.navigationController.navigationBar backgroundImageForBarMetrics:UIBarMetricsDefault] forBarMetrics:UIBarMetricsDefault];
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleDefault;
}

- (void)resetNavUI{
    if (self.navigationController) {
        UIImage *image = [[UIImage alloc] init];
        if (self.navBgThemeColorKey) {
            UIColor *color = [TXSakuraManager tx_colorWithPath:self.navBgThemeColorKey];
            image = [UIImage imageWithColor:color];
        }
        
        [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
        
        self.navigationController.navigationBar.sakura.titleTextAttributes(self.navTitleThemeColorKey);
    }
}


- (NSString *)navTitleThemeColorKey{
    return kThemeKey_NavTitle;
}

- (NSString *)navBgThemeColorKey{
    return kThemeKey_BGC01;
}

- (NSString *)navItemColorKey{
    return kThemeKey_NavItem;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:self.navBarHidden animated:YES];
    
    if (!self.disableUMPageLog) {
        [AppTrackHelper beginLogPageView:NSStringFromClass([self class])];
    }
    
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if (!self.disableUMPageLog) {
        [AppTrackHelper endLogPageView:NSStringFromClass([self class])];
    }
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    DDLogDebug(@"%@ dealloc", NSStringFromClass([self class]));
}


- (void)addBarItemWithTitle:(NSString *)title imageName:(NSString *)imageName isLeft:(BOOL)left{
    UIBarButtonItem *barItem = nil;
    
    SEL action = left?(@selector(leftItemDidClicked:)):(@selector(rightItemDidClicked:));
    
    if (!emptyString(title)) {
        barItem = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:self action:action];
        barItem.sakura
        .titleTextAttributes(self.navItemColorKey, UIControlStateNormal);
//        .titleTextAttributes(self.navItemColorKey, UIControlStateHighlighted)
//        .titleTextAttributes(self.navItemColorKey, UIControlStateSelected)
//        .titleTextAttributes(self.navItemColorKey, UIControlStateSelected|UIControlStateHighlighted)
//        .titleTextAttributes(self.navItemColorKey, UIControlStateDisabled);
        
    }else if (!emptyString(imageName)){
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
        if ([imageName hasPrefix:@"http"]
            || [imageName hasPrefix:@"https"]) {
            [btn sd_setImageWithURL:[NSURL URLWithString:imageName] forState:UIControlStateNormal];
        }else{
            [btn setImage:kImageNamed(imageName) forState:UIControlStateNormal];
        }
        btn.imageEdgeInsets = left?UIEdgeInsetsMake(0,-20,0,0):UIEdgeInsetsMake(0,0,0,-20);
        [btn addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
        barItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    }else{
        return;
    }
    
    if (left) {
        self.navigationItem.leftBarButtonItem = barItem;
    }else{
        self.navigationItem.rightBarButtonItem = barItem;
    }
    
}

- (void)leftItemDidClicked:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightItemDidClicked:(id)sender{
    
}

- (void)refresh{
    
}

- (BOOL)isEqualToVc:(XHBaseViewController *)vc{
    BOOL eq = NO;
    if ([self isKindOfClass:[vc class]]) {
        eq = YES;
    }
    return eq;
}




#pragma mark UIViewControllerRotation
- (BOOL)shouldAutorotate{
    return NO;
}
- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    return UIInterfaceOrientationPortrait;
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
