//
//  TTSearchController.m
//  DiscuzMobile
//
//  Created by HB on 16/4/15.
//  Copyright © 2016年 Cjk. All rights reserved.
//

#import "TTSearchController.h"
#import "SearchHistoryController.h"

#import "TTSearchModel.h"
#import "ThreadViewController.h"
#import "SearchListCell.h"
#import "CustomSearchBarView.h"
#import "UIAlertController+Extension.h"

@interface TTSearchController ()<UISearchBarDelegate>

@property (nonatomic, strong) CustomSearchBarView *searchView;
@property (nonatomic, strong) SearchHistoryController *historyVC;

@end

@implementation TTSearchController

- (instancetype)init
{
    self = [super init];
    if (self) { // 设置默认
        self.type = searchPostionTypeNext;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupViews];
    
    if (self.type == searchPostionTypeNext) {
        [self.searchView.searchBar becomeFirstResponder];
    }
    
    WEAKSELF;
    self.historyVC.SearchClick = ^(NSString *searchText) {
        weakSelf.searchView.searchBar.text = searchText;
        [weakSelf searchBarEndActive];
        [weakSelf clickSearch:searchText];
    };
    
    self.historyVC.ScrollWillDrag = ^{
        [weakSelf searchBarEndActive];
    };
}

#pragma mark - 布局
- (void)setupViews {

    [self createBarBtn:@"" type:NavItemText Direction:NavDirectionLeft];
    [self.navigationItem setHidesBackButton:YES];
    
    self.searchView = [[CustomSearchBarView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 30)];
    self.searchView.searchBar.delegate = self;
    self.navigationItem.titleView = self.searchView;
    [self.searchView.cancelBtn addTarget:self action:@selector(rightBarBtnClick) forControlEvents:UIControlEventTouchUpInside];
    if (self.type == searchPostionTypeTabbar) {
        self.searchView.searchBar.frame = CGRectMake(5, 1, WIDTH - 30, 28);
        [self.searchView.cancelBtn setHidden:YES];
    }
    
    
    [self.tableView registerClass:[SearchListCell class] forCellReuseIdentifier:[SearchListCell getReuseId]];
    self.tableView.backgroundColor = [UIColor whiteColor];
    WEAKSELF
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        weakSelf.page ++;
        [weakSelf requestData];
    }];
    self.tableView.mj_footer.hidden = YES;
    
}

- (void)rightBarBtnClick {
    [self.searchView.searchBar resignFirstResponder];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)leftBarBtnClick{}


#pragma mark - UITableDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSourceArr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SearchListCell *cell = [tableView dequeueReusableCellWithIdentifier:[SearchListCell getReuseId]];
    TTSearchModel *model = self.dataSourceArr[indexPath.row];
    cell.info = model;
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.dataSourceArr.count > 0) {
        TTSearchModel *model = self.dataSourceArr[indexPath.row];
        ThreadViewController * tvc = [[ThreadViewController alloc] init];
        tvc.tid = model.tid;
        tvc.threadtitle = model.subject;
        [self.navigationController pushViewController:tvc animated:YES];
    }
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor whiteColor];
    
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, WIDTH - 20, 39)];
    lab.textColor = [UIColor darkGrayColor];
    lab.font = [UIFont systemFontOfSize:14.0];
    lab.textAlignment = NSTextAlignmentLeft;
    UIView *lineView  = [[UIView alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(lab.frame), WIDTH - 15, 0.5)];
    lineView.backgroundColor = [UIColor lightGrayColor]; 
    if (section == 0) {
        lab.text = @"相关帖子";
    } else {
        lab.text = @"";
    }
    [view addSubview:lab];
    [view addSubview:lineView];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {

    return 40;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!self.cellHeights[indexPath]) {
        self.cellHeights[indexPath] = @([self caculateCellHeight:indexPath]);
    }
    return [self.cellHeights[indexPath] floatValue];
}

- (CGFloat)caculateCellHeight:(NSIndexPath *)indexPath {
    TTSearchModel *model = self.dataSourceArr[indexPath.row];
    SearchListCell *cell = [self.tableView dequeueReusableCellWithIdentifier:[SearchListCell getReuseId]];
    return [cell caculateCellHeight:model];
}

// 右Button响应
- (void)rightBarButtonItemAction:(UIBarButtonItem *)sender {
    [self.searchView.searchBar resignFirstResponder];
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}

#pragma mark - UISearchBarDelegate
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    return YES;
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
}

#pragma mark - 搜索响应事件
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self searchBarEndActive];
    if (![DataCheck isValidString:searchBar.text]) {
        [UIAlertController alertTitle:@"提示" message:@"请输入关键字" controller:self doneText:@"确定" cancelText:nil doneHandle:nil cancelHandle:nil];
        return;
    }
    
    NSString *searchText = searchBar.text;
    [self clickSearch:searchText];
}

- (void)clickSearch:(NSString *)searchText {
    self.historyVC.view.hidden = YES;
    [self.historyVC saveSearchHistory:searchText];
    self.historyVC.view.hidden = YES;
    
    if (self.dataSourceArr.count > 0) {
        self.dataSourceArr = [NSMutableArray array];
        [self.cellHeights removeAllObjects];
    }
    [self.tableView reloadData];
    self.tableView.mj_footer.hidden = YES;
    self.tableView.contentOffset = CGPointZero;
    self.page = 1;
    [self requestData];
}


- (void)requestData {
    if (![DataCheck isValidArray:self.dataSourceArr]) {
        [self.HUD showLoadingMessag:@"搜索中" toView:self.view];
    }
    [DZApiRequest requestWithConfig:^(JTURLRequest *request) {
        NSDictionary *dic = @{@"srchtxt":self.searchView.searchBar.text,
                              @"page":[NSString stringWithFormat:@"%ld",self.page],
                              };
        request.urlString = url_Search;
        request.parameters = dic;
    } success:^(id responseObject, JTLoadType type) {
        [self.HUD hide];
        [self.tableView.mj_footer endRefreshing];
        
        if ([DataCheck isValidDictionary:[responseObject objectForKey:@"Variables"]]) {
            
            if ([DataCheck isValidArray: [[responseObject objectForKey:@"Variables"] objectForKey:@"threadlist"]]) {
                NSArray *dataArr = [[responseObject objectForKey:@"Variables"] objectForKey:@"threadlist"];
                for (NSDictionary *dic in dataArr) {
                    
                    TTSearchModel *model = [[TTSearchModel alloc] init];
                    [model setValuesForKeysWithDictionary:dic];
                    model.keyword = self.searchView.searchBar.text;
                    [self.dataSourceArr addObject:model];
                    
                }
                NSInteger total = [[[responseObject objectForKey:@"Variables"] objectForKey:@"total"] integerValue];
                if (self.dataSourceArr.count >= total) {
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                }
            }
        } else {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
            self.page --;
        }
        [self emptyShow];
        if (self.dataSourceArr.count == 0) {
            [self searchBarBecomeActive];
        }
        
        [self.tableView reloadData];
    } failed:^(NSError *error) {
        [self.HUD hide];
        [self searchBarBecomeActive];
    }];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.searchView.searchBar endEditing:YES];
}

- (void)searchBarBecomeActive {
    [self.searchView.searchBar becomeFirstResponder];
}
- (void)searchBarEndActive {
    [self.searchView.searchBar endEditing:YES];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [self searchBarEndActive];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (![DataCheck isValidString:searchText]) {
        self.historyVC.view.hidden = NO;
        if (self.dataSourceArr.count > 0) {
            self.dataSourceArr = [NSMutableArray array];
            self.tableView.mj_footer.hidden = YES;
            [self.cellHeights removeAllObjects];
            [self.tableView reloadData];
        }
    }
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    
}

- (SearchHistoryController *)historyVC {
    if (_historyVC == nil) {
        _historyVC = [[SearchHistoryController alloc] init];
        [self.view addSubview:_historyVC.view];
        [self addChildViewController:_historyVC];
    }
    return _historyVC;
}

@end
