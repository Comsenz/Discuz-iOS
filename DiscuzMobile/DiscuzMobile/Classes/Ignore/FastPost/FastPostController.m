//
//  FastPostController.m
//  DiscuzMobile
//
//  Created by ZhangJitao on 2018/7/17.
//  Copyright © 2018年 comsenz-service.com.  All rights reserved.
//

#import "FastPostController.h"
#import "TreeViewNode.h"
#import "ForumLeftCell.h"
#import "FastLevelCell.h"
#import "LightGrayButton.h"
#import "PostTypeSelectView.h"
#import "PostTypeModel.h"

#import "PostNormalViewController.h"
#import "PostVoteViewController.h"
#import "PostDebateController.h"
#import "PostActivityViewController.h"
#import "ThreadViewController.h"

#import "UIImageView+FindHairline.h"

@interface FastPostController ()

@property (nonatomic,assign) BOOL isSelected;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UIButton *closeBtn;
@property (nonatomic, strong) PostTypeSelectView *selectView;
@property (nonatomic, strong) NSString *selectFid;
@property (nonatomic, strong) NSMutableDictionary *Variables;

@property (nonatomic, strong) UIImageView *navBarHairlineImageView;
@property (nonatomic, strong) UIButton *refreshBtn;

@end

@implementation FastPostController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _navBarHairlineImageView.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    _navBarHairlineImageView.hidden = NO;
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"选择发帖版块";
    _navBarHairlineImageView = [UIImageView findHairlineImageViewUnder:self.navigationController.navigationBar];
    [self createBarBtn:@"" type:NavItemText Direction:NavDirectionLeft];
    
    // 判断左边菜单是否点击选中
    self.isSelected = NO;
    
    self.view.backgroundColor = FORUM_GRAY_COLOR;
    // 做菜单
    [self.view addSubview:self.leftTable];
    [self.leftTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.height.equalTo(self.view).offset(-self.tabbarHeight);
        make.top.equalTo(@0);
        make.width.equalTo(self.view).multipliedBy(0.22);
    }];
    
    // 右内容
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.leftTable.mas_right);
        make.top.equalTo(self.leftTable);
        make.right.equalTo(self.view);
        make.height.equalTo(self.view).offset(-self.tabbarHeight);
    }];
    self.tableView.backgroundColor = FORUM_GRAY_COLOR;
    
    [self.leftTable registerClass:[ForumLeftCell class] forCellReuseIdentifier:[ForumLeftCell getReuseId]];
    [self.tableView registerClass:[FastLevelCell class] forCellReuseIdentifier:[FastLevelCell getReuseId]];
    
    [self.view addSubview:self.closeBtn];
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tableView.mas_bottom).offset(2);
        make.centerX.equalTo(self.view);
        make.width.height.equalTo(@44);
    }];
    [self.closeBtn addTarget:self action:@selector(closeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    self.selectView = [[PostTypeSelectView alloc] init];
    WEAKSELF;
    self.selectView.typeBlock = ^(PostType type) {
        [weakSelf.selectView close];
        [weakSelf switchTypeTopost:type];
    };
    
    [self.view addSubview:self.refreshBtn];
    [self.refreshBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.width.equalTo(@100);
        make.height.equalTo(@50);
    }];
    [self.view layoutIfNeeded];
    self.refreshBtn.layer.cornerRadius = 5;
    self.refreshBtn.hidden = YES;
    
    // 下载数据
    [self cacheAndRequest];
}

#pragma mark - 请求处理数据
- (void)cacheAndRequest {
    [self.HUD showLoadingMessag:@"正在刷新" toView:self.view];
    [self loadDataWithType:JTRequestTypeCache];
    if ([DZApiRequest isCache:url_Forumindex andParameters:nil]) {
        [self loadDataWithType:JTRequestTypeRefresh];
    }
}



// 下载数据
- (void)loadDataWithType:(JTLoadType)loadType {
//        NSString *path = [[NSBundle mainBundle] pathForResource:@"fourm" ofType:@"json"];
//        // 将文件数据化
//        NSData *data = [[NSData alloc] initWithContentsOfFile:path];
//        // 对数据进行JSON格式化并返回字典形式
//        NSDictionary *resp = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
//        [self setForumList:resp];
//         [self.HUD hideAnimated:YES];
//        return;
    [DZApiRequest requestWithConfig:^(JTURLRequest *request) {
        request.urlString = url_Forumindex;
        request.loadType = loadType;
        request.isCache = YES;
    } success:^(id responseObject, JTLoadType type) {
        self.refreshBtn.hidden = YES;
        [self.HUD hideAnimated:YES];
        [self.tableView.mj_header endRefreshing];
        DLog(@"%@",responseObject);
        if ([DataCheck isValidArray:self.dataArray]) {
            [self.dataArray removeAllObjects];
        }
        [self setForumList:responseObject];
        [self.tableView reloadData];
        [self.leftTable reloadData];
        
    } failed:^(NSError *error) {
        self.refreshBtn.hidden = NO;
        [self.HUD hideAnimated:YES];
        [self showServerError:error];
        DLog(@"%@",error);
        
    }];
}

// 处理全部版块数据
- (void)setForumList:(id)responseObject {
    self.dataArray = [NSMutableArray arrayWithArray:[TreeViewNode setAllforumData:responseObject]];
    if (self.dataSourceArr.count > 0) {
        [self.dataSourceArr removeAllObjects];
    }
    for (int i = 0; i < self.dataArray.count; i ++) {
        NSMutableArray *array = [NSMutableArray array];
        TreeViewNode *node = self.dataArray[i];
        for (TreeViewNode *listNode in node.nodeChildren) {
            [array addObject:listNode];
            //            if ([DataCheck isValidArray:listNode.nodeChildren]) { // node全展开
            //                [self addAllSubForum:listNode array:array];
            //            }
        }
        [self.dataSourceArr addObject:array];
    }
}

- (void)addAllSubForum:(TreeViewNode *)node array:(NSMutableArray *)array {
    
    for (TreeViewNode *child in node.nodeChildren) {
        [array addObject:child];
        if ([DataCheck isValidArray:child.nodeChildren]) {
            [self addAllSubForum:child array:array];
        }
    }
}

- (void)errorRefresh {
    [self loadDataWithType:JTRequestTypeRefresh];
}

#pragma mark - 发帖类型框Action
- (void)showTypeView {
    
    if (![self isLogin]) {
        return;
    }
    if (self.selectView.typeArray.count == 0) {
        [MBProgressHUD showInfo:@"您当前无权限发帖"];
        return;
    } else if (self.selectView.typeArray.count == 1) {
        PostTypeModel *model = self.selectView.typeArray[0];
        [self switchTypeTopost:model.type];
    } else {
        [self.selectView show];
    }
}

#pragma mark - 点击去往发帖页
- (void)switchTypeTopost:(PostType)type {
    switch (type) {
        case post_normal:
            [self postNormal];
            break;
        case post_vote:
            [self postVote];
            break;
        case post_activity:
            [self postActivity];
            break;
        case post_debate:
            [self postDebate];
            break;
        default:
            break;
    }
}

- (void)publicPostControllerSet:(PostBaseController *)controller {
    WEAKSELF;
    controller.dataForumTherad = self.Variables;
    controller.fid = self.selectFid;
    controller.pushDetailBlock = ^(NSString *tid) {
        [weakSelf postSucceedToDetail:tid];
    };
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)postNormal {
    PostNormalViewController * tvc = [[PostNormalViewController alloc] init];
    [self publicPostControllerSet:tvc];
}

- (void)postVote {
    PostVoteViewController * vcv = [[PostVoteViewController alloc] init];
    [self publicPostControllerSet:vcv];
}

- (void)postActivity {
    PostActivityViewController * ivc = [[PostActivityViewController alloc] init];
    [self publicPostControllerSet:ivc];
}

- (void)postDebate {
    PostDebateController *debateVC = [[PostDebateController alloc] init];
    [self publicPostControllerSet:debateVC];
}

- (void)postSucceedToDetail:(NSString *)tid {
    ThreadViewController * tdvc = [[ThreadViewController alloc] init];
    tdvc.tid = tid;
    [self.navigationController pushViewController:tdvc animated:NO];
}

- (void)closeBtnClick {
    [[NSNotificationCenter defaultCenter] postNotificationName:SETSELECTINDEX object:nil];
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (void)reloadSection:(NSInteger)section withNodeModel:(TreeViewNode *)model withExpand:(BOOL)isExpand {
    
    NSMutableArray *sectionDataArry = [self.dataSourceArr objectAtIndex:section];
    
    // 点击的行
    NSInteger currentRow = [sectionDataArry indexOfObject:model];
    NSIndexPath *currentIndexPath = [NSIndexPath indexPathForRow:currentRow inSection:section];
    
    
    // 点击末行的时候需要滚动
    NSIndexPath *scrollIndexPath;
    
    if (isExpand){
        
        [self expandInsertRow:currentIndexPath nodeModel:model];

        // 需要滚动的下标
        NSInteger mustvisableRow = currentRow + 1;
        if (model.nodeChildren.count >= 2) {
            mustvisableRow = currentRow + 2;
        }
        scrollIndexPath = [NSIndexPath indexPathForRow:mustvisableRow inSection:section];
        
    } else {
        
        [self expandDeleteRow:currentIndexPath nodeModel:model];

        scrollIndexPath = [NSIndexPath indexPathForRow:currentRow inSection:section];
    }
    
    // 更新当前行的箭头
    [self.tableView reloadRowsAtIndexPaths:@[currentIndexPath] withRowAnimation:UITableViewRowAnimationNone];
    
    // 滚动
    UITableViewCell *scrollCell = [self.tableView cellForRowAtIndexPath:scrollIndexPath];
    if(![[self.tableView visibleCells] containsObject:scrollCell]) {
        [self.tableView scrollToRowAtIndexPath:currentIndexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    }
}

// 插入行
- (void)expandInsertRow:(NSIndexPath *)indexPath nodeModel:(TreeViewNode *)model {
    NSMutableArray *sectionDataArry = [self.dataSourceArr objectAtIndex:indexPath.section];
    // 这一步是防止在二级展开的情况下,关闭一级展开, 则二级展开的状态还是展开,需要手动置回 NO
    for (int i =0; i<model.nodeChildren.count; i++) {
        TreeViewNode *mod = [model.nodeChildren objectAtIndex:i];
        mod.isExpanded = NO;
    }
    // 插入数据源
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(indexPath.row+1, model.nodeChildren.count)];
    [sectionDataArry insertObjects:model.nodeChildren atIndexes:indexSet];
    
    // 插入行下标数组
    NSMutableArray *reloadIndexPaths = [NSMutableArray array];
    for (int i = 0; i < model.nodeChildren.count; i ++) {
        NSIndexPath *idxPath = [NSIndexPath indexPathForRow:i + indexPath.row + 1 inSection:indexPath.section];
        [reloadIndexPaths addObject:idxPath];
    }
    
    // 插入行
    [self.tableView beginUpdates];
    [self.tableView insertRowsAtIndexPaths:reloadIndexPaths withRowAnimation:UITableViewRowAnimationBottom];
    [self.tableView endUpdates];
}

// 删除行
- (void)expandDeleteRow:(NSIndexPath *)indexPath nodeModel:(TreeViewNode *)model {
    NSMutableArray *sectionDataArry = [self.dataSourceArr objectAtIndex:indexPath.section];
    // 获取当前行下的所有子节点的数目
    int count = 0;
    for (int i = indexPath.row; i < sectionDataArry.count; i ++) {
        TreeViewNode *mod = [sectionDataArry objectAtIndex:i];
        if (mod.nodeLevel > model.nodeLevel) {
            count ++;
        }
    }
    // 移除数据源
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(indexPath.row+1, count)];
    [sectionDataArry removeObjectsAtIndexes:indexSet];
    
    // 需要删除的行下标数组
    NSMutableArray *reloadIndexPaths = [NSMutableArray array];
    for (int i = 0; i < count; i ++) {
        NSIndexPath *idxPath = [NSIndexPath indexPathForRow:i + indexPath.row + 1 inSection:indexPath.section];
        [reloadIndexPaths addObject:idxPath];
    }
    
    // 删除行
    [self.tableView beginUpdates];
    [self.tableView deleteRowsAtIndexPaths:reloadIndexPaths withRowAnimation:UITableViewRowAnimationNone];
    [self.tableView endUpdates];
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
        return self.dataArray.count;
    }
    NSArray *array = self.dataSourceArr[section];
    return array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *textStr = @"";
    
    if (tableView == self.leftTable) {
        TreeViewNode *node = self.dataArray[indexPath.row];
        textStr = node.nodeName;
        
        ForumLeftCell *cell = [tableView dequeueReusableCellWithIdentifier:[ForumLeftCell getReuseId]];
        cell.titleLab.text = textStr;
        return cell;
    } else {
        NSArray *nodeArr = self.dataSourceArr[indexPath.section];
        TreeViewNode *node = nodeArr[indexPath.row];
        FastLevelCell *cell = [tableView dequeueReusableCellWithIdentifier:[FastLevelCell getReuseId]];
        [cell setInfo:node];
        [cell.statusBtn addTarget:self action:@selector(clickLevel:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }
}

- (void)clickLevel:(UIButton *)sender {
    FastLevelCell *cell = (FastLevelCell *)sender.superview;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    NSArray *nodeArray = self.dataSourceArr[indexPath.section];
    TreeViewNode *node = nodeArray[indexPath.row];
    if ([DataCheck isValidArray:node.nodeChildren]) {
        node.isExpanded = !node.isExpanded;
        [self reloadSection:indexPath.section withNodeModel:node withExpand:node.isExpanded];
    }
}

#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.leftTable) {
        return 44;
    }
    return 60;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (tableView == self.tableView) {
        TreeViewNode *node = self.dataArray[section];
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
        
        NSArray *nodeArr = self.dataSourceArr[indexPath.section];
        TreeViewNode *node = nodeArr[indexPath.row];
        self.selectFid = node.infoModel.fid;
        
        NSDictionary * dic =@{@"fid":node.infoModel.fid
                              };
        [DZApiRequest requestWithConfig:^(JTURLRequest *request) {
            [self.HUD showLoadingMessag:@"验证发帖权限" toView:self.view];
            request.urlString = url_CheckPostAuth;
            request.parameters = dic;
            
            // ------------------ 这个地方，请求加个缓存 ------------
            request.loadType = JTRequestTypeCache;
            request.isCache = YES;
            // ------------------ 这个地方，请求加个缓存 ------------
            
        } success:^(id responseObject, JTLoadType type) {
            DLog(@"%@",responseObject);
            [self.HUD hideAnimated:YES];
            self.Variables = [responseObject objectForKey:@"Variables"];
            NSDictionary *group = [self.Variables objectForKey:@"group"];
            if ([DataCheck isValidDictionary:group]) { // 能发的帖子类型处理
                NSString *allowpost = [[self.Variables objectForKey:@"allowperm"] objectForKey:@"allowpost"];
                
                NSString *allowpostpoll = @"0";
                NSString *allowpostactivity = @"0";
                NSString *allowpostdebate = @"0";
                if ([DataCheck isValidString:[group objectForKey:@"allowpostpoll"]]) {
                    allowpostpoll = [group objectForKey:@"allowpostpoll"];
                }
                if ([DataCheck isValidString:[group objectForKey:@"allowpostactivity"]]) {
                    allowpostactivity = [group objectForKey:@"allowpostactivity"];
                }
                if ([DataCheck isValidString:[group objectForKey:@"allowpostdebate"]]) {
                    allowpostdebate = [group objectForKey:@"allowpostdebate"];
                }
                NSString *allowspecialonly = [[self.Variables objectForKey:@"forum"] objectForKey:@"allowspecialonly"];
                [self.selectView setPostType:allowpostpoll
                                    activity:allowpostactivity
                                      debate:allowpostdebate
                            allowspecialonly:allowspecialonly
                                   allowpost:allowpost];
                
            } else {
                [MBProgressHUD showInfo:@"暂无发帖权限"];
            }
            
        } failed:^(NSError *error) {
            [self.HUD hideAnimated:YES];
            [self showServerError:error];
        }];
        
    }
}

// 向下滑（将出现的要重新计算一下）
- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    if (tableView == self.tableView) {
        UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
        header.textLabel.font = [FontSize HomecellTimeFontSize14];
        header.contentView.backgroundColor = [UIColor whiteColor];
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

#pragma mark - setter getter
- (UITableView *)leftTable {
    if (_leftTable == nil) {
        _leftTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width * 0.22, self.view.frame.size.height) style:UITableViewStylePlain];
        _leftTable.backgroundColor = FORUM_GRAY_COLOR;
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

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (UIButton *)closeBtn {
    if (!_closeBtn) {
        _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeBtn setImage:[UIImage imageNamed:@"closeTz"] forState:UIControlStateNormal];
    }
    return _closeBtn;
}

- (UIButton *)refreshBtn {
    if (!_refreshBtn) {
        _refreshBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _refreshBtn.layer.borderColor = MESSAGE_COLOR.CGColor;
        _refreshBtn.layer.borderWidth = 1;
        [_refreshBtn setTitleColor:MESSAGE_COLOR forState:UIControlStateNormal];
        [_refreshBtn setTitle:@"刷新" forState:UIControlStateNormal];
        [_refreshBtn addTarget:self action:@selector(errorRefresh) forControlEvents:UIControlEventTouchUpInside];
    }
    return _refreshBtn;
}

- (NSMutableDictionary *)Variables {
    if (!_Variables) {
        _Variables = [NSMutableDictionary dictionary];
    }
    return _Variables;
}


@end
