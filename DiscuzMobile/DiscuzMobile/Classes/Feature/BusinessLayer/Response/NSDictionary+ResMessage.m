//
//  NSDictionary+ResMessage.m
//  DiscuzMobile
//
//  Created by ZhangJitao on 2019/8/27.
//  Copyright © 2019 comsenz-service.com. All rights reserved.
//

#import "NSDictionary+ResMessage.h"

@implementation NSDictionary (ResMessage)
- (NSString *)messageval {
    NSString *messageval = @"";
    if ([DataCheck isValidDictionary:self] && [DataCheck isValidDictionary:[self objectForKey:@"Message"]]
        && [DataCheck isValidString:[[self objectForKey:@"Message"] objectForKey:@"messageval"]]) {
        messageval = [[self objectForKey:@"Message"] objectForKey:@"messageval"];
    }
    return messageval;
}

- (NSString *)messagestr {
    NSString *messagestr = @"";
    if ([DataCheck isValidDictionary:self] && [DataCheck isValidDictionary:[self objectForKey:@"Message"]]
        && [DataCheck isValidString:[[self objectForKey:@"Message"] objectForKey:@"messagestr"]]) {
        messagestr = [[self objectForKey:@"Message"] objectForKey:@"messagestr"];
    }
    return [messagestr transformationStr];
}
@end
