//
//  OtherUserPostReplyViewController.m
//  DiscuzMobile
//
//  Created by gensinimac1 on 15/8/24.
//  Copyright (c) 2015年 Cjk. All rights reserved.
//

#import "OtherUserPostReplyViewController.h"
#import "OtherUserPostReplyCell.h"
#import "ThreadViewController.h"
#import "ReplyModel.h"
#import "ReplyCell.h"

@interface OtherUserPostReplyViewController()

@property (nonatomic,assign) NSInteger listcount;
@property (nonatomic,assign) NSInteger tpp;
@property (nonatomic, strong) NSMutableArray *replyArr;

@end


@implementation OtherUserPostReplyViewController


-(void)viewDidLoad{
    
    [super viewDidLoad];
    self.navigationItem.title=@"他的回复";
    
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
    [self.tableView.mj_footer resetNoMoreData];
    self.page = 1;
    [self downLoadData];
}

- (void)addData {
    self.page ++;
    [self downLoadData];
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    return 85.0;
    if (!self.cellHeights[indexPath]) {
        self.cellHeights[indexPath] = @([self heightForRowAtIndexPath:indexPath tableView:tableView]);
    }
    return [self.cellHeights[indexPath] floatValue];
    
}

- (CGFloat)heightForRowAtIndexPath:(NSIndexPath *)indexPath tableView:(UITableView *)tableView {
    
    UITableViewCell * cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    
    return [(ReplyCell *)cell cellHeight];
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
//    return self.dataSourceArr.count;
    return self.replyArr.count;
    
}


-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellId = @"CellId";
    
    ReplyCell *cell = [tableView dequeueReusableCellWithIdentifier:CellId];
    if (cell == nil) {
        cell = [[ReplyCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellId];
    }
    ReplyModel *model = self.replyArr[indexPath.row];
    [cell setInfo:model];
    
    return cell;
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.dataSourceArr.count > 0) {
        ReplyModel *model = self.replyArr[indexPath.row];
        ThreadViewController * tvc = [[ThreadViewController alloc] init];
        tvc.tid = model.tid;
        [self.navigationController pushViewController:tvc animated:YES];
    }
}
- (void)downLoadData {
    
    [DZApiRequest requestWithConfig:^(JTURLRequest *request) {
        NSDictionary *dic = @{@"uid":self.uidstr,@"page":[NSString stringWithFormat:@"%ld",self.page]};
        request.urlString = url_UserPost;
        request.parameters = dic;
    } success:^(id responseObject, JTLoadType type) {
        NSLog(@"userpostreplyVariables=%@",responseObject);
        [self.HUD hideAnimated:YES];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
        if ([DataCheck isValidArray:[[responseObject objectForKey:@"Variables"] objectForKey:@"threadlist"]]) {
            if (self.page == 1) {
                
                [self clearData];
                [self.tableView.mj_header endRefreshing];
                if ([DataCheck isValidArray:[[responseObject objectForKey:@"Variables"] objectForKey:@"threadlist"]]) {
                    self.dataSourceArr = [NSMutableArray arrayWithArray:[[responseObject objectForKey:@"Variables"] objectForKey:@"threadlist" ]];
                    [self analysisData:[[responseObject objectForKey:@"Variables"] objectForKey:@"threadlist" ]];
                }
                [self emptyShow];
            } else {
                
                if ([DataCheck isValidArray:[[responseObject objectForKey:@"Variables"] objectForKey:@"threadlist"]]) {
                    NSArray *arr = [[responseObject objectForKey:@"Variables"] objectForKey:@"threadlist" ];
                    [self.dataSourceArr addObjectsFromArray:arr];
                    [self analysisData:arr];
                }
            }
            
        }
        if ([DataCheck isValidString:[[responseObject objectForKey:@"Variables"] objectForKey:@"tpp"]]) {
            _tpp = [[[responseObject objectForKey:@"Variables"] objectForKey:@"tpp"] integerValue];
        }
        if ([DataCheck isValidString:[[responseObject objectForKey:@"Variables"] objectForKey:@"listcount"]]) {
            _listcount = [[[responseObject objectForKey:@"Variables"] objectForKey:@"listcount"] integerValue];
        }
        
        if (_listcount < _tpp) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        [self emptyShow];
        [self.tableView reloadData];
        
    } failed:^(NSError *error) {
        NSLog(@"%@",error);
        [self emptyShow];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [self showServerError:error];
        [self.HUD hideAnimated:YES];
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
