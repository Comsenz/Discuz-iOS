//
//  LiveDetailModel.m
//  DiscuzMobile
//
//  Created by HB on 2017/5/17.
//  Copyright © 2017年 comsenz-service.com.  All rights reserved.
//

#import "LiveDetailModel.h"

@implementation LiveDetailModel


- (instancetype)init {
    if (self = [super init]) {
        _imglist = [NSMutableArray array];
        _thumlist = [NSMutableArray array];
    }
    return self;
}

- (void)setValue:(id)value forKey:(NSString *)key {
    [super setValue:value forKey:key];
    if ([key isEqualToString:@"time"]) {
        _dateline = [[NSString stringWithFormat:@"%@",value] flattenHTMLTrimWhiteSpace:YES];
    }
    if ([key isEqualToString:@"message"]) {
        NSString *me = value;
        NSString *new = nil;
        if ([me hasSuffix:@"<br />\r\n"]) {
            new = [me substringToIndex:me.length - 9];
        } else if ([me hasSuffix:@"\n"]) {
            new = [me substringToIndex:me.length - 2];
        } else {
            new = me;
        }
        
        new = [new stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        
        _message = new;
    }
    if ([key isEqualToString:@"dbdateline"]) {
        _dbdateline = [NSString stringWithFormat:@"%@",value];
    }
    if ([key isEqualToString:@"imagelists"]) {
        if ([DataCheck isValidArray:value]) {
            self.imglist = value;
//            if (self.imglist.count > 0) {
//                self.imglist = [[self.imglist reverseObjectEnumerator] allObjects].mutableCopy;
//            }
        }
    }
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%@==>%@",_dateline,_message];
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}
@end
