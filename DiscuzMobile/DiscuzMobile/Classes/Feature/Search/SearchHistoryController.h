//
//  SearchHistoryController.h
//  DiscuzMobile
//
//  Created by ZhangJitao on 2018/7/11.
//  Copyright © 2018年 comsenz-service.com.  All rights reserved.
//

#import "BaseTableViewController.h"

@interface SearchHistoryController : BaseTableViewController
@property (nonatomic, copy) void(^SearchClick)(NSString *searchText);
@property (nonatomic, copy) void(^ScrollWillDrag)(void);
- (void)saveSearchHistory:(NSString *)searchText;
@end
