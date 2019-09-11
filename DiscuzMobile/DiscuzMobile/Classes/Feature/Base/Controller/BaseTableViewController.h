//
//  BaseTableViewController.h
//  DiscuzMobile
//
//  Created by gensinimac1 on 15/5/5.
//  Copyright (c) 2015年 Cjk. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseTableViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSourceArr;
@property (nonatomic, strong) NSMutableDictionary *cellHeights;

@property (nonatomic, assign) NSInteger page;

/**
 空数据的时候显示 这里要设置dataSourceArr.count = 0的时候
 */
- (void)emptyShow;

@end
