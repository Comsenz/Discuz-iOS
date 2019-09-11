//
//  MyFriendViewController.m
//  DiscuzMobile
//
//  Created by gensinimac1 on 15/5/5.
//  Copyright (c) 2015年 Cjk. All rights reserved.
//

#import "MyFriendViewController.h"
#import "SendMessageViewController.h"
#import "OtherUserController.h"
#import "ChatDetailController.h"
#import "FriendCell.h"

@implementation MyFriendViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self downLoadData];
    self.title = @"我的好友";
    WEAKSELF;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.page = 1;
        [weakSelf refreshData];
    }];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        weakSelf.page ++;
        [weakSelf refreshData];
    }];
    self.tableView.mj_footer.hidden = YES;
    [self.HUD showLoadingMessag:@"正在加载" toView:self.view];
}

- (void)refreshData {
    [self downLoadData];
}


#pragma mark - tableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSourceArr.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellId = @"FriendId";
    FriendCell *cell = [tableView dequeueReusableCellWithIdentifier:CellId];
    if (cell == nil) {
        cell = [[FriendCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellId];
    }
    
    NSDictionary *dic;
    if ([DataCheck isValidArray:self.dataSourceArr]) {
        dic = [self.dataSourceArr objectAtIndex:indexPath.row];
    }
    [cell.headV sd_setImageWithURL:[NSURL URLWithString:[dic objectForKey:@"avatar"]] placeholderImage:[UIImage imageNamed:@"noavatar_small"] options:SDWebImageRetryFailed];
    cell.nameLab.text = [dic objectForKey:@"username"];
    cell.sendBtn.tag = indexPath.row;
    [cell.sendBtn addTarget:self action:@selector(sendMessageBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

- (void)sendMessageBtnClick:(UIButton *)btn {
    NSDictionary *dic;
    if ([DataCheck isValidArray:self.dataSourceArr]) {
        dic = [self.dataSourceArr objectAtIndex:btn.tag];
    }
    
    ChatDetailController *mvc = [[ChatDetailController alloc] init];
    mvc.touid = [dic objectForKey:@"uid"];
    mvc.nametitle = [dic objectForKey:@"username"];
    mvc.username = [dic objectForKey:@"username"];
    
    [self.navigationController pushViewController:mvc animated:YES];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *dic;
    if ([DataCheck isValidArray:self.dataSourceArr]) {
        dic = [self.dataSourceArr objectAtIndex:indexPath.row];
    }
    OtherUserController * ovc = [[OtherUserController alloc] init];
    ovc.authorid = [dic objectForKey:@"uid"];
    [self showViewController:ovc sender:nil];
    
}

- (void)downLoadData {
    [DZApiRequest requestWithConfig:^(JTURLRequest *request) {
        NSDictionary *getDic = @{@"page":[NSString stringWithFormat:@"%ld",(long)self.page]};
        request.urlString = url_FriendList;
        request.parameters = getDic;
    } success:^(id responseObject, JTLoadType type) {
        [self.HUD hideAnimated:YES];
        
        [self mj_endRefreshing];
        
        if ([DataCheck isValidArray:[[responseObject objectForKey:@"Variables"] objectForKey:@"list"]]) {
            
            if (self.page == 1) {
                self.dataSourceArr = [NSMutableArray arrayWithArray:[[responseObject objectForKey:@"Variables"] objectForKey:@"list"]];
            } else {
                [self.dataSourceArr addObjectsFromArray:[[responseObject objectForKey:@"Variables"] objectForKey:@"list"]];
            }
            
        }
        
        
        if ([DataCheck isValidString:[[responseObject objectForKey:@"Variables"] objectForKey:@"count"]]) {
            NSInteger count = [[[responseObject objectForKey:@"Variables"] objectForKey:@"count"] integerValue];
            if (self.dataSourceArr.count >= count) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
            self.title = [NSString stringWithFormat:@"我的好友（%ld）",count];
        }
        
        [self emptyShow];
        
        [self.tableView reloadData];
    } failed:^(NSError *error) {
        [self showServerError:error];
        [self.HUD hideAnimated:YES];
        [self emptyShow];
        [self mj_endRefreshing];
    }];
    
}

- (void)mj_endRefreshing {
    if (self.page == 1) {
        [self.tableView.mj_header endRefreshing];
    } else {
        [self.tableView.mj_footer endRefreshing];
    }
}

@end

