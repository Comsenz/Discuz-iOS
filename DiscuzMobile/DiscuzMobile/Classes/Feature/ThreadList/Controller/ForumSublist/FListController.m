//
//  FListController.m
//  DiscuzMobile
//
//  Created by HB on 2017/5/19.
//  Copyright © 2017年 comsenz-service.com.  All rights reserved.
//

#import "FListController.h"
#import "ThreadViewController.h"
#import "LoginController.h"
#import "OtherUserController.h"
#import "LianCollectionController.h"
#import "MySubjectViewController.h"
#import "UIAlertController+Extension.h"

#import "ThreadListModel.h"
#import "ThreadListModel+Forumdisplay.h"
#import "ShareCenter.h"
#import "ResponseMessage.h"
#import "AsyncAppendency.h"

#import "ThreadListCell.h"
//#import "TopNewCell.h"
#import "TopMlCell.h"
#import "VerifyThreadRemindView.h"


@interface FListController ()
@property (nonatomic, strong) VerifyThreadRemindView *verifyThreadRemindView;
@property (nonatomic ,strong) NSDictionary *forumInfoDic;

@property (nonatomic ,strong) NSDictionary *Variables;  //  数据

@property (nonatomic, strong) NSMutableArray *topThreadArray;
@property (nonatomic, strong) NSMutableArray *commonThreadArray;

@property (nonatomic, assign) NSInteger notThisFidCount;

@property (nonatomic, assign) BOOL isRequest;

@end

@implementation FListController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.page = 1;
    self.notThisFidCount = 0;
    
    [self inittableView];
    
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(firstRequest:) name:THREADLISTFISTREQUEST object:nil];
    
    if (self.order == 0) {
        self.isRequest = YES;
        [self loadCache];
    }
}

- (void)showVerifyRemind {
    self.tableView.tableHeaderView = self.verifyThreadRemindView;
//    self.verifyThreadRemindView.textLabel.text = [NSString stringWithFormat:@"您有 %@ 个主题等待审核，点击查看",self.forumInfo.threadmodcount];
}

- (void)hidVerifyRemind {
    self.tableView.tableHeaderView = nil;
}

- (void)firstRequest:(NSNotification *)notification {
    NSDictionary *userInfo = notification.userInfo;
    if ([DataCheck isValidDictionary:userInfo]) {
        NSInteger index = [[userInfo objectForKey:@"selectIndex"] integerValue];
        if (index == self.order && !self.isRequest) {
            self.isRequest = YES;
            [self loadCache];
        }
    }
}

-(void)inittableView {
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        if (self.forumInfoDic.count > 0) {
            NSInteger threadsCount = [[self.forumInfoDic objectForKey:@"threadcount"] integerValue] + self.notThisFidCount;
            if (threadsCount > self.dataSourceArr.count) {
                self.page ++;
                [self downLoadData:self.page andLoadType:JTRequestTypeRefresh];
            } else {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
        } else {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
    }];
    self.tableView.mj_footer.hidden = YES;
    ((MJRefreshAutoFooter *)self.tableView.mj_footer).triggerAutomaticallyRefreshPercent = -20;
}

- (void)refreshData {
    self.page = 1;
    [self.tableView.mj_footer resetNoMoreData];
    [self downLoadData:self.page andLoadType:JTRequestTypeRefresh];
}

- (void)loadCache { // 读取缓存
    
    if ([self.title isEqualToString:@"全部"]) {
        [self downLoadData:self.page andLoadType:JTRequestTypeCache];
        [self.HUD showLoadingMessag:@"正在刷新" toView:self.view];
        if ([DZApiRequest isCache:url_ForumTlist andParameters:@{@"fid":[NSString stringWithFormat:@"%@",_fid],@"page":[NSString stringWithFormat:@"%ld",(long)self.page]}]) {
            [self downLoadData:self.page andLoadType:JTRequestTypeRefresh];
        }
    } else {
        [self.HUD showLoadingMessag:@"正在刷新" toView:self.view];
        [self downLoadData:self.page andLoadType:JTRequestTypeRefresh];
    }
    
}


#pragma mark - 数据下载
- (void)downLoadData:(NSInteger)page andLoadType:(JTLoadType)loadType {
    
    
    NSMutableArray *dic = @{@"fid":[NSString stringWithFormat:@"%@",_fid],
                            @"page":[NSString stringWithFormat:@"%ld",(long)page],
                            }.mutableCopy;
    if ([self.title isEqualToString:@"最新"]) {
//        [dic setValue:@"lastpost" forKey:@"filter"];
//        [dic setValue:@"lastpost" forKey:@"orderby"];
        [dic setValue:@"author" forKey:@"filter"];
        [dic setValue:@"dateline" forKey:@"orderby"];
        
    } else if ([self.title isEqualToString:@"热门"]) {
        [dic setValue:@"heat" forKey:@"filter"];
        [dic setValue:@"heats" forKey:@"orderby"];
        
    } else if ([self.title isEqualToString:@"热帖"]) {
        [dic setValue:@"hot" forKey:@"filter"];
        
    } else if ([self.title isEqualToString:@"精华"]) {
        [dic setValue:@"digest" forKey:@"filter"];
        [dic setValue:@"1" forKey:@"digest"];
    }
    
    BOOL isCache = [DZApiRequest isCache:url_ForumTlist andParameters:dic];
    
    [DZApiRequest requestWithConfig:^(JTURLRequest *request) {
        request.urlString = url_ForumTlist;
        request.parameters = dic.mutableCopy;
        request.loadType = loadType;
        if ([self.title isEqualToString:@"全部"] && self.page == 1) {
            request.isCache = YES;
        }
    } success:^(id responseObject, JTLoadType type) {
        
        [self.HUD hide];
        [self.tableView.mj_header endRefreshing];
        
        BOOL haveAuther = [ResponseMessage autherityJudgeResponseObject:responseObject refuseBlock:^(NSString *message) {
            [UIAlertController alertTitle:nil message:message controller:self doneText:@"知道了" cancelText:nil doneHandle:^{
                [self.navigationController popViewControllerAnimated:YES];
            } cancelHandle:nil];
            [self.HUD hideAnimated:YES];
        }];
        if (!haveAuther) {
            return;
        }
        
        
        DLog(@"-------1----ForumThreadList=%@--------",responseObject);
        
        self.forumInfoDic = [[responseObject objectForKey:@"Variables"] objectForKey:@"forum"];
        
        self.Variables = [responseObject objectForKey:@"Variables"];
        
        if (self.page == 1) {
            [self sendVariablesToMixcontroller];
        }
        if (isCache == NO) {
            if (page == 1) {
                if (self.endRefreshBlock) {
                    self.endRefreshBlock();
                }
            }
        } else if (loadType == JTRequestTypeRefresh) {
            if (page == 1) {
                if (self.endRefreshBlock) {
                    self.endRefreshBlock();
                }
            }
        }
        
        NSString *threadmodcount = [self.forumInfoDic objectForKey:@"threadmodcount"];
        if ([DataCheck isValidString:threadmodcount] && [threadmodcount integerValue] > 0) {
            if (page == 1 && (isCache == NO || loadType == JTRequestTypeRefresh)) {
                self.verifyThreadRemindView.textLabel.text = [NSString stringWithFormat:@"您有 %@ 个主题等待审核，点击查看",threadmodcount];
                [self showVerifyRemind];
            }
        } else {
            [self hidVerifyRemind];
        }
        //        _allowpostspecial1 = [self.forumInfoDic objectForKey:@"allowpostspecial"];
        
        if (self.page == 1) { // 刷新列表
            // 刷新的时候移除数据源
            [self clearDatasource];
            
            [self anylyeData:responseObject];
            
            [self emptyShow];
            
        } else {
            
            [self.tableView.mj_footer endRefreshing];
            
            [self anylyeData:responseObject];
            
        }
        NSInteger threadsCount = [[self.forumInfoDic objectForKey:@"threadcount"] integerValue] + self.notThisFidCount;
        if (threadsCount <= self.dataSourceArr.count) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        [self.tableView reloadData];
        
    } failed:^(NSError *error) {
        
        [self.HUD hide];
        if (self.endRefreshBlock) {
            self.endRefreshBlock();
        }
        [self emptyShow];
        [self showServerError:error];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}

- (void)clearDatasource {
    
    self.notThisFidCount = 0;
    if (self.dataSourceArr.count > 0) {
        [self.dataSourceArr removeAllObjects];
    }
    if (self.cellHeights.count > 0) {
        [self.cellHeights removeAllObjects];
    }
    if (self.topThreadArray.count > 0) {
        [self.topThreadArray removeAllObjects];
        [self.commonThreadArray removeAllObjects];
    }
}

- (void)anylyeData:(id)responseObject {
    
    self.Variables = [responseObject objectForKey:@"Variables"];
    [ThreadListModel setThreadData:responseObject andFid:self.fid andPage:self.page handle:^(NSArray *topArr, NSArray *commonArr, NSArray *allArr, NSInteger notFourmCount) {
        
        if (self.page == 1) {
            self.notThisFidCount = notFourmCount;
            self.topThreadArray = [NSMutableArray arrayWithArray:topArr];
            self.commonThreadArray = [NSMutableArray arrayWithArray:commonArr];
            self.dataSourceArr = [NSMutableArray arrayWithArray:allArr];
        } else {
            
            if ([DataCheck isValidArray:commonArr]) {
                ThreadListModel *model1 = commonArr.firstObject;
                ThreadListModel *model2 = self.dataSourceArr.firstObject;
                if ([model1.tid isEqualToString:model2.tid]) {
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                    return;
                }
                [self.commonThreadArray addObjectsFromArray:commonArr];
            }
            if ([DataCheck isValidArray:allArr]) {
                [self.dataSourceArr addObjectsFromArray:allArr];
            }
        }
        
    }];
    
}

- (void)sendVariablesToMixcontroller {
    if ([self.title isEqualToString:@"全部"]) {
        if (self.sendBlock) {
            self.sendBlock(self.Variables);
        }
    }
    
}

#pragma mark - tableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.topThreadArray.count > 0) {
        return 2;
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (!self.cellHeights[indexPath]) {
        self.cellHeights[indexPath] = @([self heightForRowAtIndexPath:indexPath tableView:tableView]);
    }
    return [self.cellHeights[indexPath] floatValue];
}

- (CGFloat)heightForRowAtIndexPath:(NSIndexPath *)indexPath tableView:(UITableView *)tableView {
    
    UITableViewCell * cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    if (self.topThreadArray.count > 0) {
        if (indexPath.section == 0) {
            if (indexPath.row == 0 || indexPath.row == self.topThreadArray.count + 1) {
                return 5;
            }
            return [(TopMlCell *)cell cellHeight];
        } else {
            return [(BaseStyleCell *)cell cellHeight];
        }
    } else {
        return [(BaseStyleCell *)cell cellHeight];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (self.topThreadArray.count > 0) {
        if (section == 0) {
            return self.topThreadArray.count + 2; // 为了置顶帖那里显示更协调
        }
        return self.commonThreadArray.count;
    }
    
    return self.dataSourceArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return 5;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0;
}

#pragma mark- 判断是不是置顶帖子  displayorder  3，2，1 置顶  0 正常 -1 回收站  -2 审核中  -3 审核忽略  -4草稿
- (UITableViewCell * )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //判断是不是置顶帖子  displayorder  3，2，1 置顶  0 正常  -1 回收站  -2 审核中  -3 审核忽略  -4草稿
    if (self.topThreadArray.count > 0) {
        
        if (indexPath.section == 0) {
            
            static NSString * CellId = @"ForumTopThreadCellId";

            TopMlCell  * cell = [tableView dequeueReusableCellWithIdentifier:CellId];
            if (cell == nil) {
                cell = [[TopMlCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellId];
            }
            
            if (indexPath.row == 0 || indexPath.row == self.topThreadArray.count + 1) {
                [cell setDataWithModel:nil];
            } else {
                ThreadListModel *listModel = self.topThreadArray[indexPath.row - 1];
                [cell setDataWithModel:listModel];
            }
            
            return cell;
        } else {
            
            ThreadListModel *listModel = self.commonThreadArray[indexPath.row];
            return [self listCell:listModel];

        }
        
    } else {
        
        ThreadListModel *listModel = self.dataSourceArr[indexPath.row];
         return [self listCell:listModel];
    }
}

- (ThreadListCell *)listCell:(ThreadListModel *)listModel {
    static NSString * CellId = @"ThreadListId";
    ThreadListCell * cell = [self.tableView dequeueReusableCellWithIdentifier:CellId];
    if (cell == nil) {
        cell = [[ThreadListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellId];
    }
    cell.info = listModel;
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toOtherCenter:)];
    cell.headV.tag = [listModel.authorid integerValue];
    [cell.headV addGestureRecognizer:tapGes];
    return cell;
}

- (void)toOtherCenter:(UITapGestureRecognizer *)sender {
    
    if (![self isLogin]) {
        return;
    }
    NSInteger tag = sender.view.tag;
    NSString *authorId = [NSString stringWithFormat:@"%ld",(long)tag];
    OtherUserController * ovc = [[OtherUserController alloc] init];
    ovc.authorid = authorId;
    [self.navigationController pushViewController:ovc animated:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ThreadListModel *listModel;
    if (self.topThreadArray.count > 0) {
        if (indexPath.section == 0) {
            if (indexPath.row == 0 || indexPath.row == self.topThreadArray.count + 1) {
                return;
            }
            listModel = self.topThreadArray[indexPath.row - 1];
        } else {
            listModel = self.commonThreadArray[indexPath.row];
        }
    } else {
        listModel = self.dataSourceArr[indexPath.row];
    }
    
    [self pushThreadDetail:listModel];
}

- (void)pushThreadDetail:(ThreadListModel *)listModel {
    
    ThreadViewController * tvc = [[ThreadViewController alloc] init];
    tvc.dataForumTherad = self.Variables;
    tvc.tid = listModel.tid;
    [self.navigationController pushViewController:tvc animated:YES];
}

- (void)ToMySubjectViewController {
    MySubjectViewController *mysubjectVc = [[MySubjectViewController alloc] init];
    [self showViewController:mysubjectVc sender:nil];
}

- (NSMutableArray *)topThreadArray {
    if (!_topThreadArray) {
        _topThreadArray = [NSMutableArray array];
    }
    return _topThreadArray;
}

- (NSMutableArray *)commonThreadArray {
    if (!_commonThreadArray) {
        _commonThreadArray = [NSMutableArray array];
    }
    return _commonThreadArray;
}

- (NSDictionary *)forumInfoDic {
    if (!_forumInfoDic) {
        _forumInfoDic = [NSDictionary dictionary];
    }
    return _forumInfoDic;
}

- (VerifyThreadRemindView *)verifyThreadRemindView {
    if (!_verifyThreadRemindView) {
        _verifyThreadRemindView = [[VerifyThreadRemindView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 44)];
        WEAKSELF;
        _verifyThreadRemindView.clickRemindBlock = ^{
            [weakSelf ToMySubjectViewController];
        };
    }
    return _verifyThreadRemindView;
}

@end
