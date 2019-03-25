//
//  PopupView.h
//  xianghui
//
//  Created by xianghui on 2018/8/16.
//  Copyright © 2018年 xh. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    PopupType_Alert = 0,
    PopupType_ActionSheet,
    PopupType_FullScreen,
} PopupType;

typedef void(^PopupViewLifeBlock)(NSInteger lifeState); ///< 生命周期 1 willShow 2 didShow 3 willHide 4 didHide

@interface PopupView : UIView

@property (nonatomic, assign) PopupType popupType;
@property (nonatomic, assign) BOOL dismissOnBackgroundTap;


@property (nonatomic, copy) PopupViewLifeBlock liftBlock;

- (void)showViewAnimated:(BOOL)flag;
- (void)dismissViewAnimated:(BOOL)flag;


- (void)resetViewFrame:(CGRect)frame;

@end



@interface PopupAlertView : PopupView

- (instancetype)initCloseViewWithContentView:(UIView *)contentView;

@end



@interface PopupActionView : PopupView

- (instancetype)initBottomViewWithContentView:(UIView *)contentView title:(NSString *)title;

- (instancetype)initBottomViewWithContentView:(UIView *)contentView;


- (instancetype)initInputViewWithContentView:(UIView *)contentView;

@end
