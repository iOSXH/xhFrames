//
//  XHPopupView.h
//  xianghui
//
//  Created by xianghui on 2018/8/16.
//  Copyright © 2018年 xh. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    XHPopupType_Alert = 0,
    XHPopupType_ActionSheet,
    XHPopupType_FullScreen,
} XHPopupType;

typedef void(^XHPopupViewLifeBlock)(NSInteger lifeState); ///< 生命周期 1 willShow 2 didShow 3 willHide 4 didHide

@interface XHPopupView : UIView

@property (nonatomic, assign) XHPopupType popupType;
@property (nonatomic, assign) BOOL dismissOnBackgroundTap;


@property (nonatomic, copy) XHPopupViewLifeBlock liftBlock;

- (void)showViewAnimated:(BOOL)flag;
- (void)dismissViewAnimated:(BOOL)flag;


- (void)resetViewFrame:(CGRect)frame;

@end



@interface XHPopupAlertView : XHPopupView

- (instancetype)initCloseViewWithContentView:(UIView *)contentView;

@end



@interface XHPopupActionView : XHPopupView

- (instancetype)initBottomViewWithContentView:(UIView *)contentView title:(NSString *)title;

- (instancetype)initBottomViewWithContentView:(UIView *)contentView;


- (instancetype)initInputViewWithContentView:(UIView *)contentView;

@end
