//
//  FontSize.h
//  DiscuzMobile
//
//  Created by HB on 16/7/12.
//  Copyright © 2016年 comsenz-service.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FontSize : NSObject

+ (UIFont *)fontSize:(CGFloat)size;

/**
 导航栏标题字体大小
 
 @return 字体大小
 */
+(UIFont*)NavTitleFontSize18;

/**
 banner字体大小
 
 @return 字体大小
 */
+(UIFont*)BannerFontSize;

/*
 *首页热帖标题字体大小
 */
+(UIFont*)HomecellTitleFontSize15;

/*
 * 导航返回自提大小
 */

+ (UIFont*)NavBackFontSize;

/*
 *首页热帖标题字体大小
 */
+(UIFont*)HomecellTitleFontSize17;

/*
 *首页热帖作者字体大小
 */
+(UIFont*)HomecellNameFontSize16;

/*
 *首页热帖时间字体大小
 */
+(UIFont *)HomecellTimeFontSize14;

+(UIFont*)messageFontSize14;

+(UIFont*)HomecellTimeFontSize16;

// 消息数量
+(UIFont*)HomecellmessageNumLFontSize10;

+(UIFont *)ActiveListFontSize11;

+(UIFont *)ForumInfoFontSize;

+(UIFont*)forumInfoFontSize12;

+(UIFont *)gradeFontSize9;

+(UIFont*)forumtimeFontSize14;

/*
 *自定义导航栏目字体
 */
+(UIFont *)SlideTitleFontSize:(CGFloat)size andIsBold:(BOOL)isBold;

@end
