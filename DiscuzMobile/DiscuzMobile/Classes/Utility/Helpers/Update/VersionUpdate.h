//
//  VersionUpdate.h
//  DiscuzMobile
//
//  Created by ZhangJitao on 2018/11/29.
//  Copyright © 2018年 Comsenz. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface VersionUpdate : NSObject


/**
 比较版本号

 @param tipUpdate 提示更新回调
 */
+ (void)compareUpdate:(void(^)(NSString *newVersion, NSString *releaseNotes))tipUpdate;

@end

NS_ASSUME_NONNULL_END
