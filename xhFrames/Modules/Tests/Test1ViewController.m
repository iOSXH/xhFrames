//
//  Test1ViewController.m
//  xhFrames
//
//  Created by hui xiang on 2018/11/13.
//  Copyright © 2018 xianghui. All rights reserved.
//

#import "Test1ViewController.h"

@interface Test1ViewController ()

@end

@implementation Test1ViewController


- (NSString *)navBgThemeColorKey{
    NSString *key = kThemeKey_BGC01;
    switch (self.type) {
        case 1:
        {
            key = kThemeKey_BGC02;
        }
            break;
        case 2:
        {
            key = kThemeKey_BGC10;
        }
            break;
            
        default:
            break;
    }
    
    return key;
}


- (NSString *)navTitleThemeColorKey{
    NSString *key = kThemeKey_NavTitle;
    switch (self.type) {
        case 2:
        {
            key = kThemeKey_NavTitleWhite;
        }
            break;
            
        default:
            break;
    }
    
    return key;
}

    

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = NSLocalizedString(@"测试1", nil);
    
    if (self.type <= 0) {
        
        [self addBarItemWithTitle:@"左按钮" imageName:nil isLeft:YES];
        [self addBarItemWithTitle:@"右按钮" imageName:nil isLeft:NO];
    }else if (self.type > 0) {
        self.title = [NSLocalizedString(@"测试1", nil) stringByAppendingFormat:@"+%@", @(self.type)];
        [self addBarItemWithTitle:@"右按钮" imageName:nil isLeft:NO];
    }
    
}

- (void)leftItemDidClicked:(id)sender{
    if (self.type > 0) {
        [super leftItemDidClicked:sender];
        return;
    }
    
    Test1ViewController *vc = [[Test1ViewController alloc] init];
    vc.type = 1;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)rightItemDidClicked:(id)sender{
    
    Test1ViewController *vc = [[Test1ViewController alloc] init];
    vc.type = 2;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
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
