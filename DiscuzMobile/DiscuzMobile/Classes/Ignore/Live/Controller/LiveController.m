//
//  LiveController.m
//  DiscuzMobile
//
//  Created by HB on 2017/5/4.
//  Copyright © 2017年 comsenz-service.com.  All rights reserved.
//

#import "LiveController.h"
#import "LiveRootController.h"

#import "LiveCell.h"
#import "HotliveCell.h"
#import "LiveHeaderCell.h"

#import "ThreadListModel.h"
#import "HotLivelistModel.h"

#import "AsyncAppendency.h"


@interface LiveController ()

@property (nonatomic, strong) NSMutableArray *todayRecommendArr;

@end

@implementation LiveController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initTableView];
    // 读取缓存
    [self initRequest:JTRequestTypeCache];
    
}

-(void)initTableView {
    self.tableView.backgroundColor = [UIColor whiteColor];
    WEAKSELF;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf initRequest:JTRequestTypeRefresh];
    }];
}

// 创建group semaphore等待两个请求都完成之后才执行刷新tableview和空页面显示
- (void)initRequest:(JTLoadType)type {
    
    [[AsyncAppendency shareInstance] asyDependencyGroupWithNumber:2 depend:^{
        
        [self requestWithLoadType:type];
        
        if (type == JTRequestTypeCache) {
            [self.HUD showLoadingMessag:@"正在加载" toView:self.view];
//            if ([DZApiRequest isCache:url_LiveHot andParameters:nil]) {
//                [self initRequest:JTRequestTypeRefresh];
//            }
        }
    } complete:^{
        [self.HUD hideAnimated:YES];
        [self.tableView reloadData];
        [self emptyShow];
        
    }];
}

- (void)requestWithLoadType:(JTLoadType)type {
    [self downTodayRecommand:type];
    [self downLoadData:type];
}

// 热门直播
-(void)downLoadData:(JTLoadType)type {
    [DZApiRequest requestWithConfig:^(JTURLRequest *request) {
//        request.urlString = url_LiveHot;
        request.isCache = YES;
        request.loadType = type;
    } success:^(id responseObject, JTLoadType type) {
        
        self.dataSourceArr = [NSMutableArray arrayWithArray:[HotLivelistModel setHotLiveData:responseObject]];
        dispatch_group_leave(asyGroup);
        
    } failed:^(NSError *error) {
        [self showServerError:error];
        dispatch_group_leave(asyGroup);
        
    }];
}

- (void)downTodayRecommand:(JTLoadType)type {
    [DZApiRequest requestWithConfig:^(JTURLRequest *request) {
//        request.urlString = url_LiveToday;
        request.isCache = YES;
        request.loadType = type;
    } success:^(id responseObject, JTLoadType type) {
        
        self.todayRecommendArr = [NSMutableArray array];
        [[HotLivelistModel setRecommonLiveData:responseObject] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (idx <= 2) {
                [self.todayRecommendArr addObject:obj];
                //                [self.todayRecommendArr addObject:obj];
                //                [self.todayRecommendArr addObject:obj];
                
            }
        }];
        
        dispatch_group_leave(asyGroup);
    } failed:^(NSError *error) {
        [self showServerError:error];
        dispatch_group_leave(asyGroup);
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    if (self.dataSourceArr.count > 0 && self.todayRecommendArr.count > 0) {
        return 2;
    }
    else if (self.dataSourceArr.count > 0 || self.todayRecommendArr.count > 0) {
        return 1;
    }
    else {
        return 0;
    }
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    static NSString * headerSection = @"LiveHeader";
    LiveHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:headerSection];
    if (cell == nil) {
        cell = [[LiveHeaderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:headerSection];
    }
    if (self.dataSourceArr.count > 0 && self.todayRecommendArr.count > 0) {
        if (section == 0) {
            cell.titleLab.text = @"今日推荐";
        } else {
            cell.titleLab.text = @"热门直播";
        }
    } else if (self.dataSourceArr.count > 0) {
        cell.titleLab.text = @"热门直播";
    } else if (self.todayRecommendArr.count > 0) {
        cell.titleLab.text = @"今日推荐";
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//    return 41.5;
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.dataSourceArr.count > 0 && self.todayRecommendArr.count > 0) {
        if (indexPath.section == 0) {
            if (self.todayRecommendArr.count == 1) {
                return WIDTH * 9 / 20 + 5;
            }
            return WIDTH * 9 / 22 + 5;
            
        } else {
            return 100;
        }
    } else if (self.dataSourceArr.count > 0) {
        return 100;
    } else if (self.todayRecommendArr.count > 0) {
        if (self.todayRecommendArr.count == 1) {
            return WIDTH * 9 / 20 + 5;
        }
        return WIDTH * 9 / 22 + 5;
    } else {
        return 100;
    }
    
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    
    if (self.dataSourceArr.count > 0 && self.todayRecommendArr.count > 0) {
        if (section == 0) {
            return 1;
        }
        return self.dataSourceArr.count;
    } else if (self.dataSourceArr.count > 0) {
        return self.dataSourceArr.count;
    }
    return 1;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.dataSourceArr.count > 0 && self.todayRecommendArr.count > 0) {
        
        if (indexPath.section == 0) {
            
            return [self liveCell:self.todayRecommendArr];
            
        } else {
            
            HotLivelistModel *model = self.dataSourceArr[indexPath.row];
            return [self hotliveCell:model];
        }
    } else if (self.dataSourceArr.count > 0) {
        
        HotLivelistModel *model = self.dataSourceArr[indexPath.row];
        return [self hotliveCell:model];
        
    } else {
        
        return [self liveCell:self.todayRecommendArr];
    }
    
}

static NSString *hotReuseId = @"hotLive";
- (HotliveCell *)hotliveCell:(HotLivelistModel *)model {
    
    HotliveCell *cell = [self.tableView dequeueReusableCellWithIdentifier:hotReuseId];
    if (cell == nil) {
        cell = [[HotliveCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:hotReuseId];
    }
    [cell setInfo:model];
    
    return cell;
}

static NSString *reuseId = @"Recomment";
- (LiveCell *)liveCell:(NSMutableArray *)todayRecommendArr {
    
    LiveCell *cell = [self.tableView dequeueReusableCellWithIdentifier:reuseId];
    if (cell == nil) {
        cell = [[LiveCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseId];
    }
    if (todayRecommendArr.count > 0) {
        [cell setImageArr:todayRecommendArr];
        
        cell.clickRecommentBlock = ^(NSInteger index) {
            LiveRootController *liveRoot = [[LiveRootController alloc] init];
            HotLivelistModel *model = self.todayRecommendArr[index];
            liveRoot.listModel = model;
            [self showViewController:liveRoot sender:nil];
        };
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.dataSourceArr.count > 0 && self.todayRecommendArr.count > 0) {
        if (indexPath.section == 1) {
            
            if (self.dataSourceArr.count > 0) {
                HotLivelistModel *model = self.dataSourceArr[indexPath.row];
                LiveRootController *liveRoot = [[LiveRootController alloc] init];
                liveRoot.listModel = model;
                [self showViewController:liveRoot sender:nil];
            }
            
        }
    } else if (self.dataSourceArr.count > 0) {
        HotLivelistModel *model = self.dataSourceArr[indexPath.row];
        LiveRootController *liveRoot = [[LiveRootController alloc] init];
        liveRoot.listModel = model;
        [self showViewController:liveRoot sender:nil];
    }
}

- (NSMutableArray *)todayRecommendArr {
    if (!_todayRecommendArr) {
        _todayRecommendArr = [NSMutableArray array];
    }
    return _todayRecommendArr;
}


@end
