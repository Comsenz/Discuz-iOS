//
//  JudgeImageModel.m
//  DiscuzMobile
//
//  Created by ZhangJitao on 2018/4/8.
//  Copyright © 2018年 comsenz-service.com.  All rights reserved.
//

#import "JudgeImageModel.h"

NSString * const boolNoImage = @"noimage";

@implementation JudgeImageModel

/**
 无图模式
 @return yes 无图模式  no 有图
 */
+ (BOOL)graphFreeModel {
    return [[NSUserDefaults standardUserDefaults] boolForKey:boolNoImage];
}

@end
