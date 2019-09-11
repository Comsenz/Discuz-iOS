//
//  PostTypeModel.m
//  DiscuzMobile
//
//  Created by HB on 2017/5/8.
//  Copyright © 2017年 comsenz-service.com.  All rights reserved.
//

#import "PostTypeModel.h"

@implementation PostTypeModel

- (instancetype)initWithTitle:(NSString *)title imageName:(NSString *)imageName type:(PostType)type {
    if (self = [super init]) {
        _title = title;
        _imageName = imageName;
        _type = type;
    }
    return self;
}

+ (instancetype)initWithTitle:(NSString *)title imageName:(NSString *)imageName type:(PostType)type {
    PostTypeModel *postType = [[PostTypeModel alloc] initWithTitle:title imageName:imageName type:type];
    return postType;
}

@end
