//
//  RecommendController.m
//  DiscuzMobile
//
//  Created by HB on 2017/5/4.
//  Copyright © 2017年 comsenz-service.com.  All rights reserved.
//

#import "RecommendController.h"
#import "SlideShowScrollView.h"
#import "TTUrlController.h"
#import "OtherUserController.h"
#import "ThreadViewController.h"
#import "LianMixAllViewController.h"

#import "JTBannerModel.h"
#import "RecommendModel.h"

#import "BaseStyleCell.h"

#import "AsyncAppendency.h"

@interface RecommendController ()

@property (nonatomic, strong) SlideShowScrollView *scrollView;

@end

@implementation RecommendController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initTableView];
    
    [self initRequest:JTRequestTypeCache];
}

-(void)initTableView {
    _scrollView = [[SlideShowScrollView alloc] init];
    WEAKSELF;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf initRequest:JTRequestTypeRefresh];
    }];
}

#pragma mark - request
- (void)initRequest:(JTLoadType)type {
    
    [[AsyncAppendency shareInstance] asyDependencyGroupWithNumber:2 depend:^{
        
        [self requestWithLoadType:type];
        if (type == JTRequestTypeCache) {
            [self.HUD showLoadingMessag:@"正在加载" toView:self.view];
            if ([DZApiRequest isCache:url_RecommendList andParameters:nil]) {// 有cache才请求，让他去刷新, 没有cache，上面那个方法会自动请求
                [self initRequest:JTRequestTypeRefresh];
            }
        }
    } complete:^{
        [self.tableView reloadData];
        [self emptyShow];
        [self.HUD hideAnimated:YES];
        
    }];
}

// 根据请求方式请求
- (void)requestWithLoadType:(JTLoadType)type {
    [self downLoadBanner:type];
    [self downLoadData:type];
}

// 下载banner
- (void)downLoadBanner:(JTLoadType)type {
    
    [DZApiRequest requestWithConfig:^(JTURLRequest *request) {
        request.urlString = url_RecommendBanner;
        request.isCache = YES;
        request.loadType = type;
    } success:^(id responseObject, JTLoadType type) {
        
        self.scrollView.bannerArray = [NSMutableArray arrayWithArray:[JTBannerModel setBannerData:responseObject]];
        [self setBanner];
        dispatch_group_leave(asyGroup);
    } failed:^(NSError *error) {
        dispatch_group_leave(asyGroup);
    }];
}

// 下载推荐
-(void)downLoadData:(JTLoadType)type {
    
    [DZApiRequest requestWithConfig:^(JTURLRequest *request) {
        request.urlString = url_RecommendList;
        request.isCache = YES;
        request.loadType = type;
    } success:^(id responseObject, JTLoadType type) {
        DLog(@"%@",responseObject);
        
        self.dataSourceArr = [NSMutableArray arrayWithArray:[RecommendModel setRecommendData:responseObject]];
        dispatch_group_leave(asyGroup);
    } failed:^(NSError *error) {
        
        [self showServerError:error];
        dispatch_group_leave(asyGroup);
    }];
}

- (void)setBanner {
    
    if (self.scrollView.bannerArray.count == 0) {
        for (UIView *v  in self.scrollView.subviews) {
            [v removeFromSuperview];
        }
        self.scrollView.frame =  CGRectMake(0, 0, WIDTH, 0);
        [self.scrollView.pageControl removeFromSuperview];
        return;
        
    } else {
        
        self.scrollView.frame = CGRectMake(0, 0, WIDTH, WIDTH * 9 / 20 + 6);
    }
    self.tableView.tableHeaderView = self.scrollView;
    [self.scrollView setAddsPicture];
    WEAKSELF;
    [self.scrollView touchInSlideShow:^(NSInteger currentPage) {
        if ([DataCheck isValidString:weakSelf.scrollView.bannerArray[currentPage].link]) {
            JTBannerModel *banner = weakSelf.scrollView.bannerArray[currentPage];
            if ([banner.link_type isEqualToString:@"1"]) {
                [weakSelf pushToDetail:banner.link];
                return;
            } else if ([banner.link_type isEqualToString:@"2"]) {
                [weakSelf pushToForumlist:banner.link];
                return;
            }
            [weakSelf pushToWebView:banner.link];
        }
    }];
    
}

#pragma mark - tableView delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    UITableViewCell * cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    return [(BaseStyleCell *)cell cellHeight];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSourceArr.count;
    
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    static  NSString  * CellIdentiferId = @"HomeCellCellID";
    BaseStyleCell  * cell = [tableView dequeueReusableCellWithIdentifier:CellIdentiferId];
    if (cell == nil) {
        cell = [[BaseStyleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentiferId];
        
    }
    
    ThreadListModel *model = [self.dataSourceArr objectAtIndex:indexPath.row];
    cell.info = model;
    
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toOtherCenter:)];
    cell.headV.tag = [model.authorid integerValue];
    [cell.headV addGestureRecognizer:tapGes];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ThreadListModel *model = self.dataSourceArr[indexPath.row];
    [self pushToDetail:model.tid];
}

#pragma mark - jump controller
- (void)pushToDetail:(NSString *)tid {
    ThreadViewController * tvc = [[ThreadViewController alloc] init];
    tvc.tid = tid;
    [self.navigationController pushViewController:tvc animated:YES];
}

- (void)pushToForumlist:(NSString *)fid {
    LianMixAllViewController *flVc = [[LianMixAllViewController alloc] init];
    flVc.forumFid = fid;
    [self.navigationController pushViewController:flVc animated:YES];
}

- (void)pushToWebView:(NSString *)link {
    TTUrlController *urlCt = [[TTUrlController alloc] init];
    urlCt.hidesBottomBarWhenPushed = YES;
    urlCt.urlString = link;
    [self.navigationController pushViewController:urlCt animated:YES];
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

@end
