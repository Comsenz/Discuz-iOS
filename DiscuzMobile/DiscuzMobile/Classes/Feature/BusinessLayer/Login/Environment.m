//
//  Environment.m
//  DiscuzMobile
//
//  Created by gensinimac1 on 15/5/7.
//  Copyright (c) 2015年 Cjk. All rights reserved.
//

#import "Environment.h"

@implementation Environment

+ (Environment *)sharedEnvironment
{
    static Environment * sharedEnvironment;
    
    @synchronized(self) {
        if (!sharedEnvironment) {
            sharedEnvironment = [[Environment alloc] init];
        }
        
        return sharedEnvironment;
    }
}

- (void)setValue:(id)value forKey:(NSString *)key {
    [super setValue:value forKey:key];
    if ([key isEqualToString:@"cookiepre"]) {
        _authKey = [value stringByAppendingString:@"auth"];
    }
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}


@end
