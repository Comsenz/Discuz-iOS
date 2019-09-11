//
//  AsyncAppendency.h
//  DiscuzMobile
//
//  Created by ZhangJitao on 2017/11/19.
//  Copyright © 2017年 comsenz-service.com.  All rights reserved.
//

#import <Foundation/Foundation.h>

extern dispatch_semaphore_t semaphore;
extern dispatch_group_t asyGroup;

@interface AsyncAppendency : NSObject

+ (instancetype)shareInstance;

/**
 等待异步操作执行完毕之后执行semaphore方式
 
 @param count 异步事件数量
 @param dependency 执行异步事件回调
 @param complete 异步事件全部处理完成后回调
 */
- (void)asyncDependencySemaphoreWithNumber:(NSInteger)count dependency:(void(^)(void))dependency complete:(void(^)(void))complete;

/**
 等待异步操作执行完毕之后执行group方式
 
 @param count 异步事件数量
 @param dependency 执行异步事件回调
 @param complete 异步事件全部处理完成后回调
 */
- (void)asyDependencyGroupWithNumber:(NSInteger)count depend:(void(^)(void))dependency complete:(void(^)(void))complete;

@end
