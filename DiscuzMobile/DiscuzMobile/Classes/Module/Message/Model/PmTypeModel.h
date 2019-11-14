//
//  PmTypeModel.h
//  DiscuzMobile
//
//  Created by HB on 2017/7/17.
//  Copyright © 2017年 comsenz-service.com.  All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PmTypeModel : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *module;
@property (nonatomic, strong) NSString *filter;
@property (nonatomic, strong) NSString *view;
@property (nonatomic, strong) NSString *type;

- (instancetype)initWithTitle:(NSString *)title andModule:(NSString *)module anFilter:(NSString *)filter andView:(NSString *)view andType:(NSString *)type;

+ (instancetype)initWithTitle:(NSString *)title andModule:(NSString *)module anFilter:(NSString *)filter andView:(NSString *)view andType:(NSString *)type;

@end
