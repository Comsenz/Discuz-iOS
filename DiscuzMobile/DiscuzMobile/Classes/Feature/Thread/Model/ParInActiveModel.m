//
//  ParInActiveModel.m
//  DiscuzMobile
//
//  Created by HB on 2017/8/4.
//  Copyright © 2017年 comsenz-service.com.  All rights reserved.
//

#import "ParInActiveModel.h"

@implementation ParInActiveModel

- (void)setValue:(id)value forKey:(NSString *)key {
    [super setValue:value forKey:key];
    if ([key isEqualToString:@"choices"]) {
        if ([DataCheck isValidString:value]) {
            _choicesArray = [value componentsSeparatedByString:@"\n"];
        }
        
    }
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}

@end
