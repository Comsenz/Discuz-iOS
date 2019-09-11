//
//  BoundInfoModel.m
//  DiscuzMobile
//
//  Created by HB on 2017/7/13.
//  Copyright © 2017年 comsenz-service.com.  All rights reserved.
//

#import "BoundInfoModel.h"

@implementation BoundInfoModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
}

- (void)setValue:(id)value forKey:(NSString *)key {
    
    if ([key isEqualToString:@"type"]) {
        if ([DataCheck isValidString:value] && [value isEqualToString:@"qq"]) {
            _icon = @"bound_qq";
            _name = @"QQ";
        } else {
            _icon = @"bound_wx";
            if ([value isEqualToString:@"minapp"]) {
                _name = @"小程序";
            } else {
                _name = @"微信";
            }
        }
    }
    [super setValue:value forKey:key];
}

@end
