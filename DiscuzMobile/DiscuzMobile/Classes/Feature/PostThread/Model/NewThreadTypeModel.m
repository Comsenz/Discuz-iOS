//
//  NewThreadTypeModel.m
//  DiscuzMobile
//
//  Created by HB on 17/1/6.
//  Copyright © 2017年 comsenz-service.com.  All rights reserved.
//

#import "NewThreadTypeModel.h"

@implementation NewThreadTypeModel

- (void)setValue:(id)value forKey:(NSString *)key {
    if ([key isEqualToString:@"typeid"]) {
        _typeId = value;
    }
    [super setValue:value forKey:key];
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}

@end
