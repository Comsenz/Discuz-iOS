//
//  JudgeImageModel.h
//  DiscuzMobile
//
//  Created by ZhangJitao on 2018/4/8.
//  Copyright © 2018年 comsenz-service.com.  All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const boolNoImage;

@interface JudgeImageModel : NSObject
/**
 无图模式
 @return yes 无图模式  no 有图
 */
+ (BOOL)graphFreeModel;
@end
