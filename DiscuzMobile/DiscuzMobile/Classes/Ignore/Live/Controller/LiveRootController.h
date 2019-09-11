//
//  LiveRootController.h
//  DiscuzMobile
//
//  Created by HB on 2017/5/10.
//  Copyright © 2017年 comsenz-service.com.  All rights reserved.
//

#import "BaseViewController.h"
@class HotLivelistModel;

@interface LiveRootController : BaseViewController

@property (nonatomic, strong) NSString *authorid;
@property (nonatomic, strong) HotLivelistModel *listModel;

@end
