//
//  ForumIndexListController.m
//  DiscuzMobile
//
//  Created by piter on 2018/1/30.
//  Copyright © 2018年 comsenz-service.com.  All rights reserved.
//

#import "ForumIndexListController.h"
#import "TreeViewNode.h"
#import "ForumLeftCell.h"
#import "ForumRightCell.h"
#import "LianMixAllViewController.h"
#import "CollectionTool.h"
#import "LightGrayButton.h"
#import "AsyncAppendency.h"

@interface ForumIndexListController ()

@property (nonatomic, strong) UITableView *leftTable;
@property (nonatomic,assign) BOOL isSelected;

@end

@implementation ForumIndexListController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 判断左边菜单是否点击选中
    self.isSelected = NO;
    
    // 分割线
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = NAV_SEP_COLOR;
    [self.view addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.width.equalTo(self.view);
        make.height.equalTo(@0.5);
    }];
    
    // 做菜单
    [self.view addSubview:self.leftTable];
    [self.leftTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.left.equalTo(self.view);
        make.top.equalTo(@0.5);
        make.width.equalTo(self.view).multipliedBy(0.22);
    }];
    
    // 右内容
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.leftTable.mas_right);
        make.top.equalTo(self.leftTable);
        make.right.equalTo(self.view);
        make.height.equalTo(self.view);
    }];
    self.tableView.backgroundColor = FORUM_GRAY_COLOR;
    
    [self.leftTable registerClass:[ForumLeftCell class] forCellReuseIdentifier:[ForumLeftCell getReuseId]];
    [self.tableView registerClass:[ForumRightCell class] forCellReuseIdentifier:[ForumRightCell getReuseId]];
    
    // 下载数据
    [self cacheAndRequest];
    
    // 刷新
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshData) name:TABBARREFRESH object:nil];
    // 监听通知 收藏板块操作后，如果没有blockc传入，就必须发通知刷新这个页面数据
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshData) name:COLLECTIONFORUMREFRESH object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshData) name:DOMAINCHANGE object:nil];
}

- (void)cacheAndRequest {
    [self.HUD showLoadingMessag:@"正在刷新" toView:self.view];
    [self loadDataWithType:JTRequestTypeCache];
    if ([DZApiRequest isCache:url_Forumindex andParameters:nil]) {
        [self loadDataWithType:JTRequestTypeRefresh];
    }
}

- (void)refreshData {
    [self loadDataWithType:JTRequestTypeRefresh];
}


// 下载数据
- (void)loadDataWithType:(JTLoadType)loadType {
    
//            NSString *path = [[NSBundle mainBundle] pathForResource:@"fourm" ofType:@"json"];
//            // 将文件数据化
//            NSData *data = [[NSData alloc] initWithContentsOfFile:path];
//            // 对数据进行JSON格式化并返回字典形式
//            NSDictionary *resp = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
//            [self setForumList:resp];
//             [self.HUD hideAnimated:YES];
//            return;
    
    [DZApiRequest requestWithConfig:^(JTURLRequest *request) {
        request.urlString = url_Forumindex;
        request.loadType = loadType;
        request.isCache = YES;
    } success:^(id responseObject, JTLoadType type) {
        [self.HUD hide];
        
        [self.tableView.mj_header endRefreshing];
        if ([DataCheck isValidArray:self.dataSourceArr]) {
            [self.dataSourceArr removeAllObjects];
        }
        [self setForumList:responseObject];
        [self.tableView reloadData];
        [self.leftTable reloadData];
        
    } failed:^(NSError *error) {
        [self.HUD hide];
        [self showServerError:error];
    }];
}

// 处理全部版块数据
- (void)setForumList:(id)responseObject {
    self.dataSourceArr = [NSMutableArray arrayWithArray:[TreeViewNode setAllforumData:responseObject]];
}

#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (tableView == self.leftTable) {
        return 1;
    }
    return self.dataSourceArr.count;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.leftTable) {
        return self.dataSourceArr.count;
    }
    TreeViewNode *node = self.dataSourceArr[section];
    return node.nodeChildren.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TreeViewNode *node = self.dataSourceArr[indexPath.section];
    if (tableView == self.leftTable) {
        ForumLeftCell *cell = [tableView dequeueReusableCellWithIdentifier:[ForumLeftCell getReuseId]];
        node = self.dataSourceArr[indexPath.row];
        cell.titleLab.text = node.nodeName;
        return cell;
    } else {
        ForumRightCell *cell = [tableView dequeueReusableCellWithIdentifier:[ForumRightCell getReuseId]];
        WEAKSELF;
        cell.collectionBlock = ^(LightGrayButton *sender,ForumInfoModel *infoModel) {
            [weakSelf collectAction:sender andModel:infoModel];
        };
        
        [cell setInfo:node.nodeChildren[indexPath.row].infoModel];
        return cell;
    }
}

#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.leftTable) {
        return 44;
    }
    return 65;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (tableView == self.tableView) {
        TreeViewNode *node = self.dataSourceArr[section];
        return node.nodeName;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.leftTable) {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:indexPath.row] atScrollPosition:UITableViewScrollPositionTop animated:YES];
        self.isSelected = YES;
    } else {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        TreeViewNode * node = self.dataSourceArr[indexPath.section];
        node = node.nodeChildren[indexPath.row];
        [self pushThreadList:node];
    }
}

// 跳转列表页
- (void)pushThreadList:(TreeViewNode *)node {
    
    LianMixAllViewController *foVC = [[LianMixAllViewController alloc] init];
    DLog(@"%@",node.infoModel.fid);
    foVC.forumFid = node.infoModel.fid;
    
    WEAKSELF;
    foVC.cForumBlock = ^(BOOL isCollection) {
        if (isCollection) {
            node.infoModel.favorited = @"1";
        } else {
            node.infoModel.favorited = @"0";
        }
        [weakSelf.tableView reloadData];
    };
    [self.navigationController pushViewController:foVC animated:YES];
}

// 向下滑（将出现的要重新计算一下）
- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    header.textLabel.font = [FontSize HomecellTimeFontSize14];
    header.contentView.backgroundColor = [UIColor whiteColor];
    for (UIView *subview in header.subviews) {
        if (subview.tag == 2018) {
            [subview removeFromSuperview];
        }
    }
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(15, header.height - 1, header.width - 15, 0.5)];
    line.tag = 2018;
    line.backgroundColor = NAV_SEP_COLOR;
    [header addSubview:line];
    
    if (tableView == self.tableView) {
        [self leftTableSet];
    }
}
// 向上滑（滑动到上面的时候要算一下）包括刚出现
- (void)tableView:(UITableView *)tableView didEndDisplayingHeaderView:(UIView *)view forSection:(NSInteger)section {
    if (tableView == self.tableView) {
        [self leftTableSet];
    }
}

// 右边滑动的时候，左边设置下点击状态
- (void)leftTableSet {
    // 判断，如果是左边点击触发的滚动，这不执行下面代码
    if (self.isSelected) {
        return;
    }
    // 获取可见视图的第一个row
    NSInteger currentSection = [[[self.tableView indexPathsForVisibleRows] firstObject] section];
    NSIndexPath *index = [NSIndexPath indexPathForRow:currentSection inSection:0];
    // 点击左边对应区块
    [self.leftTable selectRowAtIndexPath:index animated:YES scrollPosition:UITableViewScrollPositionTop];
}

// 开始拖动赋值没有点击
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    // 当右边视图将要开始拖动时，则认为没有被点击了。
    self.isSelected = NO;
}

#pragma matk - 按钮点击事件收藏板块
- (void)collectAction:(LightGrayButton *)btn andModel:(ForumInfoModel *)model {
    
    if(![self isLogin]) {
        return;
    }
    
    if (btn.lighted==YES) {// 收藏
        
        NSDictionary *getdic =@{@"id":model.fid};
        NSDictionary *dic = @{@"formhash":[Environment sharedEnvironment].formhash};
        [[CollectionTool shareInstance] collectionForum:getdic andPostdic:dic success:^{
            btn.lighted = NO;
            model.favorited = @"1";
        } failure:nil];
        
    } else if (btn.lighted==NO) {//取消
        NSDictionary *getDic = @{@"id":model.fid,
                                 @"type":@"forum"
                                 };
        NSDictionary *postDic = @{@"deletesubmit":@"true",
                                  @"formhash":[Environment sharedEnvironment].formhash
                                  };
        [[CollectionTool shareInstance] deleCollection:getDic andPostdic:postDic success:^{
            btn.lighted = YES;
            model.favorited = @"0";
        } failure:nil];
        
    }
}

#pragma mark - setter getter
- (UITableView *)leftTable {
    if (_leftTable == nil) {
        _leftTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width * 0.22, self.view.frame.size.height) style:UITableViewStylePlain];
        _leftTable.backgroundColor = FORUM_GRAY_COLOR;
        //    _leftTable.showsVerticalScrollIndicator = NO;
        _leftTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        _leftTable.delegate = self;
        _leftTable.dataSource = self;
        _leftTable.tableFooterView = [[UIView alloc] init];
        if (@available(iOS 11.0, *)) {
            _leftTable.estimatedRowHeight = 0;
            _leftTable.estimatedSectionFooterHeight = 0;
            _leftTable.estimatedSectionHeaderHeight = 0;
            _leftTable.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return _leftTable;
}

@end
