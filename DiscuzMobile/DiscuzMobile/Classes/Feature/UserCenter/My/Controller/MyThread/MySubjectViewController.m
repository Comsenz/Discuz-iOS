//
//  MyTopicViewController.m
//  DiscuzMobile
//
//  Created by gensinimac1 on 15/5/5.
//  Copyright (c) 2015年 Cjk. All rights reserved.
//

#import "MySubjectViewController.h"
#import "SubjectCell.h"
#import "ThreadViewController.h"

@interface MySubjectViewController ()

@end

@implementation MySubjectViewController

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
    self.navigationItem.title = @"我的主题";

    [self downLoadData];
    WEAKSELF;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf reloadData];
    }];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [weakSelf addData];
    }];
    self.tableView.mj_footer.hidden = YES;
    [self.HUD showLoadingMessag:@"正在加载" toView:self.view];
}

- (void)reloadData {
    self.page = 1;
    [self.tableView.mj_footer resetNoMoreData];
    [self downLoadData];
}

- (void)addData {
    self.page ++;
    [self downLoadData];
}

#pragma mark - tableView delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 75.0;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSourceArr.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellId = @"CellId";
    SubjectCell *cell = [tableView dequeueReusableCellWithIdentifier:CellId];
    if (cell == nil) {
        cell = [[SubjectCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellId];
    }
    NSDictionary * dic = [self.dataSourceArr objectAtIndex:indexPath.row];
    if ([DataCheck isValidDictionary:dic]) {
       [cell setData:dic];
    }
    
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString * tid = [[self.dataSourceArr objectAtIndex:indexPath.row] objectForKey:@"tid"];
    ThreadViewController * tvc = [[ThreadViewController alloc] init];
    tvc.tid = tid;
    [self.navigationController pushViewController:tvc animated:YES];
}

-(void)downLoadData {
    [DZApiRequest requestWithConfig:^(JTURLRequest *request) {
        NSDictionary *dic = @{
                              @"page":[NSString stringWithFormat:@"%ld",self.page],
                              @"type":@"thread"
                              };
        request.urlString = url_Mythread;
        request.methodType = JTMethodTypeGET;
        request.parameters = dic;
    } success:^(id responseObject, JTLoadType type) {
        [self.HUD hide];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
        if ([DataCheck isValidArray:[[responseObject objectForKey:@"Variables"] objectForKey:@"data"]]) {
            
            if (self.page == 1) {
                self.dataSourceArr = [NSMutableArray arrayWithArray:[[responseObject objectForKey:@"Variables"] objectForKey:@"data" ]];
                if (self.dataSourceArr.count < [[[responseObject objectForKey:@"Variables"] objectForKey:@"perpage" ] integerValue]) {
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                }
                
            } else {
                NSArray *arr = [[responseObject objectForKey:@"Variables"] objectForKey:@"data" ];
                [self.dataSourceArr addObjectsFromArray:arr];
                
                if (arr.count < [[[responseObject objectForKey:@"Variables"] objectForKey:@"perpage" ] integerValue]) {
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                }
            }
            
        }
        [self emptyShow];
        [self.tableView reloadData];
        
    } failed:^(NSError *error) {
        [self showServerError:error];
        [self emptyShow];
        [self.HUD hide];;
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}

@end
