//
//  DZHomeController.m
//  DiscuzMobile
//
//  Created by HB on 17/1/13.
//  Copyright © 2017年 comsenz-service.com.  All rights reserved.
//

#import "DZHomeController.h"
#import "DZSettingController.h"
#import "RNCachingURLProtocol.h"
#import "DZForumThreadController.h"
#import "ForumCell.h"
#import "LoginModule.h"
#import "DZHomeListCell.h"
#import "ThreadListModel.h"
#import "DZForumInfoModel.h"
#import "TTSearchController.h"
#import "DZHomeBannerModel.h"
#import "DZBaseUrlController.h"
#import "DZSlideShowScrollView.h"
#import "LianMixAllViewController.h"

#import "RootForumCell.h"

@interface DZHomeController ()

@property (nonatomic, strong) NSMutableArray *offenSource;
@property (nonatomic, strong) NSMutableArray *hotSource;
@property (nonatomic, strong) DZSlideShowScrollView *scrollView;

@end


@implementation DZHomeController

- (void)leftBarBtnClick {
    if (![self isLogin]) {
        return;
    }
}

- (void)rightBarBtnClick {
    TTSearchController *searchVC = [[TTSearchController alloc] init];
    searchVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:searchVC animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self commitInit];
    [self initRequest];
}


- (void)commitInit {
    [self setNavc];
    [self initTableView];
    [self setBanner];
}

#pragma mark - 设置导航栏
//设置 nav
-(void)setNavc{
    [self createBarBtn:@"bar_message" type:NavItemImage Direction:NavDirectionLeft];
    [self createBarBtn:@"bar_search" type:NavItemImage Direction:NavDirectionRight];
    self.navigationItem.title = DZ_APPNAME;
}

-(void)initTableView{
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self.tableView.mj_header endRefreshing];
        [self initRequest];
    }];
}

- (void)setBanner {
    
    if (self.scrollView.bannerArray.count == 0) {
        self.scrollView.frame =  CGRectMake(0, 0, KScreenWidth, 0);
        [self.scrollView.pageControl removeFromSuperview];
        return;
    } else {
        self.scrollView.frame = CGRectMake(0, 0, KScreenWidth, KScreenWidth * 9 / 20 + 6);
    }
    self.tableView.tableHeaderView = self.scrollView;
//    self.scrollView.isPlaceholder = YES;
    [self.scrollView setAddsPicture];
    
    WEAKSELF;
    [self.scrollView touchInSlideShow:^(NSInteger currentPage) {
        if ([DataCheck isValidString:weakSelf.scrollView.bannerArray[currentPage].link]) {
            DZBaseUrlController *urlCt = [[DZBaseUrlController alloc] init];
            urlCt.hidesBottomBarWhenPushed = YES;
            urlCt.urlString = weakSelf.scrollView.bannerArray[currentPage].link;
            [weakSelf.navigationController pushViewController:urlCt animated:YES];
        }
    }];
    
}

- (void)initRequest {
    // 热帖
    [self downLoadHotThreadData];
    [self downLoadForumHomeBanner];
    
    if ([LoginModule isLogged]) { // 收藏版块
        [self downLoadFavForumData];
    } else { // 热门版块
        [self downLoadDataWtihForumType:@"hotforum"];
    }
}

- (void)downLoadForumHomeBanner {
    
    [DZApiRequest requestWithConfig:^(JTURLRequest *request) {
        request.urlString = url_RecommendBanner;
    } success:^(id responseObject, JTLoadType type) {
        NSArray *list = [[responseObject objectForKey:@"Variables"] objectForKey:@"list"];
        if ([DataCheck isValidArray:list]) {
            if (self.scrollView.bannerArray.count > 0) {
                self.scrollView.bannerArray = [NSMutableArray array];
                for (UIView *v  in self.scrollView.subviews) {
                    [v removeFromSuperview];
                }
            }
            for (NSDictionary *dic in list) {
                DZHomeBannerModel *banner = [[DZHomeBannerModel alloc] init];
                [banner setValuesForKeysWithDictionary:dic];
                [self.scrollView.bannerArray addObject:banner];
            }
            
            [self setBanner];
        }
    } failed:^(NSError *error) {
        [self showServerError:error];
    }];
}

//  下载热门版块 hotforum（常去的版块）-- 未登录时候
-(void)downLoadDataWtihForumType:(NSString *)forumType {
    
    [DZApiRequest requestWithConfig:^(JTURLRequest *request) {
        request.urlString = url_Hotforum;
    } success:^(id responseObject, JTLoadType type) {
        DLog(@"_hotForumListArray1=%@",responseObject);
        if ([forumType isEqualToString:@"hotforum"]){
            [self setHotData:[[responseObject objectForKey:@"Variables"]objectForKey:@"data" ]];
        }
        [self.tableView reloadData];
        DLog(@"下载成功");
    } failed:^(NSError *error) {
        [self showServerError:error];
        DLog(@"%@",error);
    }];
}

// 下载收藏版块（常去的版块）-- 登录时候
-(void)downLoadFavForumData{
    [DZApiRequest requestWithConfig:^(JTURLRequest *request) {
        request.urlString = url_CollectionForum;
    } success:^(id responseObject, JTLoadType type) {
        DLog(@"responseObject myfacforum=====%@",responseObject);
        // 判断 list 表单是否存在   存在则存储
        NSArray *list = [[responseObject objectForKey:@"Variables"]objectForKey:@"list"];
        if ([DataCheck isValidArray:list]) {
            [self setHotData:list];
            [self.tableView reloadData];
        } else {
            [self downLoadDataWtihForumType:@"hotforum"];
        }
        
    } failed:^(NSError *error) {
        [self showServerError:error];
        DLog(@"%@",error);
    }];
}

// 下载热门主题（热帖）
-(void)downLoadHotThreadData {
    [DZApiRequest requestWithConfig:^(JTURLRequest *request) {
        //获取热门主题
        [self.HUD showLoadingMessag:@"正在加载" toView:self.view];
        
    } success:^(id responseObject, JTLoadType type) {
        [self.HUD hideAnimated:YES];
        NSArray *data = [[responseObject objectForKey:@"Variables"] objectForKey:@"data"];
        if ([DataCheck isValidArray:data]) {
            self.dataSourceArr = data.mutableCopy;
            if (self.hotSource.count > 0) {
                [self.hotSource removeAllObjects];
            }
            for (NSDictionary *dic in self.dataSourceArr) {
                ThreadListModel *home = [[ThreadListModel alloc] init];
                [home setValuesForKeysWithDictionary:dic];
                [self.hotSource addObject:home];
            }
        }
    } failed:^(NSError *error) {
        [self.HUD hideAnimated:YES];
        [self showServerError:error];
    }];
}

//  处理热门版块数据
- (void)setHotData:(NSArray *)dataArr {
    if (self.offenSource != nil) {
        [self.offenSource removeAllObjects];
    }
    for (int i = 0; i < dataArr.count; i++)  {
        DZForumInfoModel * infoModel = [[DZForumInfoModel alloc] init];
        NSMutableDictionary *nodeDic = [NSMutableDictionary dictionary];
        nodeDic = [dataArr[i] mutableCopy];
        [infoModel setValuesForKeysWithDictionary:nodeDic];
        [self.offenSource addObject:infoModel];
    }
}

#pragma mark - tableView delegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section ==0) {
        return 90.0;
    }else {
        UITableViewCell * cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
        return [(DZHomeListCell *)cell cellHeight];
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section ==0) {
        if (self.offenSource.count <= 2) {
            return self.offenSource.count;
        } else if (self.offenSource.count > 2) {
            return 2;
        }
        return 0;
    } else {
        return self.hotSource.count;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50.0;
}


-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    static NSString *headID = @"CellHeader";
    RootForumCell *cell = [tableView dequeueReusableCellWithIdentifier:headID];
    if (cell == nil) {
        cell = [[RootForumCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:headID];
    }
    
    if (section == 0) {
        cell.textLab.text = @"常去的版块";
    } else {
        cell.textLab.text = @"热帖";
    }
    
    [cell.button setHidden:YES];
    
    return cell;
}

#pragma mark: 常去版块 待定
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        
        static NSString *OffenId = @"OffenID";
        
        ForumCell *cell = [tableView dequeueReusableCellWithIdentifier:OffenId];
        if (cell == nil) {
            cell = [[ForumCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:OffenId];
        }
        DZForumInfoModel * infoModel;
        
        if (self.offenSource.count > indexPath.row) {
            infoModel = self.offenSource[indexPath.row];
        }
        
        if (infoModel != nil) {
            [cell setInfo:infoModel];
        }
        return cell;
        
    } else {
        
        static  NSString  * CellIdentiferId = @"HomeCellCellID";
        DZHomeListCell  * cell = [tableView dequeueReusableCellWithIdentifier:CellIdentiferId];
        if (cell == nil) {
            cell = [[DZHomeListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentiferId];
            
        }
        
        ThreadListModel *model = [self.hotSource objectAtIndex:indexPath.row];
        cell.info = model;
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        DZForumInfoModel *infoModel = self.offenSource[indexPath.row];
        LianMixAllViewController *fvc = [[LianMixAllViewController alloc] init];
        fvc.forumFid = infoModel.fid;
        [self.navigationController pushViewController:fvc animated:YES];
    } else {
        ThreadListModel *model = self.hotSource[indexPath.row];
        DZForumThreadController * tvc = [[DZForumThreadController alloc] init];
        tvc.tid = model.tid;
        [self.navigationController pushViewController:tvc animated:YES];
    }
}

#pragma mark - getter
- (DZSlideShowScrollView *)scrollView {
    if (_scrollView == nil) {
        _scrollView = [[DZSlideShowScrollView alloc] init];
    }
    return _scrollView;
}

- (NSMutableArray *)offenSource {
    if (!_offenSource) {
        _offenSource = [NSMutableArray array];
    }
    return _offenSource;
}

- (NSMutableArray *)hotSource {
    if (!_hotSource) {
        _hotSource = [NSMutableArray array];
    }
    return _hotSource;
}

@end
