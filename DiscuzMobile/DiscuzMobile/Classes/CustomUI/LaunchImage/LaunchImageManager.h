//
//  LaunchImageManager.h
//  DiscuzMobile
//
//  Created by HB on 17/3/28.
//  Copyright © 2017年 comsenz-service.com.  All rights reserved.
//

#import <Foundation/Foundation.h>
@class TTLaunchImageView;

@interface LaunchImageManager : NSObject

@property (nonatomic, strong) TTLaunchImageView *launchImageView;

+ (instancetype)shareInstance;

- (void)setLaunchView;

@end
