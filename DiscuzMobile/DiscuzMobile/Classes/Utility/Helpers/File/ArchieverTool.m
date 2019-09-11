//
//  ArchieverTool.m
//  Travel
//
//  Created by Zhangjitao on 15/11/8.
//  Copyright © 2015年 comsenz-service.com. All rights reserved.
//

#import "ArchieverTool.h"

@implementation ArchieverTool

// 归档方法
+ (NSData *)Archiever:(id)object forKey:(NSString *)key {
    
    NSMutableData *data = [NSMutableData data];
    
    NSKeyedArchiver *anrchiever = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    
    [anrchiever encodeObject:object forKey:key];
    
    [anrchiever finishEncoding];
    
    return data;
    
}

// 反归档方法
+ (id)UnArchiever:(NSData *)data forKey:(NSString *)key {
    
    NSKeyedUnarchiver *unArchiever = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    id object = [unArchiever decodeObjectForKey:key];
    [unArchiever finishDecoding];
    return object;
    
}

@end
