//
//  XHBaseTableViewCell.h
//  xianghui
//
//  Created by xianghui on 2018/8/15.
//  Copyright © 2018年 xh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XHBaseCellProtocol.h"

@interface XHBaseTableViewCell : UITableViewCell<XHBaseCellProtocol>

@end


@interface XHBaseTableViewHeaderFooterView : UITableViewHeaderFooterView<XHBaseCellProtocol>

@end
