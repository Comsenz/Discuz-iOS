//
//  LianMixAllViewController.m
//  DiscuzMobile
//
//  Created by HB on 2017/5/19.
//  Copyright © 2017年 comsenz-service.com.  All rights reserved.
//

#import "LianMixAllViewController.h"

#import "CollectionTool.h"

#import "LianCollectionController.h"
#import "FListController.h"
#import "LianContainTableView.h"
#import "LoginController.h"

#import "PostNormalViewController.h"
#import "PostVoteViewController.h"
#import "PostDebateController.h"
#import "PostActivityViewController.h"
#import "MySubjectViewController.h"

#import "ForumListModel.h"
#import "PostTypeSelectView.h"
#import "ForumInfoView.h"
#import "ThreadViewController.h"

#import "ForumInfoModel.h"
#import "RootForumCell.h"
#import "SubForumCell.h"
#import "JudgeImageModel.h"
#import "DropTipView.h"

@interface LianMixAllViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) ForumInfoView *infoView;

@property (nonatomic, strong) NSDictionary *Variables;

@property (nonatomic, strong) LianCollectionController *containVC;
//YES代表能滑动
@property (nonatomic, assign) BOOL canScroll;

@property (nonatomic, strong) LianContainTableView *tableView;

@property (nonatomic, strong) NSMutableArray<FListController *> *ctvArr;

@property (nonatomic, strong) UITableViewCell *contentCell;

@property (nonatomic, strong) NSMutableArray <ForumListModel *> *titleArr;

@property (nonatomic, strong) ForumInfoModel *forumInfo;

@property (nonatomic, strong) UIView *headView;
@property (nonatomic, strong) UITableView *foldTableView;

@property (nonatomic, strong) NSMutableArray<ForumInfoModel *> *subForumArr;

@property (nonatomic, strong) PostTypeSelectView *selectView;
@property (nonatomic, strong) DropTipView *tipView;

@end

@implementation LianMixAllViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavc];
    
    [self dl_addNotification];
    
    self.canScroll = YES;
    
    self.tableView = [[LianContainTableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT - self.navbarMaxY) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    if (@available(iOS 11.0, *)) {
        self.tableView.estimatedRowHeight = 0;
        self.tableView.estimatedSectionFooterHeight = 0;
        self.tableView.estimatedSectionHeaderHeight = 0;
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    [self.view addSubview:self.tableView];
    
    self.headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, self.infoView.height)];
    self.headView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self setForumInfoHeader];
    
    self.foldTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.infoView.height, WIDTH, 0) style:UITableViewStylePlain];
    self.foldTableView.delegate = self;
    self.foldTableView.dataSource = self;
    [self.headView addSubview:self.foldTableView];
    
    ForumListModel *m1 = [ForumListModel initWithName:@"全部" andWithFid:self.forumFid];
    ForumListModel *m2 = [ForumListModel initWithName:@"最新" andWithFid:self.forumFid];
    ForumListModel *m3 = [ForumListModel initWithName:@"热门" andWithFid:self.forumFid];
    ForumListModel *m4 = [ForumListModel initWithName:@"精华" andWithFid:self.forumFid];
    
    [self.titleArr addObject:m1];
    [self.titleArr addObject:m2];
    [self.titleArr addObject:m3];
    [self.titleArr addObject:m4];
    
    
    self.selectIndex = 0;
    
    WEAKSELF;
    self.tableView.mj_header  = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        if (weakSelf.ctvArr.count > 0) {
            FListController *fVc = weakSelf.ctvArr[weakSelf.selectIndex];
            [fVc refreshData];
        } else {
            [weakSelf.tableView.mj_header endRefreshing];
        }
        //        [weakSelf refreshData];
    }];
    
    UIImageView *postBtn = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"writePost"]];
    CGFloat btn_width = 50.0;
    postBtn.frame = CGRectMake(WIDTH - btn_width - 15, HEIGHT - btn_width - 15 - self.navbarMaxY - 10, btn_width, btn_width);
    postBtn.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showTypeView)];
    [postBtn addGestureRecognizer:tap];
    [self.view addSubview:postBtn];
    self.selectView = [[PostTypeSelectView alloc] init];
    self.selectView.typeBlock = ^(PostType type) {
        [weakSelf.selectView close];
        [weakSelf switchTypeTopost:type];
    };
    
    
    // 添加提示视图
    [self.view addSubview:self.tipView];
    _tipView.userInteractionEnabled = YES;
    [self.tipView.closeBtn addTarget:self action:@selector(closeTipView) forControlEvents:UIControlEventTouchUpInside];
    self.tipView.clickTipAction = ^{
        [weakSelf toMyThread];
    };
}

- (void)showTipView {
    if (self.selectIndex != 0) {
        return;
    }
    if (self.tipView.tipAnimatefinsh == NO) {
        return;
    }
    // 0.设置提醒文字
    self.tipView.tipLabel.text = [NSString stringWithFormat:@"您有 %@ 个主题等待审核，点击查看",self.forumInfo.threadmodcount];
    CGRect orrect = self.tipView.frame;
    [UIView animateWithDuration:1.0 delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
        self.tipView.tipAnimatefinsh = NO;
        self.tipView.frame = CGRectMake(0, 0, orrect.size.width, orrect.size.height);
    } completion:^(BOOL finished) {
        [self performSelector:@selector(hideTipView) withObject:nil afterDelay:3];
    }];
}

- (void)hideTipView {
    CGRect orrect = CGRectMake(0, -self.navbarMaxY, WIDTH, 44);
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
                    self.tipView.frame = orrect;
                } completion:^(BOOL finished){
                    self.tipView.tipAnimatefinsh = YES;
                }];
}

- (void)closeTipView {
    self.tipView.frame = CGRectMake(0, -self.navbarMaxY, WIDTH, 44);
    self.tipView.tipAnimatefinsh = YES;
}

- (void)postSucceedToDetail:(NSString *)tid {
    ThreadViewController * tdvc = [[ThreadViewController alloc] init];
    tdvc.tid = tid;
    [self.navigationController pushViewController:tdvc animated:NO];
}


- (void)setForumInfoHeader {
    
    self.infoView = [[ForumInfoView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 75 + 10)];
    [self.infoView.collectionBtn addTarget:self action:@selector(collectAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.headView addSubview:self.infoView];
    self.headView.height = self.infoView.height;
    self.tableView.tableHeaderView = self.headView;
}

- (void)setIsCollection {
    [self.infoView.collectionBtn setImage:[UIImage imageNamed:@"collection_ok"] forState:UIControlStateNormal];
    self.infoView.collectionBtn.tag =1002;
    if (self.cForumBlock) {
        self.cForumBlock(YES);
    } else {
//        [[NSNotificationCenter defaultCenter] postNotificationName:COLLECTIONFORUMREFRESH object:nil];
    }
}

- (void)setNotCollection {
    [self.infoView.collectionBtn setImage:[UIImage imageTintColorWithName:@"collection" andImageSuperView:self.infoView.collectionBtn] forState:UIControlStateNormal];
    self.infoView.collectionBtn.tag=1000;
    if (self.cForumBlock) {
        self.cForumBlock(NO);
    } else {
//        [[NSNotificationCenter defaultCenter] postNotificationName:COLLECTIONFORUMREFRESH object:nil];
    }
}

#pragma matk - 按钮点击事件收藏板块
- (void)collectAction:(UIButton*)btn{
    
    if(![self isLogin]) {
        return;
    }
    
    if (btn.tag==1000) {// 收藏
        
        NSDictionary *getdic =@{@"id":self.forumFid};
        NSDictionary *dic = @{@"formhash":[Environment sharedEnvironment].formhash};
        [[CollectionTool shareInstance] collectionForum:getdic andPostdic:dic success:^{
            [self setIsCollection];
        } failure:nil];
        
    } else if (btn.tag==1002) {//取消
        NSDictionary *getDic = @{@"id":self.forumFid,
                                 @"type":@"forum"
                                 };
        NSDictionary *postDic = @{@"deletesubmit":@"true",
                                  @"formhash":[Environment sharedEnvironment].formhash
                                  };
        [[CollectionTool shareInstance] deleCollection:getDic andPostdic:postDic success:^{
            [self setNotCollection];
        } failure:nil];
        
    }
    
}

- (void)showTypeView {
    
    if (![self isLogin]) {
        return;
    }
    
    if (![DataCheck isValidDictionary:self.Variables]) {
        [MBProgressHUD showInfo:@"等待网络请求"];
        return;
    }
    
    if (self.selectView.typeArray.count == 0) {
        
        [MBProgressHUD showInfo:@"您当前不能发帖"];
        return;
    } else if (self.selectView.typeArray.count == 1) {
        PostTypeModel *model = self.selectView.typeArray[0];
        [self switchTypeTopost:model.type];
    } else {
        [self.selectView show];
    }
    
}

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

- (void)postNormal {
    WEAKSELF;
    PostNormalViewController * tvc = [[PostNormalViewController alloc] init];
    tvc.dataForumTherad = self.Variables;
    tvc.pushDetailBlock = ^(NSString *tid) {
        [weakSelf postSucceedToDetail:tid];
    };
    [self.navigationController pushViewController:tvc animated:YES];
}

- (void)postVote {
    WEAKSELF;
    PostVoteViewController * vcv = [[PostVoteViewController alloc] init];
    vcv.dataForumTherad = self.Variables;
    vcv.pushDetailBlock = ^(NSString *tid) {
        [weakSelf postSucceedToDetail:tid];
    };
    [self.navigationController pushViewController:vcv animated:YES];
}

- (void)postActivity {
    WEAKSELF;
    
    PostActivityViewController * ivc = [[PostActivityViewController alloc] init];
    ivc.dataForumTherad = self.Variables;
    ivc.pushDetailBlock = ^(NSString *tid) {
        [weakSelf postSucceedToDetail:tid];
    };
    
    [self.navigationController pushViewController:ivc animated:YES];
}

- (void)postDebate {
    
    WEAKSELF;
    PostDebateController *debateVC = [[PostDebateController alloc] init];
    debateVC.dataForumTherad = self.Variables;
    debateVC.pushDetailBlock = ^(NSString *tid) {
        [weakSelf postSucceedToDetail:tid];
    };
    [self showViewController:debateVC sender:nil];
}


- (void)loginedRefresh {
    if (self.ctvArr.count > 0) {
        FListController *fVc = self.ctvArr[self.selectIndex];
        [fVc refreshData];
    } else {
        [self.tableView.mj_header endRefreshing];
    }
}

//设置 nav
- (void)setNavc {
    self.navigationItem.title = @"帖子列表";
}


- (void)didSelectHeaderWithSection:(UITapGestureRecognizer *)sender {
    
    if (self.subForumArr.count == 0) {
        if ([DataCheck isValidArray:[self.Variables objectForKey:@"sublist"]]) {
            if (self.subForumArr.count == 0) {
                NSArray *arr = [self.Variables objectForKey:@"sublist"];
                for (NSDictionary *dic in arr) {
                    ForumInfoModel *model = [[ForumInfoModel alloc] init];
                    [model setValuesForKeysWithDictionary:dic];
                    [self.subForumArr addObject:model];
                }
            }
            
        }
    } else {
        [self.subForumArr removeAllObjects];
    }
    
    self.foldTableView.frame = CGRectMake(0, self.infoView.height, WIDTH, self.subForumArr.count * 68 + 54);
    self.headView.frame = CGRectMake(0, 0, WIDTH, self.infoView.height  + CGRectGetHeight(self.foldTableView.frame) + 5);
    self.tableView.tableHeaderView = self.headView;
    [self.foldTableView reloadData];
}

-(void)dl_addNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onOtherScrollToTop:) name:@"kLeaveTopNtf" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginedRefresh) name:LOGINEDREFRESHGETINFO object:nil];
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    static NSString * headerSection = @"CellHeader";
    RootForumCell *cell = [tableView dequeueReusableCellWithIdentifier:headerSection];
    if (cell == nil) {
        cell = [[RootForumCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:headerSection];
        UITapGestureRecognizer *tapG = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didSelectHeaderWithSection:)];
        [cell addGestureRecognizer:tapG];
    }
    
    if ([DataCheck isValidArray:[self.Variables objectForKey:@"sublist"]]) {
        
        NSArray *arr = [self.Variables objectForKey:@"sublist"];
        cell.textLab.text = [NSString stringWithFormat:@"子版块（%ld）",(unsigned long)arr.count];
    }
    
    if (self.subForumArr.count > 0) {
        [cell.button setImage:[UIImage imageTintColorWithName:@"open" andImageSuperView:cell.button] forState:UIControlStateNormal];
    } else {
        [cell.button setImage:[UIImage imageTintColorWithName:@"close" andImageSuperView:cell.button] forState:UIControlStateNormal];
        
    }
    
    return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (tableView == self.foldTableView)  {
        return 54.0;
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (tableView == self.foldTableView) {
        return self.subForumArr.count;
    }
    
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.foldTableView) {
        return 68;
    }
    return self.view.frame.size.height;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == self.foldTableView) {
        SubForumCell *cell = [tableView dequeueReusableCellWithIdentifier:@"subForum"];
        if (cell == nil) {
            cell = [[SubForumCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"subForum"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
        }
        
        ForumInfoModel *model = self.subForumArr[indexPath.row];
        [cell setInfo:model];
        
        return cell;
    } else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommonId"];
        
        if (cell == nil) {
            
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CommonId"];
            cell.backgroundColor = [UIColor groupTableViewBackgroundColor];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        if (self.ctvArr.count == 0) {
            NSMutableArray *vcArr = [NSMutableArray array];
            WEAKSELF;
            [self.titleArr enumerateObjectsUsingBlock:^(ForumListModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                
                FListController *listVc = [[FListController alloc] init];
                listVc.title = obj.name;
                listVc.fid = obj.fid;
                listVc.order = idx;
                listVc.sendBlock = ^ (NSDictionary *dic) {
                    
                    [weakSelf subSendVarible:dic];
                };
                
                listVc.endRefreshBlock = ^{
                    if ([DataCheck isValidString:weakSelf.forumInfo.threadmodcount]) {
                        if ([weakSelf.forumInfo.threadmodcount integerValue] > 0) {
//                            [weakSelf showTipView];
                        }
                    }
                    [weakSelf.tableView.mj_header endRefreshing];
                };
                [vcArr addObject:listVc];
                
            }];
            
            
            if ([DataCheck isValidArray:vcArr]) {
                self.ctvArr = vcArr;
                CGRect segmentRect = CGRectMake(0, 0, WIDTH, 44);
                self.contentView = cell.contentView;
                self.containVC = [[LianCollectionController alloc] init];
                [self.containVC setSubControllers:self.ctvArr parentController:self andSegmentRect:segmentRect];
                self.containVC.navigotionBarBackgroundColor = [UIColor whiteColor];
            }
            
        }
        
        return cell;
        
    }
    
}

- (void)subSendVarible:(NSDictionary *)dic {
    
    if ([DataCheck isValidDictionary:[dic objectForKey:@"forum"]]) { // 版块信息设置
        
        self.forumInfo = [[ForumInfoModel alloc] init];
        [self.forumInfo setValuesForKeysWithDictionary:[dic objectForKey:@"forum"]];
        
        if ([DataCheck isValidString:self.forumInfo.favorited]) {
            if ([self.forumInfo.favorited isEqualToString:@"1"]) {
                [self setIsCollection];
            } else {
                [self setNotCollection];
            }
        }
        
        [self setInfoViewInfo];
        
    }
    
    if ([DataCheck isValidArray:[dic objectForKey:@"sublist"]]) { // 子版块列表
        self.foldTableView.frame  = CGRectMake(0, self.infoView.height, WIDTH, 54);
        self.headView.frame = CGRectMake(0, 0, WIDTH, self.infoView.height + CGRectGetHeight(self.foldTableView.frame) + 5);
        self.tableView.tableHeaderView = self.headView;
        [self.subForumArr removeAllObjects];
        [self.foldTableView reloadData];
    } else {
        self.foldTableView.frame  = CGRectMake(0, self.infoView.height, WIDTH, 0);
        self.headView.frame = CGRectMake(0, 0, WIDTH, self.infoView.height);
        self.tableView.tableHeaderView = self.headView;
    }
    
    self.Variables = dic;
    
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
//        [self.selectView setPostType:@"0" andActivity:@"0" andDebate:@"0" andAllowspecialonly:@"0" andAllowpost:@"0"];
    }
    
    
}

- (void)setInfoViewInfo {
    if ([DataCheck isValidString:self.forumInfo.rank]) {
        self.infoView.bankLab.text = [NSString stringWithFormat:@"排名：%@",self.forumInfo.rank];
    }
    self.infoView.titleLab.text = self.forumInfo.name;
    self.infoView.threadsLab.text = [NSString stringWithFormat:@"主题：%@",self.forumInfo.threads];
    if ([DataCheck isValidString:self.forumInfo.descrip]) {
        self.infoView.describLab.text = self.forumInfo.descrip;
        [self.infoView layoutIfNeeded];
    }
    self.infoView.height = CGRectGetMaxY(self.infoView.describLab.frame) + 15;
    [self setInfoViewWithIcon:self.forumInfo.icon andtodaypost:self.forumInfo.todayposts];
}


- (void)setInfoViewWithIcon:(NSString *)icon andtodaypost:(NSString *)todaypost {
    if ([DataCheck isValidString:icon] && [JudgeImageModel graphFreeModel] == NO) {
        
        [self.infoView.IconV sd_setImageWithURL:[NSURL URLWithString:icon] placeholderImage:[UIImage imageNamed:@"forumCommon_l"] options:SDWebImageRetryFailed];
        
    } else {
        
        if ([todaypost integerValue] > 0) {
            self.infoView.IconV.image = [UIImage imageNamed:@"forumNew_l"];
        } else {
            self.infoView.IconV.image = [UIImage imageNamed:@"forumCommon_l"];
        }
    }
    
    if ([DataCheck isValidString:todaypost]) {
        self.infoView.todayPostLab.text = [NSString stringWithFormat:@"今日：%@", todaypost];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.foldTableView) {
        
        ForumInfoModel *node = self.subForumArr[indexPath.row];
        LianMixAllViewController *foVC = [[LianMixAllViewController alloc] init];
        foVC.forumFid = node.fid;
        [self.navigationController pushViewController:foVC animated:YES];
    }
}

- (void)toMyThread {
    MySubjectViewController *subjectVc = [[MySubjectViewController alloc] init];
    [self showViewController:subjectVc sender:nil];
}

- (void)setScrollEnable:(BOOL)scrollable {
    self.tableView.scrollEnabled = scrollable;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    //子控制器和主控制器之间的滑动状态切换
    CGFloat tabOffsetY = [_tableView rectForSection:0].origin.y;
    if (scrollView.contentOffset.y >= tabOffsetY) { // 调整下主控制器滚不动，子控制器滚动
        scrollView.contentOffset = CGPointMake(0, tabOffsetY);
        if (self.canScroll) {
            self.canScroll = NO;
            self.containVC.childCanScroll = YES;
            [self hideTipView];
        }
    } else if (!self.canScroll) {
        // 调整下主控制器滚不动，子控制器滚动
        scrollView.contentOffset = CGPointMake(0, tabOffsetY);
    }
    
    // *********** 其余情况就是主控制器滚动 子控制器不滚动
}

///通知的处理
//子控制器到顶部了 主控制器可以滑动
- (void)onOtherScrollToTop:(NSNotification *)ntf {
    self.canScroll = YES;
    self.containVC.childCanScroll = NO;
}

#pragma mark - setter、getter
- (NSMutableArray *)titleArr {
    if (!_titleArr) {
        _titleArr = [NSMutableArray array];
    }
    return _titleArr;
}

- (NSMutableArray<ForumInfoModel *> *)subForumArr {
    if (!_subForumArr) {
        _subForumArr = [NSMutableArray array];
    }
    return _subForumArr;
}

- (DropTipView *)tipView {
    if (!_tipView) {
        _tipView = [[DropTipView alloc] initWithFrame:CGRectMake(0, -self.navbarMaxY, WIDTH, 44)];
        _tipView.tipAnimatefinsh = YES;
    }
    return _tipView;
}

@end
