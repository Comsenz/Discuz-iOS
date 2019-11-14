//
//  DZMobileCtrl.m
//  DiscuzMobile
//
//  Created by WebersonGao on 2019/11/12.
//  Copyright © 2019 comsenz-service.com. All rights reserved.
//

#import "DZMobileCtrl.h"

@implementation DZMobileCtrl

static DZMobileCtrl *instance = nil;

+(instancetype)sharedCtrl{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}


-(void)setTababar:(UITabBarController *)Tababar mainNavi:(UINavigationController *)mainNavi{
    if ([Tababar isKindOfClass:[DZRootTabBarController class]]) {
        _rootTababar = (DZRootTabBarController *)Tababar;
    }
    
    if ([mainNavi isKindOfClass:[DZBaseNavigationController class]]) {
        _mainNavi = (DZBaseNavigationController *)mainNavi;
    }
}



@end
