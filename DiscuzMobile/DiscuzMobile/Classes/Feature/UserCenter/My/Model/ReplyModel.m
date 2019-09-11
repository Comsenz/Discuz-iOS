//
//  ReplyModel.m
//  DiscuzMobile
//
//  Created by HB on 2017/6/12.
//  Copyright © 2017年 comsenz-service.com.  All rights reserved.
//

#import "ReplyModel.h"

@implementation ReplyModel

- (void)setValue:(id)value forKey:(NSString *)key {
    if ([key isEqualToString:@"position"]) {
        self.positions = value;
    } else {
        [super setValue:value forKey:key];
    }
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}

@end
