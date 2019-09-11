//
//  TextIconModel.m
//  DiscuzMobile
//
//  Created by HB on 17/1/19.
//  Copyright © 2017年 comsenz-service.com.  All rights reserved.
//

#import "TextIconModel.h"

@implementation TextIconModel

- (NSString *)description {
    return [NSString stringWithFormat:@"text==> %@,iconName==> %@,detail==> %@",_text,_iconName,_detail];
}

- (instancetype)initWithText:(NSString *)text andIconName:(NSString *)iconName andDetail:(NSString *)detail {
    if (self = [super init]) {
        self.text = text;
        self.iconName = iconName;
        self.detail = detail;
    }
    return self;
}

+ (instancetype)initWithText:(NSString *)text andIconName:(NSString *)iconName andDetail:(NSString *)detail {
    TextIconModel *model = [[TextIconModel alloc] initWithText:text andIconName:iconName andDetail:detail];
    return model;
}

@end
