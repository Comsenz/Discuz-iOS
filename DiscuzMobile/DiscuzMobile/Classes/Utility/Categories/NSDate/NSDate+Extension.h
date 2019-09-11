//
//  NSDate+Extension.h
//  DiscuzMobile
//
//  Created by piter on 2018/1/12.
//  Copyright © 2018年 comsenz-service.com.  All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Extension)


/**
 按格式输出date的日期

 @param format yyyy年MM月dd日
 @return 格式的时间字符串
 */
- (NSString *)stringFromDateFormat:(NSString *)format;

/**
 时间描述，几天前，几分钟前，今天，昨天
 
 @return 今天、昨天等等
 */
- (NSString *)descriptionStr;

/**
 时间戳字符串按格式输出日期
 
 @param timeStamp 时间戳字符串
 @param format yyyy年MM月dd日 或者 yyyy-MM-dd 、 MM-dd HH:mm 、 HH:mm
 @return 格式好的时间字符串
 */
+ (NSString *)timeStringFromTimestamp:(NSString *)timeStamp format:(NSString *)format;

/**
 时间戳日期是否是今天

 @param timeStamp 时间戳
 @return YES 或 NO
 */
+ (BOOL)isToday:(NSString *)timeStamp;

@end
