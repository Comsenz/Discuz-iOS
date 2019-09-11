//
//  BaseThreadListController.h
//  DiscuzMobile
//
//  Created by ZhangJitao on 2018/7/10.
//  Copyright © 2018年 comsenz-service.com.  All rights reserved.
//

#import "BaseTableViewController.h"

typedef NS_ENUM(NSUInteger, SThreadListType) {
    SThreadListTypeDigest,
    SThreadListTypeNewest,
};

@interface BaseThreadListController : BaseTableViewController
- (SThreadListType)listType;
@end
