//
//  SendEmailHelper.h
//  DiscuzMobile
//
//  Created by ZhangJitao on 2018/4/8.
//  Copyright © 2018年 comsenz-service.com.  All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SendEmailHelper : NSObject

@property (nonatomic, weak) UINavigationController *navigationController;
+ (instancetype)shareInstance;
- (void)prepareSendEmail;
@end
