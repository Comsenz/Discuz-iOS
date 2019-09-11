//
//  FootmarkController.m
//  DiscuzMobile
//
//  Created by HB on 2017/5/4.
//  Copyright © 2017年 comsenz-service.com.  All rights reserved.
//

#import "FootmarkController.h"

#import "ThreadListModel.h"
#import "HomeListCell.h"
#import "ThreadViewController.h"
#import "LoginController.h"
#import "OtherUserController.h"

@interface FootmarkController ()

@property (nonatomic, assign) NSInteger count;
@property (nonatomic, assign) NSInteger perPage;

@end

@implementation FootmarkController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.page = 1;
    self.perPage = 10;
    self.count = [[DatabaseHandle defaultDataHelper] countForFootUid:[Environment sharedEnvironment].member_uid];
    
    [self.HUD showLoadingMessag:@"正在加载" toView:self.view];
    [self refreshFoot];
    
    WEAKSELF;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf refreshFoot];
    }];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [weakSelf addFoot];
    }];
    self.tableView.mj_footer.hidden = YES;
    
}

- (void)refreshFoot {
    self.page = 1;
    WEAKSELF;
    BACK(^{
        weakSelf.dataSourceArr = [NSMutableArray arrayWithArray:[[DatabaseHandle defaultDataHelper] searchFootWithUid:[Environment sharedEnvironment].member_uid andPage:weakSelf.page andPerpage:weakSelf.perPage]];
        MAIN(^{
            if (weakSelf.dataSourceArr.count >= weakSelf.count) {
                [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
            } else {
                [weakSelf.tableView.mj_footer resetNoMoreData];
            }
            [weakSelf.tableView.mj_header endRefreshing];
            [weakSelf emptyShow];
            [weakSelf.HUD hideAnimated:YES];
            [weakSelf.tableView reloadData];
        });
    });
}

- (void)addFoot {
    
    WEAKSELF;
    BACK(^{
        weakSelf.page ++;
        [weakSelf.dataSourceArr addObjectsFromArray:[[DatabaseHandle defaultDataHelper] searchFootWithUid:[Environment sharedEnvironment].member_uid andPage:weakSelf.page andPerpage:weakSelf.perPage]];
        MAIN(^{
            if (weakSelf.dataSourceArr.count >= weakSelf.count) {
                [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
            } else {
                [weakSelf.tableView.mj_footer endRefreshing];
            }
            
            [weakSelf.HUD hideAnimated:YES];
            [weakSelf.tableView reloadData];
        });
    });
}

#pragma mark - tableView delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell * cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    return [(HomeListCell *)cell cellHeight];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSourceArr.count;
    
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static  NSString  * CellIdentiferId = @"HomeCellCellID";
    HomeListCell  * cell = [tableView dequeueReusableCellWithIdentifier:CellIdentiferId];
    if (cell == nil) {
        cell = [[HomeListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentiferId];
        
    }
    
    ThreadListModel *model = [self.dataSourceArr objectAtIndex:indexPath.row];
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toOtherCenter:)];
    cell.headV.tag = [model.authorid integerValue];
    [cell.headV addGestureRecognizer:tapGes];
    cell.info = model;
    return cell;
}

- (void)toOtherCenter:(UITapGestureRecognizer *)sender {
    
    if (![self isLogin]) {
        return;
    }
    NSInteger tag = sender.view.tag;
    NSString *authorId = [NSString stringWithFormat:@"%ld",tag];
    OtherUserController * ovc = [[OtherUserController alloc] init];
    ovc.authorid = authorId;
    [self.navigationController pushViewController:ovc animated:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ThreadListModel *model = self.dataSourceArr[indexPath.row];
    ThreadViewController * tvc = [[ThreadViewController alloc] init];
    tvc.tid = model.tid;
    [self.navigationController pushViewController:tvc animated:YES];
}

@end
