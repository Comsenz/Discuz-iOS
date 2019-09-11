//
//  BaseTableViewController.m
//  DiscuzMobile
//
//  Created by gensinimac1 on 15/5/5.
//  Copyright (c) 2015年 Cjk. All rights reserved.
//

#import "BaseTableViewController.h"

@implementation BaseTableViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.page = 1;
    [self.view addSubview:self.tableView];
    
    // 点击导航栏到顶部
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(statusBarTappedAction:) name:STATUSBARTAP object:nil];
    // 点击菜单栏刷新
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refresh) name:TABBARREFRESH object:nil];
    // 无图模式
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadImage) name:IMAGEORNOT object:nil];
}

- (void)dealloc {
    DLog(@">>>>>>>>>>>basetableVC销毁了");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSourceArr.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellId = @"CellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellId];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellId];
    }
    return cell;
}
#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}

#pragma mark - public
- (void)emptyShow {
    
    if (self.dataSourceArr.count > 0) {
        [self.tableView.mj_footer setHidden:NO];
        self.emptyView.hidden = YES;
    } else {
        self.emptyView.hidden = NO;
        self.emptyView.frame = self.tableView.frame;
        if (self.tableView.tableHeaderView != nil) {
            CGFloat height = CGRectGetHeight(self.tableView.tableHeaderView.frame);
            if (height > 0) {
                CGRect tempRect = self.tableView.frame;
                self.emptyView.frame = CGRectMake(tempRect.origin.x, tempRect.origin.y + height, CGRectGetWidth(tempRect), CGRectGetHeight(tempRect) - height);
            }
        }
        
        if (!self.emptyView.isOnView) {
            [self.tableView addSubview:self.emptyView];
            self.emptyView.isOnView = YES;
        }
        [self.tableView.mj_footer setHidden:YES];
    }
}

#pragma mark - private
// 刷新
- (void)refresh {
    if ([self.view hu_intersectsWithAnotherView:nil]) {
        [self.tableView.mj_header beginRefreshing];
    }
}

// 点击状态栏到顶部
- (void)statusBarTappedAction:(NSNotification*)notification {
    if ([self.view hu_intersectsWithAnotherView:nil]) {
        [self.tableView setContentOffset:CGPointMake(0, 0) animated:YES];
    }
}
// 有图无图
- (void)reloadImage {
    if (self.cellHeights.count > 0) {
        [self.cellHeights removeAllObjects];
    }
    [self.tableView reloadData];
}

#pragma mark setter getter
- (NSMutableDictionary *)cellHeights {
    if (!_cellHeights) {
        _cellHeights = [NSMutableDictionary dictionary];
    }
    return _cellHeights;
}

- (NSMutableArray *)dataSourceArr {
    if (!_dataSourceArr) {
        _dataSourceArr = [NSMutableArray array];
    }
    return _dataSourceArr;
}

- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        _tableView.tableFooterView = [[UIView alloc] init];
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        if (@available(iOS 11.0, *)) {
            _tableView.estimatedRowHeight = 0;
            _tableView.estimatedSectionFooterHeight = 0;
            _tableView.estimatedSectionHeaderHeight = 0;
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return _tableView;
}

@end
