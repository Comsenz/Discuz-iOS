//
//  BaseThreadListController.m
//  DiscuzMobile
//
//  Created by ZhangJitao on 2018/7/10.
//  Copyright © 2018年 comsenz-service.com.  All rights reserved.
//

#import "BaseThreadListController.h"
#import "LoginController.h"
#import "OtherUserController.h"
#import "ThreadViewController.h"
#import "BaseStyleCell.h"
#import "DiscoverModel.h"
#import "ThreadListCell.h"
#import "ThreadListModel+Forumdisplay.h"

@interface BaseThreadListController ()
@property (nonatomic, assign) BOOL isRequest;
@property (nonatomic, strong) NSString *urlString;
@end

@implementation BaseThreadListController

- (SThreadListType)listType {
    return 0;
}

#pragma mark - lifeCyle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initTableView];
    
    if (self.listType == SThreadListTypeDigest) {
        self.urlString = url_DigestAll;
    } else if (self.listType == SThreadListTypeNewest) {
        self.urlString = url_newAll;
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(firstRequest:)
                                                 name:JTCONTAINERQUEST
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refreshData)
                                                 name:DOMAINCHANGE
                                               object:nil];
    
    [self cacheRequest];
}

- (void)initTableView {
    
    [self.tableView registerClass:[ThreadListCell class] forCellReuseIdentifier:[ThreadListCell getReuseId]];
    WEAKSELF;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf refreshData];
        if ([weakSelf.view hu_intersectsWithAnotherView:nil]) {
        }
    }];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        self.page ++;
        [self downLoadData:self.page andLoadType:JTRequestTypeRefresh];
    }];
    self.tableView.mj_footer.hidden = YES;
    ((MJRefreshAutoFooter *)self.tableView.mj_footer).triggerAutomaticallyRefreshPercent = -10;
}

#pragma mark - Request

- (void)firstRequest:(NSNotification *)notification {
    if (![self.view hu_intersectsWithAnotherView:nil]) {
        return;
    }

    NSDictionary *userInfo = notification.userInfo;
    if ([DataCheck isValidDictionary:userInfo]) {
        NSInteger index = [[userInfo objectForKey:@"selectIndex"] integerValue];
        if (!self.isRequest && index != 0) {
            self.isRequest = YES;
            [self cacheRequest];
        }
    }
}

- (void)cacheRequest {
    [self.HUD showLoadingMessag:@"正在加载" toView:self.view];
    [self downLoadData:self.page andLoadType:JTRequestTypeCache];
    if ([DZApiRequest isCache:self.urlString andParameters:@{@"page":[NSString stringWithFormat:@"%ld",(long)self.page]}]) {
        [self downLoadData:self.page andLoadType:JTRequestTypeRefresh];
    }
    
}

- (void)refreshData {
    self.page =1;
    [self.tableView.mj_footer resetNoMoreData];
    [self downLoadData:self.page andLoadType:JTRequestTypeRefresh];
}

#pragma mark - 数据下载
- (void)downLoadData:(NSInteger)page andLoadType:(JTLoadType)type {
    
    [DZApiRequest requestWithConfig:^(JTURLRequest *request) {
        request.urlString = self.urlString;
        request.isCache = YES;
        request.loadType = type;
        request.parameters = @{@"page":[NSString stringWithFormat:@"%ld",(long)page]};
        
    } success:^(id responseObject, JTLoadType type) {
        [self.HUD hide];
        [self.tableView.mj_header endRefreshing];
        
        DiscoverModel *discover = [DiscoverModel mj_objectWithKeyValues:[responseObject objectForKey:@"Variables"]];
        
        if (self.page == 1) { // 刷新列表 刷新的时候移除数据源
            [self clearDatasource];
        } else {
            [self.tableView.mj_footer endRefreshing];
        }
        
        if ([DataCheck isValidArray:discover.data]) {
            [self.dataSourceArr addObjectsFromArray:discover.data];
        } else {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        
        [self emptyShow];
        [self.tableView reloadData];
        
    } failed:^(NSError *error) {
        [self.HUD hide];
        [self emptyShow];
        [self showServerError:error];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
    }];
}

- (void)clearDatasource {
    if (self.cellHeights.count > 0) {
        [self.cellHeights removeAllObjects];
    }
    if (self.dataSourceArr.count > 0) {
        [self.dataSourceArr removeAllObjects];
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSourceArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ThreadListModel *listModel = self.dataSourceArr[indexPath.row];
    ThreadListCell * cell = [self.tableView dequeueReusableCellWithIdentifier:[ThreadListCell getReuseId]];
    cell.info = [listModel dealSpecialThread];
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toOtherCenter:)];
    cell.headV.tag = [listModel.authorid integerValue];
    [cell.headV addGestureRecognizer:tapGes];
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (!self.cellHeights[indexPath]) {
        self.cellHeights[indexPath] = @([self heightForRowAtIndexPath:indexPath tableView:tableView]);
    }
    return [self.cellHeights[indexPath] floatValue];
}

- (CGFloat)heightForRowAtIndexPath:(NSIndexPath *)indexPath tableView:(UITableView *)tableView {
    ThreadListCell *cell = [tableView dequeueReusableCellWithIdentifier:[ThreadListCell getReuseId]];
    ThreadListModel *listModel = self.dataSourceArr[indexPath.row];
    return [cell caculateCellHeight:listModel];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ThreadListModel *listModel = self.dataSourceArr[indexPath.row];
    [self pushThreadDetail:listModel];
}

#pragma mark - Action
- (void)pushThreadDetail:(ThreadListModel *)listModel {
    ThreadViewController * tvc = [[ThreadViewController alloc] init];
    tvc.tid = listModel.tid;
    [self.navigationController pushViewController:tvc animated:YES];
}

- (void)toOtherCenter:(UITapGestureRecognizer *)sender {
    
    if (![self isLogin]) {
        return;
    }
    NSInteger tag = sender.view.tag;
    NSString *authorId = [NSString stringWithFormat:@"%ld",(long)tag];
    OtherUserController * ovc = [[OtherUserController alloc] init];
    ovc.authorid = authorId;
    [self.navigationController pushViewController:ovc animated:YES];
}

@end
