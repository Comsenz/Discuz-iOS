//
//  LiveInteractionViewController.m
//  DiscuzMobile
//
//  Created by HB on 2017/8/28.
//  Copyright © 2017年 comsenz-service.com.  All rights reserved.
//

#import "LiveInteractionViewController.h"
#import "LiveViewerCell.h"
#import "LiveDetailModel.h"
#import "HotLivelistModel.h"


NSString * const LiveInteractionCellReuseIdentifier = @"LiveInteractionCellReuseIdentifier";

@interface LiveInteractionViewController ()

@end

@implementation LiveInteractionViewController {
    BOOL _useStaticRowHeight;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self loadData];
    
    WEAKSELF;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf refreshData];
    }];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [weakSelf addData];
    }];
    
    
    if (_useStaticRowHeight) {
        // use a static row height
        self.tableView.rowHeight = 60;
    } else {
        // establish a cache for prepared cells because heightForRow... and cellForRow... both need the same cell for an index path
        cellCache = [[NSCache alloc] init];
    }
    
    // on iOS 6 we can register the attributed cells for the identifier
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= 60000
    [self.tableView registerClass:[LiveViewerCell class] forCellReuseIdentifier:LiveInteractionCellReuseIdentifier];
#endif

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTable) name:@"reloadTable" object:nil];
}

- (void)reloadTable {
    [self.tableView reloadData];
}

- (void)refreshData {
    self.page = 1;
    [self.tableView.mj_footer resetNoMoreData];
    [self loadData];
}

- (void)addData {
    self.page ++;
    [self loadData];
    
}

- (void)loadData {
    
    if (self.listModel.tid == nil) {
        return;
    }
    
    if (self.page == 1) {
        [self.HUD showLoadingMessag:@"正在加载" toView:self.view];
    }
    
    [DZApiRequest requestWithConfig:^(JTURLRequest *request) {
//        request.urlString = url_LiveReply;
        request.parameters = @{@"tid":self.listModel.tid,
                               @"page":[NSString stringWithFormat:@"%ld",(long)self.page],
                               @"authorid":self.listModel.authorid};
    } success:^(id responseObject, JTLoadType type) {
        DLog(@"%@",responseObject);
        
        [self mj_endRefresh];
        
        NSMutableArray *arrIndexPath = [NSMutableArray array];
        
        if ([DataCheck isValidArray:[[responseObject objectForKey:@"Variables"] objectForKey:@"list"]]) {
            
            if (self.page == 1) {
                [self.dataSourceArr removeAllObjects];
                [self.cellHeights removeAllObjects];
            }
            
            NSArray *newList = [[responseObject objectForKey:@"Variables"] objectForKey:@"list"];
            
            for (NSDictionary *listItem in newList) {
                LiveDetailModel *liveModel = [[LiveDetailModel alloc] init];
                [liveModel setValuesForKeysWithDictionary:listItem];
                
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.dataSourceArr.count inSection:0];
                [arrIndexPath addObject:indexPath];
                
                [self.dataSourceArr addObject:liveModel];
            }
            
        } else {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        [UIView animateWithDuration:0 animations:^{
            [self.tableView reloadData];
            
        } completion:^(BOOL finished) {
            [self.HUD hideAnimated:YES];
        }];
        
    } failed:^(NSError *error) {
        {
            [self mj_endRefresh];
            [self.HUD hideAnimated:YES];
            [self showServerError:error];
        }
    }];
}

- (void)mj_endRefresh {
    if (self.page == 1) {
        [self.tableView.mj_header endRefreshing];
    } else {
        [self.tableView.mj_footer endRefreshing];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSourceArr.count;
}

- (void)configureCell:(LiveViewerCell *)cell forIndexPath:(NSIndexPath *)indexPath {
    if (self.dataSourceArr.count > 0) {
        LiveDetailModel *model = self.dataSourceArr[indexPath.row];
        [cell setInfo:model];
    }
    
//    cell.attributedTextContextView.shouldDrawImages = YES;
}

- (BOOL)_canReuseCells {
    // reuse does not work for variable height
    if ([self respondsToSelector:@selector(tableView:heightForRowAtIndexPath:)]) {
        return NO;
    }
    // only reuse cells with fixed height
    return YES;
}

- (LiveViewerCell *)tableView:(UITableView *)tableView preparedCellForIndexPath:(NSIndexPath *)indexPath {
    // workaround for iOS 5 bug
    NSString *key = [NSString stringWithFormat:@"%ld-%ld", (long)indexPath.section, (long)indexPath.row];
    
    LiveViewerCell *cell = [cellCache objectForKey:key];
    
    if (!cell) {
        if ([self _canReuseCells]) {
            cell = (LiveViewerCell *)[tableView dequeueReusableCellWithIdentifier:LiveInteractionCellReuseIdentifier];
        }
        if (!cell) {
            cell = [[LiveViewerCell alloc] initWithReuseIdentifier:LiveInteractionCellReuseIdentifier];
        }
        
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.hasFixedRowHeight = _useStaticRowHeight;
        // cache it, if there is a cache
        [cellCache setObject:cell forKey:key];
    }
    
    [self configureCell:cell forIndexPath:indexPath];
    
    return cell;
}

// disable this method to get static height = better performance
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_useStaticRowHeight) {
        return tableView.rowHeight;
    }
    
    LiveViewerCell *cell = (LiveViewerCell *)[self tableView:tableView preparedCellForIndexPath:indexPath];
    
    return [cell requiredRowHeightInTableView:tableView];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LiveViewerCell *cell = (LiveViewerCell *)[self tableView:tableView preparedCellForIndexPath:indexPath];
    return cell;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (self.hideKeyboard) {
        self.hideKeyboard();
    }
}


@end
