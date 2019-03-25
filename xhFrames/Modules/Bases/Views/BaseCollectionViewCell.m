//
//  BaseCollectionViewCell.m
//  xianghui
//
//  Created by xianghui on 2018/8/15.
//  Copyright © 2018年 xh. All rights reserved.
//

#import "BaseCollectionViewCell.h"

@implementation BaseCollectionViewCell
@synthesize indexPath,baseDelegate;
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubViews];
    }
    return self;
}

+ (UIEdgeInsets)ItemInsets{
    return UIEdgeInsetsZero;
}

// 行间距
+ (CGFloat)ItemMinLineSpacing{
    return 0.0;
}

// 列间距
+ (CGFloat)ItemMinInterSpacing{
    return 0.0;
}

+ (CGSize)ItemSize{
    return CGSizeZero;
}

+ (NSString *)CellReuseIdentifier{
    NSString *cellId = [NSString stringWithFormat:@"ID%@",NSStringFromClass(self)];
    return cellId;
}


- (void)initSubViews{
    
}

- (void)updateViewWithModel:(id)model{
    
}

@end



@implementation BaseCollectionReuseView
@synthesize indexPath,baseDelegate;

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubViews];
    }
    return self;
}
+ (NSString *)CellReuseIdentifier{
    NSString *cellId = [NSString stringWithFormat:@"ID%@",NSStringFromClass(self)];
    return cellId;
}

+ (CGSize)ItemSize{
    return CGSizeZero;
}


@end
