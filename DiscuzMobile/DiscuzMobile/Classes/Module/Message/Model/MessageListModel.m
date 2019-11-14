//
//  MessageListModel.m
//  DiscuzMobile
//
//  Created by HB on 2017/5/9.
//  Copyright © 2017年 comsenz-service.com.  All rights reserved.
//

#import "MessageListModel.h"

@implementation MessageListModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.notevar = [NSMutableDictionary dictionary];
    }
    return self;
}

-(void)setValue:(id)value forKey:(NSString *)key {
    if ([key isEqualToString:@"id"]) {
        _msgid = value;
    } else if ([key isEqualToString:@"new"]) {
        _mnew = value;
    }
//    else if ([key isEqualToString:@"note"]) {
//        _note = [[NSString new] flattenHTML:[NSString stringWithFormat:@"%@",value] trimWhiteSpace:NO];
//    }
    else if ([key isEqualToString:@"message"]) {
        _message = [value transformationStr];
    }
    else {
        [super setValue:value forKey:key];
    }
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}

@end
