//
//  DZMobileCtrl.h
//  DiscuzMobile
//
//  Created by WebersonGao on 2019/11/12.
//  Copyright © 2019 comsenz-service.com. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "DZRootTabBarController.h"
#import "DZBaseNavigationController.h"

@interface DZMobileCtrl : NSObject

+(instancetype)sharedCtrl;

@property(nonatomic,strong,readonly) DZRootTabBarController *rootTababar;

@property(nonatomic,strong,readonly) DZBaseNavigationController *mainNavi;

/// 设置tabbar 和 mainNavi
-(void)setTababar:(UITabBarController *)Tababar mainNavi:(UINavigationController *)mainNavi;



@end


