//
//  ApplyActiver.m
//  DiscuzMobile
//
//  Created by HB on 2017/7/28.
//  Copyright © 2017年 comsenz-service.com.  All rights reserved.
//

#import "ApplyActiver.h"

@implementation ApplyActiver

- (void)setValue:(id)value forKey:(NSString *)key {
    
    if ([key isEqualToString:@"dateline"]) {
        _dateline = [value transformationStr];
    }
    else if ([key isEqualToString:@"dbufielddata"]) {
        if ([DataCheck isValidDictionary:value]) {
            _dbufielddata = value;
        } else {
            _dbufielddata = [NSMutableDictionary dictionary];
        }
    } else {
        [super setValue:value forKey:key];
    }
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
}

@end
