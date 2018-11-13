//
//  XHPopupView.m
//  xianghui
//
//  Created by xianghui on 2018/8/16.
//  Copyright © 2018年 xh. All rights reserved.
//

#import "XHPopupView.h"
#import "CNPPopupController.h"

@interface XHPopupView ()<CNPPopupControllerDelegate>

@property (nonatomic, strong) CNPPopupController *popupController;

@end

@implementation XHPopupView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        
        
        
    }
    return self;
}

- (void)setDismissOnBackgroundTap:(BOOL)dismissOnBackgroundTap{
    _dismissOnBackgroundTap = dismissOnBackgroundTap;
    
    self.popupController.theme.shouldDismissOnBackgroundTouch = dismissOnBackgroundTap;
}

- (void)setPopupType:(XHPopupType)popupType{
    _popupType = popupType;
    
    if (popupType == XHPopupType_Alert) {
        self.popupController.theme.popupStyle = CNPPopupStyleCentered;
        self.popupController.theme.presentationStyle = CNPPopupPresentationStyleFadeIn;
    }else if (popupType == XHPopupType_ActionSheet){
        self.popupController.theme.popupStyle = CNPPopupStyleActionSheet;
        self.popupController.theme.presentationStyle = CNPPopupPresentationStyleSlideInFromBottom;
    }else if (popupType == XHPopupType_FullScreen){
        self.popupController.theme.popupStyle = CNPPopupStyleFullscreen;
        self.popupController.theme.presentationStyle = CNPPopupPresentationStyleSlideInFromBottom;
    }
}

- (CNPPopupController *)popupController{
    if (!_popupController) {
        
        _popupController = [[CNPPopupController alloc] initWithContents:@[self]];
        _popupController.theme = [CNPPopupTheme defaultTheme];
        _popupController.theme.backgroundColor = [UIColor clearColor];
        _popupController.theme.cornerRadius = 0;
        _popupController.theme.popupContentInsets = UIEdgeInsetsZero;
        _popupController.theme.contentVerticalPadding = 0;
        _popupController.theme.maxPopupWidth = SCREEN_WIDTH;
        _popupController.theme.maskType = CNPPopupMaskTypeCustom;
        _popupController.theme.movesAboveKeyboard = NO;
        _popupController.theme.customMaskColor = [[UIColor colorWithHexString:@"#000000"] colorWithAlphaComponent:0.36];
        
        _popupController.delegate = self;
    }
    return _popupController;
}


- (void)showViewAnimated:(BOOL)flag{
    [self.popupController presentPopupControllerAnimated:flag];
}

- (void)dismissViewAnimated:(BOOL)flag{
    [self.popupController dismissPopupControllerAnimated:flag];
}


#pragma mark CNPPopupControllerDelegate
- (void)popupControllerWillPresent:(CNPPopupController *)controller{
    if (self.liftBlock) {
        self.liftBlock(1);
    }
}

- (void)popupControllerDidPresent:(CNPPopupController *)controller{
    if (self.liftBlock) {
        self.liftBlock(2);
    }
}


- (void)popupControllerWillDismiss:(CNPPopupController *)controller{
    if (self.liftBlock) {
        self.liftBlock(3);
    }
}

- (void)popupControllerDidDismiss:(CNPPopupController *)controller{
    if (self.liftBlock) {
        self.liftBlock(4);
    }
    self.popupController = nil;
}


- (void)resetViewFrame:(CGRect)frame{
    [self.popupController resetViewFrame:frame];
}


@end



@implementation XHPopupAlertView

- (instancetype)initCloseViewWithContentView:(UIView *)contentView{
    self = [super init];
    if (self) {
        
        self.frame = CGRectMake(0, 0, contentView.width, contentView.height+ 60*kIPadScale);
        
        
        UIView *contentBgView = [[UIView alloc] initWithFrame:contentView.bounds];
        contentBgView.backgroundColor = [UIColor clearColor];
        contentBgView.layer.masksToBounds = YES;
        contentBgView.layer.cornerRadius = 16*kIPadScale;
        [self addSubview:contentBgView];
        
        [contentBgView addSubview:contentView];
        
        UIButton *btn = [UIButton newAutoLayoutView];
        [btn setImage:kImageNamed(@"icon_common_alertClose") forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(closeBtnDidClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        [btn autoSetDimensionsToSize:CGSizeMake(40*kIPadScale, 40*kIPadScale)];
        [btn autoAlignAxisToSuperviewAxis:ALAxisVertical];
        [btn autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:contentView withOffset:14*kIPadScale];
        
        self.dismissOnBackgroundTap = NO;
        self.popupType = XHPopupType_Alert;
    }
    return self;
}
- (void)closeBtnDidClicked:(UIButton *)sender{
    [self dismissViewAnimated:YES];
}

@end;




@implementation XHPopupActionView

- (instancetype)initBottomViewWithContentView:(UIView *)contentView title:(NSString *)title{
    self = [super init];
    if (self) {
        
        CGFloat topSpace = 0;
        if (!emptyString(title)) {
            topSpace = 48*kIPadScale;
            
            UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, topSpace)];
            topView.sakura.backgroundColor(kThemeKey_BGC01);
            [self addSubview:topView];
            [topView addRoundedCornerWithRadius:16*kIPadScale corners:UIRectCornerTopLeft|UIRectCornerTopRight];
            
            UILabel *titleLab = [UILabel newAutoLayoutView];
            titleLab.sakura.textColor(kThemeKey_TXC01);
            titleLab.font = [UIFont systemFontOfSize:16*kIPadScale];
            titleLab.text = title;
            [topView addSubview:titleLab];
            [titleLab autoCenterInSuperview];
            [titleLab autoSetDimension:ALDimensionWidth toSize:SCREEN_WIDTH/2 relation:NSLayoutRelationLessThanOrEqual];
            
            
            UIButton *btn = [UIButton newAutoLayoutView];
            [btn setImage:kImageNamed(@"icon_common_actionClose") forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(closeBtnDidClicked:) forControlEvents:UIControlEventTouchUpInside];
            [topView addSubview:btn];
            [btn autoSetDimensionsToSize:CGSizeMake(40*kIPadScale, 40*kIPadScale)];
            [btn autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
            [btn autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:8*kIPadScale];
            
            UIView *line = [UIView newAutoLayoutView];
            line.sakura.backgroundColor(kThemeKey_BGCLine);
            line.alpha = 0.5;
            [topView addSubview:line];
            [line autoSetDimension:ALDimensionHeight toSize:1];
            [line autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];
        }
        
        
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, contentView.height + topSpace);
        
        
        UIView *contentBgView = [[UIView alloc] initWithFrame:CGRectMake(0, topSpace, SCREEN_WIDTH, contentView.height)];
        contentBgView.sakura.backgroundColor(kThemeKey_BGC01);
        [self addSubview:contentBgView];
        
        [contentBgView addSubview:contentView];

        
        self.dismissOnBackgroundTap = YES;
        self.popupType = XHPopupType_ActionSheet;
    }
    return self;
}
- (void)closeBtnDidClicked:(UIButton *)sender{
    [self dismissViewAnimated:YES];
}

- (instancetype)initBottomViewWithContentView:(UIView *)contentView{
    CGRect frame = CGRectMake(0, 0, contentView.frame.size.width, contentView.frame.size.height + kBottomSafeAreaHeight);
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.dismissOnBackgroundTap = YES;
        self.popupType = XHPopupType_ActionSheet;
        [self addSubview:contentView];
    }
    return self;
}

- (instancetype)initInputViewWithContentView:(UIView *)contentView{
    CGRect frame = CGRectMake(0, 0, contentView.frame.size.width, contentView.frame.size.height);
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.dismissOnBackgroundTap = YES;
        self.popupType = XHPopupType_ActionSheet;
        [self addSubview:contentView];
    }
    return self;
}

@end;
