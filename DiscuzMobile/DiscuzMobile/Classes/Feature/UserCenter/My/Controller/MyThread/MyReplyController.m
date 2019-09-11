//
//  MyReplyController.m
//  DiscuzMobile
//
//  Created by HB on 2017/6/12.
//  Copyright © 2017年 comsenz-service.com.  All rights reserved.
//

#import "MyReplyController.h"
#import "OtherUserPostReplyCell.h"
#import "ThreadViewController.h"
#import "ReplyCell.h"
#import "SubjectCell.h"

#import "ReplyModel.h"

@interface MyReplyController ()

@property (nonatomic, assign) NSInteger listcount;
@property (nonatomic, assign) NSInteger tpp;
@property (nonatomic, strong) NSMutableArray *replyArr;

@end

@implementation MyReplyController

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
    self.navigationItem.title = @"我的回复";
    
    _listcount = 0;
    _tpp = 0;
    
    [self downLoadData];
    WEAKSELF;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf refreshData];
    }];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [weakSelf addData];
    }];
    self.tableView.mj_footer.hidden = YES;
    [self.HUD showLoadingMessag:@"正在加载" toView:self.view];
}

- (void)refreshData {
    self.page = 1;
    [self.tableView.mj_footer resetNoMoreData];
    [self downLoadData];
}

- (void)addData {
    self.page ++;
    [self downLoadData];
}

#pragma mark - tableView delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString * tid = [[self.dataSourceArr objectAtIndex:indexPath.row] objectForKey:@"tid"];
    ThreadViewController * tvc = [[ThreadViewController alloc] init];
    tvc.tid = tid;
    [self.navigationController pushViewController:tvc animated:YES];
}

- (void)downLoadData {
    [DZApiRequest requestWithConfig:^(JTURLRequest *request) {
        NSDictionary *dic = @{@"type":@"reply",
                              @"page":[NSString stringWithFormat:@"%ld",self.page]};
        request.urlString = url_Mythread;
        request.parameters = dic;
    } success:^(id responseObject, JTLoadType type) {
        [self.tableView.mj_header endRefreshing];
        [self.HUD hide];
        NSArray *data = [[responseObject objectForKey:@"Variables"] objectForKey:@"data"];
        NSInteger perpage = [[[responseObject objectForKey:@"Variables"] objectForKey:@"perpage"] integerValue];
        if ([DataCheck isValidArray:data]) {
            if (self.page == 1) {
                self.dataSourceArr = data.mutableCopy;
            } else {
                [self.dataSourceArr addObjectsFromArray:data];
            }
            if (data.count < perpage) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
        }
        
        [self emptyShow];
        [self.tableView reloadData];
        
    } failed:^(NSError *error) {
        [self emptyShow];
        [self showServerError:error];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [self.HUD hide];
    }];
    
}

- (void)analysisData:(NSArray *)dataArr {
    
    for (NSDictionary *dic in dataArr) {
        
        if ([DataCheck isValidArray:[dic objectForKey:@"reply"]]) {
            
            NSArray *arr = [dic objectForKey:@"reply"];
            
            for (NSDictionary *replyDic in arr) {
                
                ReplyModel *reply = [[ReplyModel alloc] init];
                [reply setValuesForKeysWithDictionary:replyDic];
                reply.auther = [dic objectForKey:@"auther"];
                reply.subject = [dic objectForKey:@"subject"];
                [self.replyArr addObject:reply];
            }
        }
    }
}

- (void)clearData {
    if (self.dataSourceArr.count > 0) {
        [self.dataSourceArr removeAllObjects];
    }
    if (self.replyArr.count > 0) {
        [self.replyArr removeAllObjects];
    }
    self.cellHeights = [NSMutableDictionary dictionary];
}

- (NSMutableArray *)replyArr {
    if (!_replyArr) {
        _replyArr = [NSMutableArray array];
    }
    return _replyArr;
}

@end
