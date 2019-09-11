//
//  AppDelegate.h
//  DiscuzMobile
//
//  Created by HB on 16/7/12.
//  Copyright © 2016年 comsenz-service.com. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "InstroductionView.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate,UIScrollViewDelegate>

@property (strong, nonatomic) UIWindow *window;
+ (AppDelegate *)appDelegate;

@property (nonatomic, assign) BOOL isOpenUrl; // 当首次打开APP和三方登录等情况不用判断cookie的有效性

@end

