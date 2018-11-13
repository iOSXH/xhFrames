//
//  NSDate+helper.m
//  xianghui
//
//  Created by JackLee on 2018/8/20.
//  Copyright © 2018年  xh. All rights reserved.
//

#import "NSDate+helper.h"
//#import "TimeUtiles.h"

@implementation NSDate (helper)

//- (NSString *)ywDateToCalculateString{
//    NSDate *date = [NSDate date];
//    NSTimeInterval interval = [date timeIntervalSinceDate:self];
//    if (interval<0) {//未发生的时间暂时不做处理
//        return @"";
//    }
//    NSCalendar *calender = [NSCalendar currentCalendar];
//    NSInteger currentYear = [calender component:NSCalendarUnitYear fromDate:date];
//    NSInteger targetYear = [calender component:NSCalendarUnitYear fromDate:self];
//    if (currentYear == targetYear) {
//        if (interval>24 *60 *60) {
//            return [TimeUtiles timeStringWithEFormatDay:self];
//        }else if (interval == 24 *60 *60){
//            return @"昨天";
//        }else if (interval >= 60 * 60){
//            NSInteger hour = interval/(60 *60);
//            return [NSString stringWithFormat:@"%@小时前",@(hour)];
//        }else if (interval>= 3 *60){
//            NSInteger minute = interval/60;
//            return [NSString stringWithFormat:@"%@分钟前",@(minute)];
//        }
//        return @"刚刚";
//    }
//    return [TimeUtiles timeStringWithDFormatDay:self];
//}

@end
