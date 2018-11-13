//
//  SettingTableViewCell.m
//  sentiment
//
//  Created by xianghui on 2018/10/25.
//  Copyright © 2018 xianghui. All rights reserved.
//

#import "SettingTableViewCell.h"

@interface SettingTableViewCell ()

@property (nonatomic, strong) UIView *topLineView;

@property (nonatomic, strong) UILabel *leftLab;
@property (nonatomic, strong) UILabel *rightLab;
@property (nonatomic, strong) UIImageView *rightImgView;


@property (nonatomic, strong) UILabel *centerLab;

@end

@implementation SettingTableViewCell

+ (CGFloat)CellHeight{
    return sizeScale(50, YES);
}


- (void)initSubViews{
    [super initSubViews];
    
    self.topLineView = [UIView lineLayoutView];
    [self.contentView addSubview:self.topLineView];
    [self.topLineView autoSetDimension:ALDimensionHeight toSize:1];
    [self.topLineView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeBottom];
    
    CGFloat sideSpace = sizeScale(15, YES);
    
    self.leftLab = [UILabel newAutoLayoutView];
    self.leftLab.sakura.textColor(kThemeKey_TXC06);
    self.leftLab.font = [UIFont systemFontOfSize:sizeScale(15, YES)];
    [self.contentView addSubview:self.leftLab];
    [self.leftLab autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    [self.leftLab autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:sideSpace];
    
    self.rightLab = [UILabel newAutoLayoutView];
    self.rightLab.sakura.textColor(kThemeKey_TXC06);
    self.rightLab.font = [UIFont systemFontOfSize:sizeScale(13, YES)];
    [self.contentView addSubview:self.rightLab];
    [self.rightLab autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    [self.rightLab autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:sideSpace*2];
    
    self.rightImgView = [UIImageView newAutoLayoutView];
    self.rightImgView.image = kImageNamed(@"icon_seting_more");
    [self.contentView addSubview:self.rightImgView];
    [self.rightImgView autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    [self.rightImgView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:sideSpace];
    [self.rightImgView autoSetDimensionsToSize:CGSizeMake(sizeScale(5, YES), sizeScale(9, YES))];
    
    
    self.centerLab = [UILabel newAutoLayoutView];
    self.centerLab.sakura.textColor(kThemeKey_TXC02);
    self.centerLab.font = [UIFont systemFontOfSize:sizeScale(15, YES)];
    [self.contentView addSubview:self.centerLab];
    [self.centerLab autoCenterInSuperview];
    
}


- (void)updateViewWithModel:(id)model{
    self.topLineView.hidden = self.indexPath.row==0;
    
    NSString *leftTitle = [model objectForKey:@"leftTitle"];
    NSString *rightTitle = [model objectForKey:@"rightTitle"];
    NSString *centerTitle = [model objectForKey:@"centerTitle"];
    
    self.leftLab.text = leftTitle;
    self.rightLab.text = rightTitle;
    self.centerLab.text = centerTitle;
    
    BOOL hideRight = [[model objectForKey:@"hideRight"] boolValue];
    self.rightImgView.hidden = hideRight;
}

@end
