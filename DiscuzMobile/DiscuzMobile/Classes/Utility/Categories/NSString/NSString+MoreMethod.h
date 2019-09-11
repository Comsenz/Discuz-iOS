//
//  NSString+MoreMethod.h
//  DiscuzMobile
//
//  Created by HB on 16/7/12.
//  Copyright © 2016年 comsenz-service.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (MoreMethod)

- (BOOL)isQQ;
- (BOOL)isPhoneNumber;
- (BOOL)isPwd;
- (BOOL)isName;

- (CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize;

- (CGFloat)heightForStringWithWidth:(CGFloat)width;

- (BOOL)isNum:(NSString *)checkedNumString;

// 计算字符串长度
-  (int)convertToInt:(NSString*)strtemp;

- (NSString *)getFileName;

- (NSString *)utf2gbk;

- (NSString *)stringByRemovingChineseWhitespace;

// 四舍五入
- (NSString *)managerCountWithNumstring;

// 保留一位小数，后面舍去
- (NSString *)onePointCountWithNumstring;

- (NSString *)formatNums;

// 拼接域名
- (NSString *)makeDomain;

// 判断链接是否包含域名
- (BOOL)ifUrlContainDomain;

// 计算两个时间字符串 开始时间是否早于结束时间 2016-12-05 00:00
- (BOOL)checkStarttimeAndEndtime:(NSString *)endtime;

// 过滤掉HTML标签
- (NSString *)flattenHTMLTrimWhiteSpace:(BOOL)trim;

//  标题时间 里面有html ">"  "空格"  等 HTML符号 需要转换
- (NSString *)transformationStr;

- (NSString *)dealSpan;

- (NSString *)dealImg;

- (NSMutableAttributedString *)getAttributeStr;
/*
 *MD5 加密
 */
- (NSString*)getmd5WithString;

+(BOOL)resolveHost:(NSString*)hostname;

@end
