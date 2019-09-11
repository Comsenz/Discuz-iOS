//
//  VersionUpdate.m
//  DiscuzMobile
//
//  Created by ZhangJitao on 2018/11/29.
//  Copyright © 2018年 Comsenz. All rights reserved.
//

#import "VersionUpdate.h"

@implementation VersionUpdate

+ (NSString *)timePath {
    NSString *homePath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
    NSString *timePath = [homePath stringByAppendingString:@"/updateTime.plist"];
    return timePath;
}

+ (NSTimeInterval)currentTime {
    NSTimeInterval currentTime = [[NSDate date] timeIntervalSince1970];
    return currentTime;
}

+ (NSTimeInterval)saveTime {
    NSString *timePath = [self timePath];
    NSTimeInterval saveTime = [[NSKeyedUnarchiver unarchiveObjectWithFile:timePath] floatValue];
    return saveTime;
}

+ (void)saveTime:(NSTimeInterval)time {
    NSString *timePath = [self timePath];
    [NSKeyedArchiver archiveRootObject:[NSNumber numberWithFloat:time] toFile:timePath];
}

+ (BOOL)timeDistanceAllow {
    NSTimeInterval saveTime = [self saveTime];
    NSTimeInterval currentTime = [self currentTime];
    NSTimeInterval different = currentTime - saveTime;
    if (saveTime <= 0) {
        return YES;
    }
    else if (different / 86400 >= 1) {
        return YES;
    }
    return NO;
}

+ (void)compareUpdate:(void(^)(NSString *newVersion, NSString *releaseNotes))tipUpdate {
    
    if ([self timeDistanceAllow]) {
        
        NSString *versionUrl = [NSString stringWithFormat:@"https://itunes.apple.com/lookup?id=%@",DZAPPID];
        [JTRequestManager requestWithConfig:^(JTURLRequest *request) {
            request.urlString = versionUrl;
        } success:^(id responseObject, JTLoadType type) {
            NSArray *results = [responseObject objectForKey:@"results"];
            if (results.count < 1) {
                return;
            }
            
            [self saveTime:[self currentTime]];
            
            NSString *localVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
            
            NSDictionary *contentDic = results[0];
            NSString *appStoreVersion = [contentDic objectForKey:@"version"];
            NSString *releaseNotes = [contentDic objectForKey:@"releaseNotes"];
//            NSString *fileName = BBSRULE;
//            NSString *filePath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"txt"];
//            NSString *releaseNotes = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
            
            if ([appStoreVersion compare:localVersion options:NSNumericSearch] == NSOrderedDescending) {
                NSLog(@"更新");
                tipUpdate?tipUpdate(appStoreVersion, releaseNotes):nil;
            };
        } failed:^(NSError *error) {
            
        }];
    }
}

@end
