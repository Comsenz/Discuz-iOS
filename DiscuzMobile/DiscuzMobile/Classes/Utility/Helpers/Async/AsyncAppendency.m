//
//  AsyncAppendency.m
//  DiscuzMobile
//
//  Created by ZhangJitao on 2017/11/19.
//  Copyright © 2017年 comsenz-service.com.  All rights reserved.
//

#import "AsyncAppendency.h"

dispatch_semaphore_t semaphore;
dispatch_group_t asyGroup;

@implementation AsyncAppendency

+ (instancetype)shareInstance {
    static AsyncAppendency *asyAppend = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        asyAppend = [[AsyncAppendency alloc] init];
        semaphore = dispatch_semaphore_create(0);
        asyGroup = dispatch_group_create();
    });
    return asyAppend;
}


/**
 等待异步操作执行完毕之后执行semaphore方式
 
 @param count 异步事件数量
 @param dependency 执行异步事件回调
 @param complete 异步事件全部处理完成后回调
 */
- (void)asyncDependencySemaphoreWithNumber:(NSInteger)count dependency:(void(^)(void))dependency complete:(void(^)(void))complete {
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    
    dispatch_group_async(group, mainQueue, ^{
        if (dependency) {
            dependency();
        }
    });
    
//    dispatch_semaphore_signal(semaphore);  全部信号量发送完毕后，形象dispatch_semaphore_wait后面的方法
    
    dispatch_group_notify(group, globalQueue, ^{
        
        for (int i = 0; i < count; i ++) {
            dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            complete();
        });
    });
}


/**
 等待异步操作执行完毕之后执行group方式

 @param count 异步事件数量
 @param dependency 执行异步事件回调
 @param complete 异步事件全部处理完成后回调
 */
- (void)asyDependencyGroupWithNumber:(NSInteger)count depend:(void(^)(void))dependency complete:(void(^)(void))complete {
    
    if (dependency) {
        for (int i = 0; i < count; i ++) {
            dispatch_group_enter(asyGroup);
        }
        dependency();
    }
    
//    dispatch_group_leave(group); 全部leave完之后执行notify
    dispatch_group_notify(asyGroup, dispatch_get_main_queue(), ^{
        complete();
    });
}

@end

