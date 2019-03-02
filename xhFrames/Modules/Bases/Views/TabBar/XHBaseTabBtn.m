//
//  XHBaseTabBtn.m
//  xianghui
//
//  Created by xianghui on 2018/8/13.
//  Copyright © 2018年 xh. All rights reserved.
//

#import "XHBaseTabBtn.h"


@interface XHBaseTabBtn ()

@property (nonatomic, strong) NSDictionary *config;
@property (nonatomic, strong) UIImageView *iconImgView;
@property (nonatomic, strong) UILabel *titleLab;
//@property (nonatomic, strong) UIView *badgeView;

@end

@implementation XHBaseTabBtn

- (instancetype)initWithFrame:(CGRect)frame config:(NSDictionary *)config{
    self = [super initWithFrame:frame];
    if (self) {
        _config = config;
        
        
        _iconImgView = [UIImageView newAutoLayoutView];
        [self addSubview:_iconImgView];
        [_iconImgView autoSetDimensionsToSize:CGSizeMake(24, 24)];
        [_iconImgView autoAlignAxisToSuperviewAxis:ALAxisVertical];
        [_iconImgView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:7];
        
        _titleLab = [UILabel newAutoLayoutView];
        _titleLab.font = [UIFont systemFontOfSize:10];
        _titleLab.text = NSLocalizedString([config objectForKey:@"title"], nil) ;
        [self addSubview:_titleLab];
        [_titleLab autoAlignAxisToSuperviewAxis:ALAxisVertical];
        [_titleLab autoPinEdgeToSuperviewEdge:ALEdgeBottom];
        [_titleLab autoSetDimension:ALDimensionHeight toSize:18];
        
        
        [self setSelected:NO];
        
        
//        _badgeView = [UIView newAutoLayoutView];
//        _badgeView.sakura.backgroundColor(kThemeKey_BGC04);
//        _badgeView.layer.masksToBounds = YES;
//        _badgeView.layer.cornerRadius = 5;
//        _badgeView.layer.borderWidth = 2;
//        _badgeView.layer.sakura.borderColor(kThemeKey_BGC01);
//        [self addSubview:_badgeView];
//        [_badgeView autoSetDimensionsToSize:CGSizeMake(10, 10)];
//        [_badgeView autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:_iconImgView withOffset:2];
//        [_badgeView autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:_iconImgView withOffset:2];
//
//        _badgeView.hidden = YES;
    }
    return self;
}



- (void)setSelected:(BOOL)selected{
    [super setSelected:selected];
    
    if (selected) {
        NSString *imgName = [self.config objectForKey:@"imageSel"];
        self.iconImgView.image = kImageNamed(imgName);
        
        NSString *colorStr = [self.config objectForKey:@"titleColrSel"];
        self.titleLab.textColor = [UIColor colorWithHexString:colorStr];
    }else{
        NSString *imgName = [self.config objectForKey:@"imageNor"];
        self.iconImgView.image = kImageNamed(imgName);
        
        NSString *colorStr = [self.config objectForKey:@"titleColrNor"];
        self.titleLab.textColor = [UIColor colorWithHexString:colorStr];
    }
//    [self bringSubviewToFront:self.iconImgView];
  
}


- (void)resetBadge:(BOOL)flag{
//    self.badgeView.hidden = !flag;
}

@end
