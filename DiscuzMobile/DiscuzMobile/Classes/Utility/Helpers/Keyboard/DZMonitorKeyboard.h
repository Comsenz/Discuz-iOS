//
//  DZMonitorKeyboard.h
//  DiscuzMobile
//
//  Created by ZhangJitao on 2019/7/19.
//  Copyright © 2019 comsenz-service.com.  All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DZMonitorKeyboard : NSObject
@property (nonatomic, assign) BOOL showKeyboard;
+ (instancetype)shareInstance;
@end

NS_ASSUME_NONNULL_END
