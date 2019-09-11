//
//  PmTypeModel.m
//  DiscuzMobile
//
//  Created by HB on 2017/7/17.
//  Copyright © 2017年 comsenz-service.com.  All rights reserved.
//

#import "PmTypeModel.h"

@implementation PmTypeModel

- (instancetype)initWithTitle:(NSString *)title andModule:(NSString *)module anFilter:(NSString *)filter andView:(NSString *)view andType:(NSString *)type {
    if (self = [super init]) {
        _title = title;
        _module = module;
        _filter = filter;
        _view = view;
        _type = type;
    }
    return self;
}

+ (instancetype)initWithTitle:(NSString *)title andModule:(NSString *)module anFilter:(NSString *)filter andView:(NSString *)view andType:(NSString *)type {
    PmTypeModel *model = [[PmTypeModel alloc] initWithTitle:title andModule:module anFilter:filter andView:view andType:type];
    return model;
}

@end
