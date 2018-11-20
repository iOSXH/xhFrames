//
//  XHBaseTabBar.m
//  xianghui
//
//  Created by xianghui on 2018/8/13.
//  Copyright © 2018年 xh. All rights reserved.
//

#import "XHBaseTabBar.h"
#import "XHBaseTabBtn.h"

@interface XHBaseTabBar ()

@property (nonatomic, strong) NSArray *tabButtons;


@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIView *lineView;


@property (nonatomic, assign) CGRect tabFrame;


@end



@implementation XHBaseTabBar


- (instancetype)initWithDelegate:(id<YWTabBarDelegate>)delegate{
    self = [super init];
    if (self) {
        _myDelegate = delegate;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self initSubViews];
        
        
    }
    return self;
}


- (void)layoutSubviews{
    [super layoutSubviews];
    
//    if (!CGRectEqualToRect(self.tabFrame, self.bounds)) {
//        [self initSubViews];
//    }
    
    self.bgView.frame = self.bounds;
    [self bringSubviewToFront:self.bgView];
    
    self.lineView.frame = CGRectMake(0, 0, self.bounds.size.width, 1);
    [self bringSubviewToFront:self.lineView];
    
}

- (void)initSubViews{
    self.sakura.backgroundColor(kThemeKey_BGC01);
    
    if (!self.bgView) {
        self.bgView = [[UIView alloc] initWithFrame:self.bounds];
        self.bgView.sakura.backgroundColor(kThemeKey_BGC01);
        [self addSubview:self.bgView];
    }
    
    if (!self.lineView) {
        self.lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
        self.lineView.sakura.backgroundColor(kThemeKey_BGCLine);
        self.lineView.alpha = 0.8;
        [self addSubview:self.lineView];
    }
    
    [self.bgView removeAllSubviews];
    
    CGFloat dif = self.height - 49;
    if (dif > 0) {
        UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 49, self.width, dif)];
        bottomView.sakura.backgroundColor(kThemeKey_BGC01);
        [self.bgView addSubview:bottomView];
    }
    
    
    NSMutableArray *tabConfigs = [NSMutableArray arrayWithArray:@[@{@"imageNor":@"icon_tab_collect_unselected",
                                                                    @"imageSel":@"icon_tab_collect_selected",
                                                                    @"titleColrNor":@"#ACB5BF",
                                                                    @"titleColrSel":@"#333333",
                                                                    @"title":@"测试1"
                                                                    },
                                                                  @{@"imageNor":@"icon_tab_event_unselected",
                                                                    @"imageSel":@"icon_tab_event_selected",
                                                                    @"titleColrNor":@"#ACB5BF",
                                                                    @"titleColrSel":@"#333333",
                                                                    @"title":@"测试2"
                                                                    },
                                                                  @{@"imageNor":@"icon_tab_mine_unselected",
                                                                    @"imageSel":@"icon_tab_mine_selected",
                                                                    @"titleColrNor":@"#ACB5BF",
                                                                    @"titleColrSel":@"#333333",
                                                                    @"title":@"我的"
                                                                    }]];

    
    CGFloat sideSpace = 0;
    CGFloat space = 0;
    
    CGFloat width = (SCREEN_WIDTH - sideSpace*2 - space *(tabConfigs.count-1)) /tabConfigs.count;
    
    CGFloat height = 49;
    
    NSMutableArray *btns = [[NSMutableArray alloc] init];
    
    UIView *lastView = nil;
    CGFloat startX = sideSpace;
    for (NSInteger i = 0; i < tabConfigs.count; i++) {
        NSDictionary *config = [tabConfigs objectOrNilAtIndex:i];
        
        XHBaseTabBtn *btn = [[XHBaseTabBtn alloc] initWithFrame:CGRectMake(startX, 0, width, height) config:config];
        [btn addTarget:self action:@selector(tabBtnDidClicked:) forControlEvents:UIControlEventTouchUpInside];
        [btn addTarget:self action:@selector(tabBtnDidDoubelClicked:) forControlEvents:UIControlEventTouchDownRepeat];
        btn.tag = 10+i;
        [btn configureForAutoLayout];
        [self.bgView addSubview:btn];
        [btn autoSetDimension:ALDimensionHeight toSize:height];
        [btn autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:self.bgView withMultiplier:1.0/tabConfigs.count];
        [btn autoPinEdgeToSuperviewEdge:ALEdgeTop];
        if (lastView) {
            [btn autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:lastView];
        }else{
            [btn autoPinEdgeToSuperviewEdge:ALEdgeLeft];
        }
        
        lastView = btn;
        
        [btns addObject:btn];
        if (i == self.selectedIndex) {
            btn.selected = YES;
        }
        
        
        startX += (width+space);
    }
    self.tabButtons = btns;
    
    self.tabFrame = self.bounds;
}


- (void)setSelectedIndex:(NSInteger)selectedIndex{
    if (selectedIndex<0 ||selectedIndex>= self.tabButtons.count) {
        return;
    }
    XHBaseTabBtn *btn = [self.tabButtons objectOrNilAtIndex:selectedIndex];
    if (!btn) {
        return;
    }
    [self tabBtnDidClicked:btn];
}

- (void)tabBtnDidClicked:(UIButton *)sender{
    NSInteger index = sender.tag - 10;
    
    if ([self.myDelegate respondsToSelector:@selector(tabBar:shouldSelectIndex:)]) {
        if (![self.myDelegate tabBar:self shouldSelectIndex:(index)]) {
            return;
        }
    }
    
    if (index != self.selectedIndex) {
        UIButton *lastBtn = [self viewWithTag:10+self.selectedIndex];
        [lastBtn setSelected:NO];
        
        _selectedIndex = index;
        [sender setSelected:YES];
    }
    if ([self.myDelegate respondsToSelector:@selector(tabBar:didSelectIndex:)]) {
        [self.myDelegate tabBar:self didSelectIndex:self.selectedIndex];
    }
}

- (void)tabBtnDidDoubelClicked:(UIButton *)sender{
    if (!sender.selected) {
        return;
    }
    if ([self.myDelegate respondsToSelector:@selector(tabBar:didDoubleSelectIndex:)]) {
        [self.myDelegate tabBar:self didDoubleSelectIndex:self.selectedIndex];
    }
}




- (void)resetSubViews{
    
}


- (void)resetBadge:(BOOL)flag atIndex:(NSInteger)index{
    XHBaseTabBtn *btn = [self.tabButtons objectAtIndex:index];
    [btn resetBadge:flag];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
