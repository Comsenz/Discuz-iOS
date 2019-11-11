//
//  CollectionThreadController.m
//  DiscuzMobile
//
//  Created by HB on 17/1/20.
//  Copyright © 2017年 comsenz-service.com.  All rights reserved.
//

#import "CollectionThreadController.h"
#import "CollectionViewCell.h"
#import "ThreadViewController.h"

@interface CollectionThreadController ()

@end

@implementation CollectionThreadController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self downLoadMyFavThread];
    WEAKSELF;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.page = 1;
        [weakSelf.tableView.mj_footer resetNoMoreData];
        [weakSelf downLoadMyFavThread];
    }];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        weakSelf.page ++;
        [weakSelf downLoadMyFavThread];
    }];
    self.tableView.mj_footer.hidden = YES;
    [self.HUD showLoadingMessag:@"正在加载" toView:self.view];
}

// 收藏帖子
-(void)downLoadMyFavThread{
    
    [DZApiRequest requestWithConfig:^(JTURLRequest *request) {
        NSDictionary *getDic = @{@"page":[NSString stringWithFormat:@"%ld",(long)self.page]};
        request.urlString = url_FavoriteThread;
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
        }
        
        
        [self emptyShow];
        [self.tableView reloadData];
        DLog(@"+++++2+++%@",responseObject);
    } failed:^(NSError *error) {
        DLog(@"%@",error);
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

#pragma mark - UITableViewDelegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 75.0;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSourceArr.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * CellId = @"CellIdtow";
    CollectionViewCell * cell = [tableView dequeueReusableCellWithIdentifier:CellId];
    if (cell == nil) {
        cell = [[CollectionViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellId];
    }
    
    
    NSDictionary * dic = [self.dataSourceArr objectAtIndex:indexPath.row];
    if ([DataCheck isValidDictionary:dic]) {
        [cell setData:dic];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ThreadViewController * tvc = [[ThreadViewController alloc] init];
    tvc.tid = [[self.dataSourceArr objectAtIndex:indexPath.row]objectForKey:@"id"];
    [self.navigationController pushViewController:tvc animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
