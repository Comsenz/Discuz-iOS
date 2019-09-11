//
//  NSDate+Extension.m
//  DiscuzMobile
//
//  Created by piter on 2018/1/12.
//  Copyright © 2018年 comsenz-service.com.  All rights reserved.
//

#import "NSDate+Extension.h"

@implementation NSDate (Extension)

/**
 按格式输出date的日期
 
 @param format yyyy年MM月dd日
 @return 格式的时间字符串
 */
- (NSString *)stringFromDateFormat:(NSString *)format {
    NSString *date;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    date = [formatter stringFromDate:self];
    return date;
}


/**
 时间描述，几天前，几分钟前，今天，昨天

 @return 今天、昨天等等
 */
- (NSString *)descriptionStr {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en"];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSString *formatterStr = @"HH:mm";
    
    // 判断是否是今天
    if ([calendar isDateInToday:self]) {
        NSInteger interval = [[NSDate date] timeIntervalSinceDate:self];
        if (interval < 60) {
            return @"刚刚";
        }
        else if (interval <60*60) {//时间小于一个小时
            return [NSString stringWithFormat:@"%ld分钟前",(long)interval/60];
        }
        else if(interval <24*60*60){//时间小于一天
            return [NSString stringWithFormat:@"%ld小时前",(long)interval/(60*60)];
        }
        
    } else if ([calendar isDateInYesterday:self]) {
        
        formatterStr = [NSString stringWithFormat:@"昨天 %@",formatterStr];
    } else {
        
        int unit = NSCalendarUnitDay | NSCalendarUnitMonth |  NSCalendarUnitYear;
        // 1.获得当前时间的年月日
        NSDateComponents *nowCmps = [calendar components:unit fromDate:[NSDate date]];
        
        NSDateComponents *selfComps = [calendar components:unit fromDate:self];
//        NSDateComponents *comps = [calendar components:NSCalendarUnitYear fromDate:self toDate:[NSDate date] options:(NSCalendarWrapComponents)];
        
        if (selfComps.year != nowCmps.year) {
            formatterStr = @"yyyy-MM-dd";
        } else {
            
            // 一年以内
            formatterStr = [NSString stringWithFormat:@"MM-dd %@",formatterStr];
            
        }
    }
    
    dateFormatter.dateFormat = formatterStr;
    
    return [dateFormatter stringFromDate:self];
}

/**
 时间戳字符串按格式输出日期

 @param timeStamp 时间戳字符串
 @param format yyyy年MM月dd日 或者 yyyy-MM-dd 、 MM-dd HH:mm 、 HH:mm
 @return 格式好的时间字符串
 */
+ (NSString *)timeStringFromTimestamp:(NSString *)timeStamp format:(NSString *)format {
    NSTimeInterval createdAt = [timeStamp doubleValue];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [NSDateFormatter setDefaultFormatterBehavior:NSDateFormatterBehaviorDefault];
    [dateFormatter setDateFormat:format];
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:createdAt];
    return [dateFormatter stringFromDate:date];
}

+ (NSString *)getStringTimweWithDate:(NSDate *)dateStr {
    NSString * timeSp = [NSString stringWithFormat:@"%ld", (long)[dateStr timeIntervalSince1970]];
    return timeSp;
}

/**
 时间戳日期是否是今天
 
 @param timeStamp 时间戳
 @return YES 或 NO
 */
+ (BOOL)isToday:(NSString *)timeStamp {
    NSTimeInterval createdAt = [timeStamp doubleValue];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:createdAt];
    return [[NSCalendar currentCalendar] isDateInToday:date];
}

@end
