//
//  XHBaseCollectionViewCell.h
//  xianghui
//
//  Created by xianghui on 2018/8/15.
//  Copyright © 2018年 xh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XHBaseCellProtocol.h"

@interface XHBaseCollectionViewCell : UICollectionViewCell<XHBaseCellProtocol>

@end



@interface XHBaseCollectionReuseView : UICollectionReusableView<XHBaseCellProtocol>

@end
