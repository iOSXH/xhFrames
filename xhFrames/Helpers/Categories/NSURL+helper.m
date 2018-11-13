//
//  NSURL+helper.m
//  xianghui
//
//  Created by JackLee on 2018/8/15.
//  Copyright © 2018年  xh. All rights reserved.
//

#import "NSURL+helper.h"

@implementation NSURL (helper)
+ (NSURL *)urlByCheckCharacterWithString:(NSString *)urlString {
    NSURL *url = [NSURL URLWithString:urlString];
    if (!url) {
        NSString *encodedURLString =
        [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        url = [NSURL URLWithString:encodedURLString];
    }
    return url;
}

@end
