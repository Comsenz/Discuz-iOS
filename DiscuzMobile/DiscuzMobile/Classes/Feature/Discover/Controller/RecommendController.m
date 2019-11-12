//
//  RecommendController.m
//  DiscuzMobile
//
//  Created by HB on 2017/5/4.
//  Copyright © 2017年 comsenz-service.com.  All rights reserved.
//

#import "RecommendController.h"
#import "DZSlideShowScrollView.h"
#import "DZHomeBannerModel.h"
#import "RecommendModel.h"
#import "BaseStyleCell.h"
#import "AsyncAppendency.h"

@interface RecommendController ()

@property (nonatomic, strong) DZSlideShowScrollView *scrollView;

@end

@implementation RecommendController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initTableView];
    
    [self initRequest:JTRequestTypeCache];
}

-(void)initTableView {
    _scrollView = [[DZSlideShowScrollView alloc] init];
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
    [self downLoadHomeBanner:type];
    [self downLoadRecommendData:type];
}

// 下载banner
- (void)downLoadHomeBanner:(JTLoadType)type {
    
    [DZApiRequest requestWithConfig:^(JTURLRequest *request) {
        request.urlString = url_RecommendBanner;
        request.isCache = YES;
        request.loadType = type;
    } success:^(id responseObject, JTLoadType type) {
        
        self.scrollView.bannerArray = [NSMutableArray arrayWithArray:[DZHomeBannerModel setBannerData:responseObject]];
        [self setBanner];
        dispatch_group_leave(asyGroup);
    } failed:^(NSError *error) {
        dispatch_group_leave(asyGroup);
    }];
}

// 下载推荐
-(void)downLoadRecommendData:(JTLoadType)type {
    
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
        self.scrollView.frame =  CGRectMake(0, 0, KScreenWidth, 0);
        [self.scrollView.pageControl removeFromSuperview];
        return;
        
    } else {
        
        self.scrollView.frame = CGRectMake(0, 0, KScreenWidth, KScreenWidth * 9 / 20 + 6);
    }
    self.tableView.tableHeaderView = self.scrollView;
    [self.scrollView setAddsPicture];
    WEAKSELF;
    [self.scrollView touchInSlideShow:^(NSInteger currentPage) {
        if ([DataCheck isValidString:weakSelf.scrollView.bannerArray[currentPage].link]) {
            DZHomeBannerModel *banner = weakSelf.scrollView.bannerArray[currentPage];
            if ([banner.link_type isEqualToString:@"1"]) {
                [[DZMobileCtrl sharedCtrl] PushToDetailController:banner.link];
                return;
            } else if ([banner.link_type isEqualToString:@"2"]) {
                    [[DZMobileCtrl sharedCtrl] PushToForumlistController:banner.link];
                return;
            }
            [[DZMobileCtrl sharedCtrl] PushToWebViewController:banner.link];
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
    [[DZMobileCtrl sharedCtrl] PushToDetailController:model.tid];
}

- (void)toOtherCenter:(UITapGestureRecognizer *)sender {

    if (![self isLogin]) {
        return;
    }
    [[DZMobileCtrl sharedCtrl] PushToOtherUserController:checkInteger(sender.view.tag)];
}

@end
