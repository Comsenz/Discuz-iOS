//
//  CollectionForumController.m
//  DiscuzMobile
//
//  Created by HB on 17/1/20.
//  Copyright © 2017年 comsenz-service.com.  All rights reserved.
//

#import "CollectionForumController.h"
#import "UIAlertController+Extension.h"

#import "CollectionForumCell.h"
#import "LianMixAllViewController.h"
#import "CollectionTool.h"

@interface CollectionForumController ()

@end

@implementation CollectionForumController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self.HUD showLoadingMessag:@"正在加载" toView:self.view];
    [self downLoadFavForumData];
    
    WEAKSELF;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf.tableView.mj_footer resetNoMoreData];
        weakSelf.page = 1;
        [weakSelf downLoadFavForumData];
    }];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        weakSelf.page ++;
        [weakSelf downLoadFavForumData];
    }];
    self.tableView.mj_footer.hidden = YES;
}

-(void)downLoadFavForumData {
    
    [DZApiRequest requestWithConfig:^(JTURLRequest *request) {
        NSDictionary *getDic = @{@"page":[NSString stringWithFormat:@"%ld",(long)self.page]};
        request.urlString = url_FavoriteForum;
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
    } failed:^(NSError *error) {
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
    
    return 60.0;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
     return self.dataSourceArr.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * CollectForum = @"CollectForum";
    CollectionForumCell *forumCell = [tableView dequeueReusableCellWithIdentifier:CollectForum];
    if (forumCell == nil) {
        forumCell = [[CollectionForumCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CollectForum];
    }
    forumCell.cancelBtn.tag = indexPath.row;
    [forumCell.cancelBtn addTarget:self action:@selector(collectionAction:) forControlEvents:UIControlEventTouchUpInside];
    NSDictionary *dic = [self.dataSourceArr objectAtIndex:indexPath.row];
    forumCell.textLab.text = [dic objectForKey:@"title"];
    
    if ([[dic objectForKey:@"todayposts"] integerValue] > 0) {
        [forumCell.iconV sd_setImageWithURL:[NSURL URLWithString:[dic objectForKey:@"icon"]] placeholderImage:[UIImage imageNamed:@"forumNew_l"] options:SDWebImageRetryFailed];
    } else {
        [forumCell.iconV sd_setImageWithURL:[NSURL URLWithString:[dic objectForKey:@"icon"]] placeholderImage:[UIImage imageNamed:@"forumCommon_l"] options:SDWebImageRetryFailed];
    }
    
    return forumCell;
}

- (void)collectionAction:(UIButton *)sender {
    
    [UIAlertController alertTitle:@"提示" message:@"确定删除此版块收藏？" controller:self doneText:@"确定" cancelText:@"取消" doneHandle:^{
        [self deleteCollection:sender.tag];
    } cancelHandle:nil];
}

- (void)deleteCollection:(NSInteger)index {
    
    NSString *fid = [[self.dataSourceArr objectAtIndex:index] objectForKey:@"id"];
    
    NSDictionary *getDic = @{@"id":fid,
                             @"type":@"forum"
                             };
    NSDictionary *postDic = @{@"deletesubmit":@"true",
                              @"formhash":[Environment sharedEnvironment].formhash
                              };
    [[CollectionTool shareInstance] deleCollection:getDic andPostdic:postDic success:^{
        [self.dataSourceArr removeObjectAtIndex:index];
        [[NSNotificationCenter defaultCenter] postNotificationName:COLLECTIONFORUMREFRESH object:nil];
        [self.tableView reloadData];
    } failure:nil];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    LianMixAllViewController * ftvc = [[LianMixAllViewController alloc]init];
    ftvc.forumFid = [[self.dataSourceArr objectAtIndex:indexPath.row]objectForKey:@"id"];

    [self.navigationController pushViewController:ftvc animated:YES];
    
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
