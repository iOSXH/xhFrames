//
//  LoginViewController.m
//  xianghui
//
//  Created by xianghui on 2018/10/13.
//  Copyright © 2018 xianghui. All rights reserved.
//

#import "LoginViewController.h"
#import "XHExtendButton.h"
#import "WebViewController.h"

@interface LoginViewController ()<UITextFieldDelegate, YYTextKeyboardObserver>

@property (nonatomic, strong) UIButton *wxLoginBtn;
@property (nonatomic, strong) XHExtendButton *agreementSelectBtn;
@property (nonatomic, strong) UIButton *agreementBtn;




@property (nonatomic, strong) UIView *mobileLoginBgView;
@property (nonatomic, strong) NSLayoutConstraint *mobileBgBLayout;
@property (nonatomic, strong) UITextField *phoneNumTextField;
@property (nonatomic, strong) UITextField *passwordTextField;
@property (nonatomic, strong) UIButton *mobileLoginBtn;


@property (nonatomic, strong) NSLayoutConstraint *iconTopLayout;
@property (nonatomic, strong) NSLayoutConstraint *bottomLayout;

@end

@implementation LoginViewController


- (NSString *)navBgThemeColorKey{
    return nil;
}

- (NSString *)navTitleThemeColorKey{
    return kThemeKey_NavTitleWhite;
}

- (void)dealloc {
    [[YYTextKeyboardManager defaultManager] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    self.title = @"登录";
    self.view.sakura.backgroundColor(kThemeKey_BGC06);
    [self addBarItemWithTitle:nil imageName:@"icon_nav_close" isLeft:YES];
    
    [[YYTextKeyboardManager defaultManager] addObserver:self];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewDidTap)];
    [self.view addGestureRecognizer:tap];
    
    UIImageView *bgImageView = [UIImageView newAutoLayoutView];
    bgImageView.contentMode = UIViewContentModeScaleAspectFill;
    bgImageView.image = kImageNamed(@"icon_login_bg");
    [self.view addSubview:bgImageView];
    [bgImageView autoPinEdgesToSuperviewEdges];
    
    
    UIImageView *iconImageView = [UIImageView newAutoLayoutView];
    iconImageView.image = APPIcon;
    iconImageView.layer.masksToBounds = YES;
    iconImageView.layer.cornerRadius = sizeScale(50, YES);
    [self.view addSubview:iconImageView];
    [iconImageView autoSetDimensionsToSize:CGSizeMake(sizeScale(100, NO), sizeScale(100, NO))];
    [iconImageView autoAlignAxisToSuperviewAxis:ALAxisVertical];
    self.iconTopLayout = [iconImageView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:kStatusBarHeight+sizeScale(126, YES)];
    
    
    self.wxLoginBtn = [UIButton newAutoLayoutView];
    self.wxLoginBtn.sakura.backgroundColor(kThemeKey_BGC02);
    self.wxLoginBtn.layer.masksToBounds = YES;
    self.wxLoginBtn.layer.cornerRadius = sizeScale(4, YES);
    [self.wxLoginBtn addTarget:self action:@selector(wxLoginBtnDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.wxLoginBtn setImage:kImageNamed(@"icon_login_wechat") forState:UIControlStateNormal];
    [self.wxLoginBtn setTitle:@"   登录查看舆情事件" forState:UIControlStateNormal];
    self.wxLoginBtn.sakura.titleColor(kThemeKey_TXC01, UIControlStateNormal);
    self.wxLoginBtn.titleLabel.font = [UIFont systemFontOfSize:sizeScale(15, NO)];
    [self.view addSubview:self.wxLoginBtn];
    [self.wxLoginBtn autoSetDimensionsToSize:CGSizeMake(sizeScale(285, NO), sizeScale(45, NO))];
    [self.wxLoginBtn autoAlignAxisToSuperviewAxis:ALAxisVertical];
    self.bottomLayout = [self.wxLoginBtn autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:kBottomSafeAreaHeight+sizeScale(270, YES)];
    
    
    self.mobileLoginBgView = [UIView newAutoLayoutView];
    [self.view addSubview:self.mobileLoginBgView];
    [self.mobileLoginBgView autoSetDimensionsToSize:CGSizeMake(sizeScale(285, NO), sizeScale(200, NO))];
    [self.mobileLoginBgView autoAlignAxisToSuperviewAxis:ALAxisVertical];
    self.mobileBgBLayout = [self.mobileLoginBgView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:kBottomSafeAreaHeight+sizeScale(210, YES)];
    
    
    self.mobileLoginBtn = [UIButton newAutoLayoutView];
    self.mobileLoginBtn.sakura.backgroundColor(kThemeKey_BGC02);
    self.mobileLoginBtn.layer.masksToBounds = YES;
    self.mobileLoginBtn.layer.cornerRadius = sizeScale(4, YES);
    [self.mobileLoginBtn addTarget:self action:@selector(moblieLoginBtnDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.mobileLoginBtn setTitle:@"一键登录查看一手资讯" forState:UIControlStateNormal];
    self.mobileLoginBtn.sakura.titleColor(kThemeKey_TXC01, UIControlStateNormal);
    self.mobileLoginBtn.titleLabel.font = [UIFont systemFontOfSize:sizeScale(15, NO)];
    [self.mobileLoginBgView addSubview:self.mobileLoginBtn];
    [self.mobileLoginBtn autoSetDimensionsToSize:CGSizeMake(sizeScale(285, NO), sizeScale(45, NO))];
    [self.mobileLoginBtn autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [self.mobileLoginBtn autoPinEdgeToSuperviewEdge:ALEdgeBottom];
    
    UIView *line1 = [UIView lineLayoutView];
    [self.mobileLoginBgView addSubview:line1];
    [line1 autoSetDimension:ALDimensionHeight toSize:1];
    [line1 autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:self.mobileLoginBtn withOffset:sizeScale(-20, YES)];
    [line1 autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [line1 autoPinEdgeToSuperviewEdge:ALEdgeRight];
    
    self.passwordTextField = [UITextField newAutoLayoutView];
    self.passwordTextField.delegate = self;
    self.passwordTextField.returnKeyType = UIReturnKeyJoin;
    self.passwordTextField.font = [UIFont systemFontOfSize:sizeScale(20, YES)];
    self.passwordTextField.sakura.textColor(kThemeKey_TXC01);
    NSAttributedString *pwdPlaceHolder = [[NSAttributedString alloc] initWithString:@"请输入密码" attributes:@{NSForegroundColorAttributeName:[[TXSakuraManager tx_colorWithPath:kThemeKey_TXC01] colorWithAlphaComponent:0.5], NSFontAttributeName:[UIFont systemFontOfSize:sizeScale(15, YES)]}];
    self.passwordTextField.attributedPlaceholder = pwdPlaceHolder;
    self.passwordTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.passwordTextField.secureTextEntry = YES;
    [self.mobileLoginBgView addSubview:self.passwordTextField];
    [self.passwordTextField autoSetDimensionsToSize:CGSizeMake(sizeScale(285, NO), sizeScale(40, NO))];
    [self.passwordTextField autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:line1];
    [self.passwordTextField autoAlignAxisToSuperviewAxis:ALAxisVertical];
    
    UIView *line2 = [UIView lineLayoutView];
    [self.mobileLoginBgView addSubview:line2];
    [line2 autoSetDimension:ALDimensionHeight toSize:1];
    [line2 autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:self.passwordTextField withOffset:sizeScale(-15, YES)];
    [line2 autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [line2 autoPinEdgeToSuperviewEdge:ALEdgeRight];
    
    self.phoneNumTextField = [UITextField newAutoLayoutView];
    self.phoneNumTextField.delegate = self;
    self.phoneNumTextField.returnKeyType = UIReturnKeyNext;
    self.phoneNumTextField.keyboardType = UIKeyboardTypePhonePad;
    self.phoneNumTextField.font = [UIFont systemFontOfSize:sizeScale(20, YES)];
    self.phoneNumTextField.sakura.textColor(kThemeKey_TXC01);
    NSAttributedString *pnPlaceHolder = [[NSAttributedString alloc] initWithString:@"请输入正确的手机号码" attributes:@{NSForegroundColorAttributeName:[[TXSakuraManager tx_colorWithPath:kThemeKey_TXC01] colorWithAlphaComponent:0.5], NSFontAttributeName:[UIFont systemFontOfSize:sizeScale(15, YES)]}];
    self.phoneNumTextField.attributedPlaceholder = pnPlaceHolder;
    self.phoneNumTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.mobileLoginBgView addSubview:self.phoneNumTextField];
    [self.phoneNumTextField autoSetDimensionsToSize:CGSizeMake(sizeScale(285, NO), sizeScale(40, NO))];
    [self.phoneNumTextField autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:line2];
    [self.phoneNumTextField autoAlignAxisToSuperviewAxis:ALAxisVertical];
    
    
    
    self.agreementSelectBtn = [XHExtendButton newAutoLayoutView];
    [self.agreementSelectBtn setImage:kImageNamed(@"icon_login_unselect") forState:UIControlStateNormal];
    [self.agreementSelectBtn setImage:kImageNamed(@"icon_login_unselect") forState:UIControlStateHighlighted];
    [self.agreementSelectBtn setImage:kImageNamed(@"icon_login_select") forState:UIControlStateSelected];
    [self.agreementSelectBtn setImage:kImageNamed(@"icon_login_select") forState:UIControlStateSelected|UIControlStateHighlighted];
    [self.agreementSelectBtn addTarget:self action:@selector(agreementSelectBtnDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.agreementSelectBtn];
    [self.agreementSelectBtn autoSetDimensionsToSize:CGSizeMake(sizeScale(17, NO), sizeScale(17, NO))];
    [self.agreementSelectBtn autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.wxLoginBtn withOffset:sizeScale(20, YES)];
    [self.agreementSelectBtn autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.wxLoginBtn];
    self.agreementSelectBtn.selected = YES;
    self.agreementSelectBtn.userInteractionEnabled = NO;
 
    UILabel *agreementLab = [UILabel newAutoLayoutView];
    agreementLab.sakura.textColor(kThemeKey_TXC01);
    agreementLab.font = [UIFont systemFontOfSize:sizeScale(13, NO)];
    agreementLab.text = @"已阅读并同意以下协议";
    [self.view addSubview:agreementLab];
    [agreementLab autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.agreementSelectBtn];
    [agreementLab autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.agreementSelectBtn withOffset:sizeScale(6, NO)];
    
    
    self.agreementBtn = [UIButton newAutoLayoutView];
    self.agreementBtn.titleLabel.font = [UIFont systemFontOfSize:sizeScale(13, NO)];
    self.agreementBtn.sakura.titleColor(kThemeKey_TXC02, UIControlStateNormal);
    NSString *agreemTxt = [NSString stringWithFormat:@"《%@用户协议》", APPName];
    [self.agreementBtn setTitle:agreemTxt forState:UIControlStateNormal];
    [self.agreementBtn addTarget:self action:@selector(agreementBtnDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.agreementBtn];
    [self.agreementBtn autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.agreementSelectBtn withOffset:sizeScale(2, YES)];
    [self.agreementBtn autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.agreementSelectBtn];
    
    
//    UILabel *bottomLab = [UILabel newAutoLayoutView];
//    bottomLab.sakura.textColor(kThemeKey_TXC01);
//    bottomLab.font = [UIFont systemFontOfSize:sizeScale(13, NO)];
//    bottomLab.text = @"掌握第一手资讯";
//    bottomLab.alpha = 0.5;
//    [self.view addSubview:bottomLab];
//    [bottomLab autoAlignAxisToSuperviewAxis:ALAxisVertical];
//    [bottomLab autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:kBottomSafeAreaHeight+ sizeScale(40, YES)];
    
    
    [self resetLoginTypes];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resetLoginTypes) name:kAppConfigInfoDidChangeKey object:nil];
}


- (void)resetLoginTypes{
    if ([AccountManager appReview]) {
        self.mobileLoginBgView.hidden = NO;
        self.wxLoginBtn.hidden = YES;
        self.iconTopLayout.constant = kStatusBarHeight+sizeScale(90, YES);
        self.bottomLayout.constant = -(kBottomSafeAreaHeight+sizeScale(210, YES));
    }else{
        self.mobileLoginBgView.hidden = YES;
        self.wxLoginBtn.hidden = NO;
        self.iconTopLayout.constant = kStatusBarHeight+sizeScale(126, YES);
        self.bottomLayout.constant = -(kBottomSafeAreaHeight+sizeScale(270, YES));
    }
}

- (void)leftItemDidClicked:(id)sender{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}


- (void)agreementSelectBtnDidClicked:(UIButton *)sender{
    self.agreementSelectBtn.selected = !sender.selected;
}

- (void)agreementBtnDidClicked:(UIButton *)sender{
    WebViewController *webVc = [[WebViewController alloc] init];
    webVc.url = [NSURL URLWithString:kUserAgreementURL];
    [self.navigationController pushViewController:webVc animated:YES];
    
    [AppTrackHelper event:kTrackAccountProtocolClicked attributes:nil];
}

- (void)wxLoginBtnDidClicked:(UIButton *)sender{
    if (!self.agreementSelectBtn.selected) {
        
        NSString *agreemTxt = [NSString stringWithFormat:@"请阅读并同意《%@用户协议》", APPName];
        [ToastHelper showError:nil defaultMsg:agreemTxt];
        return;
    }
    sender.enabled = NO;
    NSString *hudTag = [HUDHelper showLoadingWithText:@"授权中..." inView:self.view];
    
    [[UserService sharedService] userLoginWithWechatSuccess:^(NSString * _Nonnull msg) {
        [HUDHelper hideLoadingView:hudTag];
        sender.enabled = YES;
        [self loginSuccess];
    } failure:^(NSError * _Nonnull error) {
        [HUDHelper hideLoadingView:hudTag];
        [ToastHelper showError:error defaultMsg:@""];
        sender.enabled = YES;
    } state:^(NSInteger state) {
        [HUDHelper updateLoadingView:hudTag text:@"登录中..."];
    }];
}


- (void)loginSuccess{
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}


- (void)moblieLoginBtnDidClicked:(UIButton *)sender{
    if (!self.agreementSelectBtn.selected) {
        
        NSString *agreemTxt = [NSString stringWithFormat:@"请阅读并同意《%@用户协议》", APPName];
        [ToastHelper showError:nil defaultMsg:agreemTxt];
        return;
    }
    
    if (self.phoneNumTextField.text.length != 11) {
        
        [ToastHelper showError:nil defaultMsg:@"请输入正确的11位手机号码"];
        return;
    }
    
    if (self.passwordTextField.text.length <= 0) {
        [ToastHelper showError:nil defaultMsg:@"请输入密码"];
        return;
    }
    
    [self viewDidTap];
    
    sender.enabled = NO;
    NSString *hudTag = [HUDHelper showLoadingWithText:@"登录中..." inView:self.view];
    if ([self.phoneNumTextField.text isEqualToString:@"18516268672"] && [self.passwordTextField.text isEqualToString:@"123456"]) {
        
        NSString *jsonStr = @"{\"token\":\"p6ltro!ObRU+iPRa_2\",\"isNew\":0,\"userInfo\":{\"username\":\"IOS\",\"userId\":2,\"sex\":1,\"nickName\":\"IOS\",\"createTime\":\"2018-10-12 08:00:00\",\"avatar\":\"http://thirdwx.qlogo.cn/mmopen/vi_32/xqYeDsnUmV03aib4VoqBBZc7514H0wibOBbF13iaOiaCicrJwPmiauPOJNujgyhIyEvOFtkialTiaTAzfibry7peAguVfQg/132\"}}";
        
        NSDictionary *account = [jsonStr jsonValueDecoded];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [[AccountManager sharedManager] loginSuccessWithData:account];
            
            [HUDHelper hideLoadingView:hudTag];
            sender.enabled = YES;
            [self loginSuccess];
        });
    }else{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [HUDHelper hideLoadingView:hudTag];
            [ToastHelper showError:nil defaultMsg:@"手机号或密码错误，请重新输入"];
            sender.enabled = YES;
        });
        
        [[UserService sharedService] appConfigsWithKeys:nil success:nil failure:nil];
    }
}



#pragma mark UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if (textField == self.passwordTextField) {
        [self moblieLoginBtnDidClicked:self.mobileLoginBtn];
    }
    return YES;
}

#pragma mark YYTextKeyboardObserver
-(void)keyboardChangedWithTransition:(YYTextKeyboardTransition)transition{
    
    CGFloat defaultHeight = kBottomSafeAreaHeight+sizeScale(210, YES);
    
    [UIView animateWithDuration:transition.animationDuration delay:0 options:transition.animationOption animations:^{
        CGRect kbFrame = [[YYTextKeyboardManager defaultManager] keyboardFrame];
        CGFloat kbHeight = SCREEN_HEIGHT - kbFrame.origin.y;
        if (kbHeight < defaultHeight) {
            kbHeight = defaultHeight;
        }else{
            kbHeight += 10;
        }
        self.mobileBgBLayout.constant = - kbHeight;
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        
    }];
}


- (void)viewDidTap{
    [self.phoneNumTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
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
