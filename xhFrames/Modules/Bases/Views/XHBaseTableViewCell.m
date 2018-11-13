//
//  XHBaseTableViewCell.m
//  xianghui
//
//  Created by xianghui on 2018/8/15.
//  Copyright © 2018年 xh. All rights reserved.
//

#import "XHBaseTableViewCell.h"
@interface XHBaseTableViewCell()


@end
@implementation XHBaseTableViewCell

@synthesize indexPath,baseDelegate,colorViews;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initSubViews];
    }
    return self;
}

+(CGFloat)CellHeight{
    return UITableViewAutomaticDimension;
}

+ (CGFloat)estimatedCellHeight{
    return 0;
}

+ (NSString *)CellReuseIdentifier{
    NSString *cellId = [NSString stringWithFormat:@"ID%@",NSStringFromClass(self)];
    return cellId;
}

- (void)initSubViews{
    
    self.selectionStyle = UITableViewCellSelectionStyleDefault;
    self.sakura.backgroundColor(kThemeKey_BGC01);
    self.contentView.sakura.backgroundColor(kThemeKey_BGC01);
    
    self.selectedBackgroundView = [[UIView alloc] init];
    self.selectedBackgroundView.sakura.backgroundColor(kThemeKey_BGC05);
    
}

- (void)updateViewWithModel:(id)model{
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated{
    
    if (self.colorViews && self.colorViews.count > 0) {
        NSMutableArray *colors = [NSMutableArray array];
        NSMutableArray *views = [NSMutableArray array];
        
        for (UIView *view in self.colorViews) {
            if (view.backgroundColor && ![view.backgroundColor isEqual:[UIColor clearColor]]) {
                [colors addObject:view.backgroundColor];
                [views addObject:view];
            }
        }
        
        [super setSelected:selected animated:animated];
        
        for (NSInteger i = 0; i < colors.count; i ++) {
            UIView *view = [views objectAtIndex:i];
            UIColor *color = [colors objectAtIndex:i];
            
            [view setBackgroundColor:color];
        }
    }else{
        
        [super setSelected:selected animated:animated];
    }
    
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
    
    
    if (self.colorViews && self.colorViews.count > 0) {
        NSMutableArray *colors = [NSMutableArray array];
        NSMutableArray *views = [NSMutableArray array];
        
        for (UIView *view in self.colorViews) {
            if (view.backgroundColor && ![view.backgroundColor isEqual:[UIColor clearColor]]) {
                [colors addObject:view.backgroundColor];
                [views addObject:view];
            }
        }
        
        [super setHighlighted:highlighted animated:animated];
        
        for (NSInteger i = 0; i < colors.count; i ++) {
            UIView *view = [views objectAtIndex:i];
            UIColor *color = [colors objectAtIndex:i];
            
            [view setBackgroundColor:color];
        }
    }else{
        [super setHighlighted:highlighted animated:animated];
    }
}

@end



@implementation XHBaseTableViewHeaderFooterView

@synthesize indexPath,baseDelegate;

- (instancetype) initWithReuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        [self initSubViews];
    }
    return self;
}

+ (CGFloat)HeaderFooterHeight{
    return 0;
}

+ (NSString *)CellReuseIdentifier{
    NSString *cellId = [NSString stringWithFormat:@"ID%@",NSStringFromClass(self)];
    return cellId;
}


- (void)initSubViews{
//    self.sakura.backgroundColor(kThemeKey_BGC01);
    self.contentView.sakura.backgroundColor(kThemeKey_BGC01);
}

- (void)updateViewWithModel:(id)model{
    
}

@end
