//
//  BaseTableViewCell.h
//  xianghui
//
//  Created by xianghui on 2018/8/15.
//  Copyright © 2018年 xh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseCellProtocol.h"

@interface BaseTableViewCell : UITableViewCell<BaseCellProtocol>

@end


@interface BaseTableViewHeaderFooterView : UITableViewHeaderFooterView<BaseCellProtocol>

@end
