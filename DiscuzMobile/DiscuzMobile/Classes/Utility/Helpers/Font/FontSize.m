//
//  FontSize.m
//  DiscuzMobile
//
//  Created by HB on 16/7/12.
//  Copyright © 2016年 comsenz-service.com. All rights reserved.
//

#import "FontSize.h"

#define jtFontName iOS9?@"PingFangSC-Light":@".PingFang-SC-Light"

@implementation FontSize

+ (UIFont *)fontSize:(CGFloat)size {
    return [UIFont fontWithName:jtFontName size:size];
}

/**
 导航栏标题字体大小

 @return 字体大小
 */
+(UIFont*)NavTitleFontSize18 {
    
    return [UIFont fontWithName:@"PingFang SC" size:18.0];
}

/**
 banner字体大小
 黑体
 @return 字体大小
 */
+(UIFont*)BannerFontSize {
    
    return [UIFont fontWithName:@"Heiti SC" size:15.0];
}

/*
 *首页热帖标题字体大小
 */
+(UIFont*)HomecellTitleFontSize17{
    
    return [UIFont fontWithName:jtFontName size:17.0];
}

+ (UIFont*)NavBackFontSize {
    return [UIFont fontWithName:@"PingFang SC" size:16.0];
}

/*
 *首页热帖标题字体大小
 */
+(UIFont*)HomecellTitleFontSize15 {
    
    return [UIFont fontWithName:jtFontName size:15.0];
}


/*
 *首页热帖作者字体大小
 */
+(UIFont *)HomecellNameFontSize16{
    if (WIDTH == 320) {
       return [UIFont fontWithName:jtFontName size:14.0];
    }
    return [UIFont fontWithName:jtFontName size:14.5];
    
}

/*
 *首页热帖时间字体大小
 */
+(UIFont *)HomecellTimeFontSize14 {
    return [UIFont fontWithName:jtFontName size:12.0];
}

+(UIFont *)HomecellTimeFontSize16{
    return [UIFont fontWithName:jtFontName size:16.0];
    
}
+(UIFont *)HomecellmessageNumLFontSize10{
    return [UIFont fontWithName:jtFontName size:10.0];
}

+(UIFont *)ActiveListFontSize11{
    return [UIFont fontWithName:jtFontName size:11.0];
}
+(UIFont *)ForumInfoFontSize{
    if (WIDTH == 320) {
        return [UIFont fontWithName:jtFontName size:9.5];
    }
    if (WIDTH == 375) {
        return [UIFont fontWithName:jtFontName size:11.0];
    }
    return [UIFont fontWithName:jtFontName size:12.0];
}

+(UIFont *)forumInfoFontSize12{
    return [UIFont fontWithName:jtFontName size:12.0];
}

+(UIFont *)gradeFontSize9 {
    return [UIFont fontWithName:@"PingFang SC" size:9.0];
}

+(UIFont*)forumtimeFontSize14{
    return [UIFont fontWithName:jtFontName size:14.0];
}

+(UIFont*)messageFontSize14{
    return [UIFont fontWithName:jtFontName size:14.0];
}


/*
 *自定义导航栏目字体
 */
+(UIFont *)SlideTitleFontSize:(CGFloat)size andIsBold:(BOOL)isBold {
    NSString *fontName = jtFontName;
    if (isBold) {
        fontName = @"PingFang SC";
    }
    return [UIFont fontWithName:fontName size:size];
}
@end
