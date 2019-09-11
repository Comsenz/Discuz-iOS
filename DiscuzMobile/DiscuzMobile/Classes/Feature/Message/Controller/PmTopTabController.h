//
//  PmTopTabController.h
//  DiscuzMobile
//
//  Created by HB on 2017/7/17.
//  Copyright © 2017年 comsenz-service.com.  All rights reserved.
//

#import "BaseViewController.h"

typedef NS_ENUM(NSUInteger, PMTYPE) {
    pm_mypm = 0,
    pm_mythread,
    pm_interactive,
};

@interface PmTopTabController : BaseViewController

@property (nonatomic, assign) PMTYPE pmType;

@end
