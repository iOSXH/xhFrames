//
//  LanguageSettingsViewController.m
//  xhFrames
//
//  Created by hui xiang on 2018/11/13.
//  Copyright © 2018 xianghui. All rights reserved.
//

#import "LanguageSettingsViewController.h"
#import "SettingTableViewCell.h"

#import "XHLanguagesManager.h"

#import "MainTabBarController.h"
#import "AppDelegate.h"

@interface LanguageSettingsViewController ()<XHLanguagesDelegate>

@end

@implementation LanguageSettingsViewController


- (UITableViewStyle)tableViewStyle{
    return UITableViewStyleGrouped;
}

- (XHHeaderRefreshType)headerType{
    return XHHeaderRefreshTypeNone;
}

- (XHFooterRefreshType)footerType{
    return XHFooterRefreshTypeNone;
}

- (Class)cellClass{
    return [SettingTableViewCell class];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = NSLocalizedString(@"多语言", nil);
    self.view.sakura.backgroundColor(kThemeKey_BGC06);
    [self setupRefresh];
    
    [[XHLanguagesManager sharedManager] setDelegate:self];
    
    [self startRefreshing:NO];
}


#pragma mark XHLanguagesDelegate
- (void)languagesDidChanged:(XHLanguagesType)type{
    
    MainTabBarController *tab = [[MainTabBarController alloc] init];
    
//    UINavigationController *mineNav = [tab.viewControllers lastObject];
//    
//    LanguageSettingsViewController *languageVc = [[LanguageSettingsViewController alloc] init];
//    languageVc.hidesBottomBarWhenPushed = YES;
//    NSMutableArray *vcs = [NSMutableArray arrayWithArray:mineNav.viewControllers];
//    [vcs addObject:languageVc];
//    [mineNav setViewControllers:vcs animated:YES];
    
    [UIAppDelegate window].rootViewController = tab;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary *data = [self.datas objectAtIndex:indexPath.row];
    NSInteger type = [[data objectForKey:@"type"] integerValue];
    
    [[XHLanguagesManager sharedManager] resetLanguage:type];
}


#pragma mark refresh Protocol
- (void)refreshWithNextId:(NSString *)nextId limit:(NSInteger)limit success:(successBlock)success failure:(failureBlock)failure{
    
    NSArray *datas = @[
                       @{@"leftTitle":@"跟随系统",
                         @"type":@(XHLanguagesType_System),
                         @"hideRight":@(XHLanguagesType_System == [XHLanguagesManager sharedManager].currentLanguagesType)
                         },
                       @{@"leftTitle":@"简体中文",
                         @"type":@(XHLanguagesType_SimpleChinese),
                         @"hideRight":@(XHLanguagesType_SimpleChinese == [XHLanguagesManager sharedManager].currentLanguagesType)
                         },
                       @{@"leftTitle":@"English",
                         @"type":@(XHLanguagesType_English),
                         @"hideRight":@(XHLanguagesType_English == [XHLanguagesManager sharedManager].currentLanguagesType)
                         }];
    
    
    if (success) {
        success(nil, datas);
    }
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
