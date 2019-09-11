//
//  NSString+MoreMethod.m
//  DiscuzMobile
//
//  Created by HB on 16/7/12.
//  Copyright © 2016年 comsenz-service.com. All rights reserved.
//

#import "NSString+MoreMethod.h"
#define CC_MD5_DIGEST_LENGTH 16
#import <CommonCrypto/CommonDigest.h>

#include <sys/types.h>
#include <sys/socket.h>
#include <arpa/inet.h>


@implementation NSString (MoreMethod)

// 匹配
- (BOOL)match:(NSString *)pattern {
    
    NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:pattern options:0 error:nil];
    
    // 2 测试字符串
    NSArray *resulets = [regex matchesInString:self options:0 range:NSMakeRange(0, self.length)];
    
    return resulets.count > 0;
    
}

- (BOOL)isQQ {
    NSString *pattern = @"^[1-9]\\d{4,10}$";
    return [self match:pattern];
}

- (BOOL)isPhoneNumber {
    NSString *pattern = @"^1[34578]\\d{9}$";
    return [self match:pattern];
}

- (BOOL)isPwd {
    NSString *pattern = @"[0-9]\\d{4,9}";
    return [self match:pattern];
}

// 邮箱
- (BOOL)isName {
    NSString *pattern = @"^([a-zA-Z0-9_-])+@([a-zA-Z0-9_-])+(.[a-zA-Z0-9_-])+";
    return [self match:pattern];
}

- (CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize {
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}

- (CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize andAttribute:(NSDictionary *)attrs {
    return [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}

- (CGFloat)heightForStringWithWidth:(CGFloat)width {
    //获取当前文本的属性
    NSAttributedString * attrStr = [[NSAttributedString alloc] initWithString:self];
    NSRange range = NSMakeRange(0, attrStr.length);
    // 获取该段attributedString的属性字典
    NSDictionary * dic = [attrStr attributesAtIndex:0 effectiveRange:&range];
    // 计算文本的大小
    CGSize sizeToFit = [self boundingRectWithSize:CGSizeMake(width , MAXFLOAT)
                                           options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading                                         attributes:dic
                                           context:nil].size;
    return sizeToFit.height ;
}

- (BOOL)isNum:(NSString *)checkedNumString {
    checkedNumString = [checkedNumString stringByTrimmingCharactersInSet:[NSCharacterSet decimalDigitCharacterSet]];
    if(checkedNumString.length > 0) {
        return NO;
    }
    return YES;
}

// 计算字符串长度
-  (int)convertToInt:(NSString*)strtemp {
    
    int strlength = 0;
    char* p = (char*)[strtemp cStringUsingEncoding:NSUnicodeStringEncoding];
    for (int i=0 ; i<[strtemp lengthOfBytesUsingEncoding:NSUnicodeStringEncoding] ;i++) {
        
        if (*p) {
            p++;
            strlength++;
            
        }
        else {
            p++;
            
        }
    }
    return (strlength+1)/2;
    
}

- (NSString *)getFileName {
    NSString *path = self;
    
    path = [path stringByReplacingOccurrencesOfString:@"\\" withString:@"/"];
    path = [path stringByReplacingOccurrencesOfString:@"//" withString:@"/"];
    NSArray *parts = [path componentsSeparatedByString:@"/"];
    
    return [parts lastObject];
}

// 汉字GBK编码
- (NSString *)utf2gbk {
    NSStringEncoding gbkEncoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    // 汉字GBK编码
    NSString *dataGBK = [self stringByAddingPercentEscapesUsingEncoding:gbkEncoding];
    return  dataGBK;
}

- (NSString *)stringByRemovingChineseWhitespace
{
    return [self stringByReplacingOccurrencesOfString:@"　" withString:@""];
}

// 四舍五入
- (NSString *)managerCountWithNumstring {
    if ([self floatValue] >= 100000000){
        float i = [self floatValue]/100000000;
        return [NSString stringWithFormat:@"%.1f亿",i];
    }
    else  if ([self floatValue] >= 10000) {
        float i = [self floatValue]/10000;
        return [NSString stringWithFormat:@"%.1f万",i];
    }
    else {
        return self;
    }
}

// 保留一位小数，后面舍去
- (NSString *)onePointCountWithNumstring {
    if ([self integerValue] >= 100000000){
        float i = [self floatValue]/100000000;
        i = floorf(i * 10 ) / 10;
        return [NSString stringWithFormat:@"%.1f亿",i];
    }
    else  if ([self integerValue] >= 10000) {
        float i = [self floatValue]/10000;
        i = floorf(i * 10) / 10;
        return [NSString stringWithFormat:@"%.1f万",i];
    }
    else {
        return self;
    }
}

- (NSString *)formatNums {
    int intNum = 0;
    if ([self isKindOfClass:[NSNumber class]]) {
        intNum = [self intValue];
    } else if ([self isKindOfClass:[NSString class]]) {
        intNum = [self intValue];
    }
    
    if (intNum < 10000) {
        return self;
    }
    
    float dec = ((float)intNum / 10000);
    return [NSString stringWithFormat:@"%.1f万", dec];
}

- (NSString *)makeDomain {
    if ([self ifUrlContainDomain]) {
        return self;
    }
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *domain = [userDefault objectForKey:@"domain"];
    NSString *urlStr = self;
    if ([DataCheck isValidString:domain]) {
        urlStr = [NSString stringWithFormat:@"%@%@",domain,urlStr];
    } else {
        urlStr = [NSString stringWithFormat:@"%@%@",BASEURL,urlStr];
    }
    return urlStr;
}

- (BOOL)ifUrlContainDomain {
    return  (![self hasPrefix:@"http://"] && ![self hasPrefix:@"https://"]) ? NO : YES;
}

// 计算两个时间字符串 开始时间是否早于结束时间 2016-12-05 00:00
- (BOOL)checkStarttimeAndEndtime:(NSString *)endtime {
    
    // 2016-12-05 00:00
    NSArray *start1 = [self componentsSeparatedByString:@"-"];// @[2016,12,05 00:00]
    NSArray *start2 = [start1[2] componentsSeparatedByString:@" "]; // @[05,00:00]
    NSArray *start3 = [start2[1] componentsSeparatedByString:@":"]; // @[00,00];
    
    NSArray *end1 = [endtime componentsSeparatedByString:@"-"];// @[2016,12,05 00:00]
    NSArray *end2 = [end1[2] componentsSeparatedByString:@" "]; // @[05,00:00]
    NSArray *end3 = [end2[1] componentsSeparatedByString:@":"]; // @[00,00];
    
    if ([start1[0] integerValue] > [end1[0] integerValue]) { // 开始年份大
        return NO;
    } else if ([start1[0] integerValue] == [end1[0] integerValue]) { // 开始年份相等
        
        if ([start1[1] integerValue] > [end1[1] integerValue]) { // 开始月份大
            
            return NO;
            
        } else if ([start1[1] integerValue] == [end1[1] integerValue]) {
            
            if ([start2[0] integerValue] > [end2[0] integerValue]) {
                
                return NO;
                
            } else if ([start2[0] integerValue] == [end2[0] integerValue]) {
                
                if ([start3[0] integerValue] > [end3[0] integerValue]) {
                    
                    return NO;
                    
                } else if ([start3[0] integerValue] == [end3[0] integerValue]) {
                    
                    if ([start3[1] integerValue] >= [end3[1] integerValue]) {
                        
                        return NO;
                    }
                }
            }
        }
    }
    
    return YES;
}

- (NSString *)flattenHTMLTrimWhiteSpace:(BOOL)trim {
    NSString *html = self;
    NSScanner *theScanner = [NSScanner scannerWithString:html];
    NSString *text = nil;
    
    while ([theScanner isAtEnd] == NO) {
        // find start of tag
        [theScanner scanUpToString:@"<" intoString:NULL] ;
        // find end of tag
        [theScanner scanUpToString:@">" intoString:&text] ;
        // replace the found tag with a space
        //(you can filter multi-spaces out later if you wish)
        html = [html stringByReplacingOccurrencesOfString:
                [ NSString stringWithFormat:@"%@>", text]
                                               withString:@""];
    }
    
    return trim ? [html stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] : html;
}

//  标题时间 里面有html ">"  "空格"  等 HTML符号 需要转换
- (NSString *)transformationStr {
    NSString *content = self;
    if ([DataCheck isValidString:content]) {
        content = [content stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@" "];
        content = [content stringByReplacingOccurrencesOfString:@"nbsp;" withString:@" "];
        content = [content stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"];
        content = [content stringByReplacingOccurrencesOfString:@"lt;" withString:@"<"];
        content = [content stringByReplacingOccurrencesOfString:@"&gt;" withString:@">"];
        content = [content stringByReplacingOccurrencesOfString:@"gt;" withString:@">"];
        content = [content stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""];
        content = [content stringByReplacingOccurrencesOfString:@"&copy;" withString:@"©"];
        content = [content stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];
        content = [content stringByReplacingOccurrencesOfString:@"&rsaquo;" withString:@""];
        content = [content stringByReplacingOccurrencesOfString:@"\r\n" withString:@" "] ;
        content = [content stringByReplacingOccurrencesOfString:@"\n" withString:@" "] ;
    }
    return content;
}

- (NSString *)dealSpan {
    NSString *alltimestr;
    NSArray *timeArr = [self componentsSeparatedByString:@"<span title=\""];
    if (timeArr.count >= 2) {
        NSString *havhead = timeArr[1];
        NSArray *arrhead = [havhead componentsSeparatedByString:@"\">"];
        
        if (arrhead.count >= 2) {
            NSString *havtime = arrhead[1];
            NSArray *arrtime = [havtime componentsSeparatedByString:@"</span>"];
            NSString *time = arrtime[0];
            alltimestr = [NSString stringWithFormat:@"%@%@%@",timeArr[0],time,arrtime[1]];
        }
        
    }
    return alltimestr;
}

- (NSString *)dealImg {
    NSString *headstr;
    NSArray *imgArr = [self componentsSeparatedByString:@"<img src=\""];
    if (imgArr.count >= 2) {
        NSString *havhead = imgArr[1];
        NSArray *arrhead = [havhead componentsSeparatedByString:@"/>\""];
        if (arrhead.count > 0) {
            headstr = [NSString stringWithFormat:@"%@%@%@",imgArr[0],arrhead[0],arrhead[1]];
        }
    }
    return headstr;
}

- (NSMutableAttributedString *)getAttributeStr {
    
    NSString *formateStr = [NSString stringWithFormat:@"*%@",self];
    NSRange xRange = {0,1};
    NSMutableAttributedString *attriStr = [[NSMutableAttributedString alloc] initWithString:formateStr];
    [attriStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:xRange];
    return attriStr;
}

- (NSString*)getmd5WithString {
    
    const char* original_str=[self UTF8String];
    
    unsigned char digist[CC_MD5_DIGEST_LENGTH]; //CC_MD5_DIGEST_LENGTH = 16
    
    CC_MD5(original_str, strlen(original_str), digist);
    
    NSMutableString* outPutStr = [NSMutableString stringWithCapacity:10];
    
    for(int  i =0; i<CC_MD5_DIGEST_LENGTH;i++){
        
        [outPutStr appendFormat:@"%02x", digist[i]];// 小写 x 表示输出的是小写 MD5 ，大写 X 表示输出的是大写 MD5
        
    }
    
    return [outPutStr lowercaseString];
}

// 判断域名是否解析
+(BOOL)resolveHost:(NSString*)hostname {
    Boolean result = false;
    
    CFHostRef hostRef;
    
    CFArrayRef addresses;
    
    NSString *ipAddress = nil;
    
    hostRef = CFHostCreateWithName(kCFAllocatorDefault, (__bridge CFStringRef)hostname);
    
    if(hostRef) {
        
        result = CFHostStartInfoResolution(hostRef,kCFHostAddresses,NULL);// pass an error instead of NULL here to find out why it failed
        
        if(result) {
            
            addresses =CFHostGetAddressing(hostRef, &result);
            
        }
        
    }
    
    if(result) {
        
        CFIndex index =0;
        
        CFDataRef ref = (CFDataRef)CFArrayGetValueAtIndex(addresses, index);
        
        int port=0;
        
        struct sockaddr *addressGeneric;
        
        NSData *myData = (__bridge NSData*)ref;
        
        addressGeneric = (struct sockaddr*)[myData bytes];
        
        switch(addressGeneric -> sa_family) {
                
            case AF_INET: {

                struct sockaddr_in *ip4;
                
                char dest[INET_ADDRSTRLEN];
                
                ip4 = (struct sockaddr_in*)[myData bytes];
                
                port = ntohs(ip4->sin_port);
                
                ipAddress = [NSString stringWithFormat:@"%s",inet_ntop(AF_INET, &ip4->sin_addr, dest,sizeof dest)];
                
            }
                
                break;
                
            case AF_INET6: {
                
                struct sockaddr_in6 *ip6;
                
                char dest[INET6_ADDRSTRLEN];
                
                ip6 = (struct sockaddr_in6*)[myData bytes];
                
                port = ntohs(ip6->sin6_port);
                
                ipAddress = [NSString stringWithFormat:@"%s",inet_ntop(AF_INET6, &ip6->sin6_addr, dest,sizeof dest)];
                
            }
                
                break;
                
            default:
                
                ipAddress =nil;
                
                break;
                
        }
        
    }
    
    if(ipAddress) {
        
        return YES;
        
    }else{
        
        return NO;
        
    }
    
}

@end
