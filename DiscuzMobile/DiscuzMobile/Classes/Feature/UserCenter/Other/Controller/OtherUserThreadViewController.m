//
//  OtherUserThreadViewController.m
//  DiscuzMobile
//
//  Created by gensinimac1 on 15/8/24.
//  Copyright (c) 2015年 Cjk. All rights reserved.
//

#import "OtherUserThreadViewController.h"
#import "OtherUserThearCell.h"
#import "ThreadViewController.h"

@interface OtherUserThreadViewController()

@property (nonatomic,assign) NSInteger listcount;
@property (nonatomic,assign) NSInteger tpp;

@end


@implementation OtherUserThreadViewController

-(void)viewDidLoad{

    [super viewDidLoad];
    self.navigationItem.title=@"他的主题";
    
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
    
    return 85.0;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataSourceArr.count;
    
}


-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    static NSString *CellId = @"CellId";
    OtherUserThearCell *cell = [tableView dequeueReusableCellWithIdentifier:CellId];
    if (cell == nil) {
        cell = [[OtherUserThearCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellId];
    }
    NSDictionary *dic = [self.dataSourceArr objectAtIndex:indexPath.row];
    if ([DataCheck isValidDictionary:dic]) {
        [cell setData:dic];
    }
    
    return cell;
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.dataSourceArr.count > 0) {
        NSString * tid = [[self.dataSourceArr objectAtIndex:indexPath.row] objectForKey:@"tid"];
        ThreadViewController * tvc = [[ThreadViewController alloc] init];
        tvc.tid = tid;
        [self.navigationController pushViewController:tvc animated:YES];
    }
}

- (void)downLoadData {
    
    [DZApiRequest requestWithConfig:^(JTURLRequest *request) {
        NSDictionary *dic = @{@"uid":self.uidstr,@"page":[NSString stringWithFormat:@"%ld",self.page]};
        request.urlString = url_OtherThread;
        request.parameters = dic;
    } success:^(id responseObject, JTLoadType type) {
        
        NSLog(@"userthreadVariables=%@",responseObject);
        
        [self.HUD hideAnimated:YES];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
        if ([DataCheck isValidArray:[[responseObject objectForKey:@"Variables"] objectForKey:@"threadlist"]]) {
            if (self.page == 1) {
                
                self.dataSourceArr = [NSMutableArray arrayWithArray:[[responseObject objectForKey:@"Variables"] objectForKey:@"threadlist"]];
            } else {
                
                NSArray *arr = [[responseObject objectForKey:@"Variables"] objectForKey:@"threadlist" ];
                [self.dataSourceArr addObjectsFromArray:arr];
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
        [self emptyShow];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [self showServerError:error];
        [self.HUD hideAnimated:YES];
    }];
}
@end
