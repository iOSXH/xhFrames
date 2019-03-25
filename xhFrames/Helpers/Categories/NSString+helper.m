//
//  NSString+helper.m
//  xianghui
//
//  Created by xianghui on 2018/8/14.
//  Copyright © 2018年  xh. All rights reserved.
//

#import "NSString+helper.h"
#import "NSURL+helper.h"
#import <AdSupport/AdSupport.h>
#import <sys/socket.h>
#import <sys/sysctl.h>
#import <net/if.h>
#import <net/if_dl.h>
#import <UICKeyChainStore.h>

@implementation NSString (helper)

+ (NSString *)randomStringWithLength:(NSUInteger)length{
    NSString *letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    
    NSMutableString *randomString = [NSMutableString stringWithCapacity:length];
    
    for (int i=0; i<length; i++) {
        NSUInteger index = arc4random_uniform((uint32_t)letters.length);
        
        [randomString appendFormat: @"%C", [letters characterAtIndex:index]];
    }
    
    return randomString;
}

+ (NSString *)randomSmallStringWithLength:(NSUInteger)length{
    NSString *letters = @"abcdefghijklmnopqrstuvwxyz0123456789";
    
    NSMutableString *randomString = [NSMutableString stringWithCapacity:length];
    
    for (int i=0; i<length; i++) {
        NSUInteger index = arc4random_uniform((uint32_t)letters.length);
        
        [randomString appendFormat: @"%C", [letters characterAtIndex:index]];
    }
    
    return randomString;
}

-(NSUInteger)textLength{
    
    NSUInteger asciiLength = 0;
    
    for (NSUInteger i = 0; i < self.length; i++) {
        
        
        unichar uc = [self characterAtIndex: i];
        
        asciiLength += isascii(uc) ? 1 : 2;
    }
    
    NSUInteger unicodeLength = asciiLength;
    
    return unicodeLength;
    
}


- (CGRect)imageCropRect{
    CGRect rect = CGRectZero;
    
    if ([self containsString:@"__"]) {
        NSArray *array = [self componentsSeparatedByString:@"__"];
        NSString *cropStr = [array firstObject];
        if ([cropStr hasPrefix:@"c"]) {
            cropStr = [cropStr stringByReplacingOccurrencesOfString:@"c" withString:@""];
            NSArray *ary = [cropStr componentsSeparatedByString:@"_"];
            if (ary.count == 4) {
                CGFloat x = [[ary objectAtIndex:0] floatValue];
                CGFloat y = [[ary objectAtIndex:1] floatValue];
                CGFloat w = [[ary objectAtIndex:2] floatValue];
                CGFloat h = [[ary objectAtIndex:3] floatValue];
                rect = CGRectMake(x, y, w, h);
            }
        }
    }
    
    return rect;
}

- (CGSize)imageSize{
    CGSize size = CGSizeZero;
    if ([self containsString:@"__"]) {
        NSArray *array = [self componentsSeparatedByString:@"__"];
        NSString *sizeStr = [array lastObject];
        
        NSArray *ary = [sizeStr componentsSeparatedByString:@"_"];
        if (ary.count == 2) {
            NSString *wS = [ary objectAtIndex:0];
            NSString *hS = [ary objectAtIndex:1];
            
            CGFloat w = [[wS stringByReplacingOccurrencesOfString:@"w" withString:@""] floatValue];
            CGFloat h = [[hS stringByReplacingOccurrencesOfString:@"w" withString:@""] floatValue];
            size = CGSizeMake(w, h);
        }
        
    }
    
    return size;
    
}

- (NSURL *)URLAutoCrop{
    NSURL *imageUrl = [self URLByCheckCharacter];
    
    if (imageUrl) {
        NSString *query = imageUrl.query;
        if (![query containsString:@"imageMogr2"]) {
            CGRect cropRect = [self imageCropRect];
            if (!CGRectEqualToRect(cropRect, CGRectZero)) {
                NSString *urlStr = imageUrl.absoluteString;
                urlStr = [urlStr stringByAppendingFormat:@"%@imageMogr2/crop/!%.0fx%.0fa%.0fa%.0f", query.length>0?@"|":@"?", cropRect.size.width, cropRect.size.height, cropRect.origin.x, cropRect.origin.y];
            }
        }
    }
    return imageUrl;
}


- (NSURL *)URLWithSize:(CGSize)size{
    NSURL *imageUrl = [self URLByCheckCharacter];
    if (imageUrl) {
        NSString *query = imageUrl.query;
        if (![query containsString:@"imageView2"]) {
            if (!CGSizeEqualToSize(CGSizeZero, size)) {
                NSString *urlStr = imageUrl.absoluteString;
                urlStr = [urlStr stringByAppendingFormat:@"%@imageView2/%@/w/%.0f/h/%.0f", query.length>0?@"|":@"?", @(1), size.width, size.height];
            }
        }
    }
    
    return imageUrl;
}

- (NSURL *)URLWithsize:(CGSize)size contentMode:(UIViewContentMode)contentMode cornerRadius:(CGFloat)cornerRadius{
    NSURL *url = [NSURL urlByCheckCharacterWithString:self];
    
    if (!url) {
        return nil;
    }
    
    if ([url isFileURL]) {
        return url;
    }
    
//    if (![self isQiniuResource]) {
//        return url;
//    }
    
    if (CGSizeEqualToSize(size, CGSizeZero) && cornerRadius <=0) {
        return url;
    }
    
    
    BOOL hasAppendQiniuQuery = NO;
    if (url.query.length <= 0) {
        hasAppendQiniuQuery = NO;
    } else {
        if ([url.query hasPrefix:@"imageView"]) {
            hasAppendQiniuQuery = YES;
        }else if ([url.query hasPrefix:@"imageMogr"]) {
            hasAppendQiniuQuery = YES;
        }else if ([url.query hasPrefix:@"roundPic"]) {
            hasAppendQiniuQuery = YES;
        }
    }
    
    if (hasAppendQiniuQuery) {
        return url;
    }
    
    
    
    NSString *fitSizePath = nil;
    NSString *path = [NSString stringWithFormat:@"%@://%@%@",url.scheme,url.host,url.path];
    
    NSString *param = nil;
    if (CGSizeEqualToSize(CGSizeZero, size)) {
        CGFloat scale = [UIScreen mainScreen].scale;
        scale = MIN(2.0, scale);
        
        size.width *= scale;
        size.height *= scale;
        
        //需要缩放
        NSInteger type = 0;
        if(contentMode == UIViewContentModeScaleAspectFill){
            type = 1;
        }else if(contentMode == UIViewContentModeScaleAspectFit){
            type = 2;
        }
        
        param = [NSString stringWithFormat:@"imageView2/%@/w/%.0f/h/%.0f",@(type),size.width,size.height];
    }
    
    if (cornerRadius > 0) {
        if (param) {
            param = [param stringByAppendingFormat:@"|roundPic/radius/%@",@(cornerRadius)];
        }else{
            param = [NSString stringWithFormat:@"roundPic/radius/%@",@(cornerRadius)];
        }
    }
    
    fitSizePath = [path stringByAppendingFormat:@"?%@",param];
    
    
    //可能自己也会带尾巴
    if (url.query.length > 0) {
        fitSizePath = [fitSizePath stringByAppendingFormat:@"&%@",url.query];
    }
    
    NSURL *composedURL = [NSURL URLWithString:fitSizePath];
    return composedURL;
}


+ (NSString *)astroWithDate:(NSDate *)date{
    return [self getAstroWithMonth:date.month day:date.day];
}

+(NSString *)getAstroWithMonth:(NSInteger)m day:(NSInteger)d{
    
    NSString *errMsg = @"";
    
    NSString *astroString = @"魔羯水瓶双鱼白羊金牛双子巨蟹狮子处女天秤天蝎射手魔羯";
    NSString *astroFormat = @"102123444543"; NSString *result;
    if (m<1||m>12||d<1||d>31){
        return errMsg;
    }
    if(m==2 && d>29){
        return errMsg;
    } else if(m==4 || m==6 || m==9 || m==11) {
        if (d>30) {
            return errMsg;
        }
    }
    result = [NSString stringWithFormat:@"%@座",[astroString substringWithRange:NSMakeRange(m*2-(d < [[astroFormat substringWithRange:NSMakeRange((m-1), 1)] intValue] - (-19))*2,2)]];
    return result;
}



- (NSURL *)URLByCheckCharacter{
    NSURL *url = [NSURL URLWithString:self];
    if (!url) {
        NSString *encodedURLString = [self stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        url = [NSURL URLWithString:encodedURLString];
    }
    return url;
}

+ (NSString *)timeStringWithDate:(NSDate *)date{
    
    NSString* timestamp = @"";
    
    NSTimeInterval distance = [[NSDate date] timeIntervalSinceDate:date];
    if (distance < 0){
        distance = 0;
    }
//    if (date.isToday) {
//        
//    }else if (date.isYesterday){
//        
//    }
//    
    
    
    if (distance <=60) {
        timestamp = @"刚刚";
    } else if (distance < 60 * 60) {
        distance = distance / 60;
        timestamp = [NSString stringWithFormat:@"%.0f%@", distance, @"分钟前"];
    } else if (distance < 60 * 60 * 24) {
        distance = distance / 60 / 60;
        timestamp = [NSString stringWithFormat:@"%.0f%@", distance, @"小时前"];
    }else if (distance < 60 * 60 * 48) {
        timestamp = @"昨天";
    }else if (distance < 60 * 60 * 24 * 365) {
        timestamp = [date stringWithFormat:@"MM月dd日"];
    }else {
        timestamp = [date stringWithFormat:@"yyyy年MM月dd日"];
    }
    
    return timestamp;
    
}


+ (NSString *)timeString:(NSTimeInterval)time{
    NSString *str = @"";
    if (time <= 60) {
        str = @"刚刚";
    } else if (time < 60 * 60) {
        str = [NSString stringWithFormat:@"%@分钟前", @((NSInteger)time / 60)];
    } else if (time < (3600 * 24)) {
        str = [NSString stringWithFormat:@"%@小时前", @((NSInteger)time / 3600)];
    } else {
        str = [NSString stringWithFormat:@"%@天前", @((NSInteger)time / (3600*24))];
    }
    return str;
}


+ (NSString *)timeString:(NSTimeInterval)time format:(NSString *)format{
    
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:-time];
    
    NSString *timeStr = [date stringWithFormat:format];
    
    return timeStr;
}

+ (NSString *)distanceStrWithDis:(NSInteger)dis{
    NSString *str = @"";
    if (dis >= 1000) {
        CGFloat a = (CGFloat)dis/1000;
        str = [NSString stringWithFormat:@"%.2f", a];
        str = [NSString stringWithFormat:@"%@ km",@(str.floatValue)];
    }else{
        str = [NSString stringWithFormat:@"%@ m", @(dis)];
    }
    return str;
}






+ (NSString *)uniqID{
    UICKeyChainStore *keychain = [UICKeyChainStore keyChainStore];
    NSString *key = @"xianghui-uuid";
    NSString *uniqueIdentifier = [keychain stringForKey:key];
    if (uniqueIdentifier.length <= 0) {
        DDLogDebug(@"第一次设置uuid，以后再也不要设置了");
        if( [UIDevice instancesRespondToSelector:@selector(identifierForVendor)] ) {
            // iOS 6+
            //            uniqueIdentifier = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
            uniqueIdentifier = [[NSUUID UUID] UUIDString];
            DDLogDebug(@"生成了设备码： %@",uniqueIdentifier);
        } else {
            // before iOS 6, so just generate an identifier and store it
            uniqueIdentifier = [[NSUserDefaults standardUserDefaults] objectForKey:@"identiferForVendor"];
            if( !uniqueIdentifier ) {
                CFUUIDRef uuid = CFUUIDCreate(NULL);
                uniqueIdentifier = (NSString*)CFBridgingRelease(CFUUIDCreateString(NULL, uuid));
                CFRelease(uuid);
                [[NSUserDefaults standardUserDefaults] setObject:uniqueIdentifier forKey:@"identifierForVendor"];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
        }
        
        keychain[key] = uniqueIdentifier;
    }
    
    if (!uniqueIdentifier) {
        uniqueIdentifier = @"";
    }
    
    return uniqueIdentifier;
}


+ (NSString *)advertisingUUID{
    UICKeyChainStore *keychain = [UICKeyChainStore keyChainStore];
    NSString *key = @"xianghui-advertising-uuid";
    NSString *uniqueIdentifier = [keychain stringForKey:key];
    if (uniqueIdentifier.length <= 0) {
        DDLogDebug(@"第一次设置 %@，以后再也不要设置了",key);
        Class asIdentifierMClass = NSClassFromString(@"ASIdentifierManager");
        
        if(asIdentifierMClass == nil){
            return @"";
        } else {
            ASIdentifierManager *asIM = [ASIdentifierManager sharedManager];
            
            if (asIM == nil) {
                return @"";
            }
            else{
                
                if(asIM.advertisingTrackingEnabled){
                    uniqueIdentifier = [asIM.advertisingIdentifier UUIDString];
                }
                else{
                    uniqueIdentifier = [asIM.advertisingIdentifier UUIDString];
                }
            }
        }
        keychain[key] = uniqueIdentifier;
    }
    
    if (!uniqueIdentifier) {
        uniqueIdentifier = @"";
    }
    
    return uniqueIdentifier;
}


+ (NSString *)macString{
    int mib[6];
    size_t len;
    char *buf;
    unsigned char *ptr;
    struct if_msghdr *ifm;
    struct sockaddr_dl *sdl;
    
    mib[0] = CTL_NET;
    mib[1] = AF_ROUTE;
    mib[2] = 0;
    mib[3] = AF_LINK;
    mib[4] = NET_RT_IFLIST;
    
    if ((mib[5] = if_nametoindex("en0")) == 0) {
        printf("Error: if_nametoindex error\n");
        return NULL;
    }
    
    if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 1\n");
        return NULL;
    }
    
    if ((buf = malloc(len)) == NULL) {
        printf("Could not allocate memory. error!\n");
        return NULL;
    }
    
    if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 2");
        free(buf);
        return NULL;
    }
    
    ifm = (struct if_msghdr *)buf;
    sdl = (struct sockaddr_dl *)(ifm + 1);
    ptr = (unsigned char *)LLADDR(sdl);
    NSString *macString = [NSString stringWithFormat:@"%02X:%02X:%02X:%02X:%02X:%02X",
                           *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    free(buf);
    
    return macString;
}


- (NSString *)localizedString{
    return kLocString(self);
}

@end
