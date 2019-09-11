//
//  ForumCollectionController.m
//  DiscuzMobile
//
//  Created by HB on 17/5/2.
//  Copyright © 2017年 comsenz-service.com.  All rights reserved.
//

#import "FootForumController.h"
#import "TreeViewNode.h"

#import "ForumItemCell.h"
#import "ForumReusableView.h"
#import "LianMixAllViewController.h"

@interface FootForumController () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSMutableArray *dataSourceArr;

@property (nonatomic, strong) NSMutableArray<TreeViewNode *> *dataSource;
@property (nonatomic, strong) NSMutableArray<TreeViewNode *> *hotSource;

@end

@implementation FootForumController


static NSString *CellID = @"fourmCollection";
static NSString * headerSection = @"CellHeader";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initCollectionView];
    
    [self loadData];
    
    WEAKSELF;
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf loadData];
    }];
    
    [self.HUD showLoadingMessag:@"正在刷新" toView:self.view];

}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)refresh {
    if ([self.view hu_intersectsWithAnotherView:nil]) {
        // 刷新
        [self.collectionView.mj_header beginRefreshing];
    }
}

- (void)reloadImage {
    [self.collectionView reloadData];
}

- (void)initCollectionView {
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    //    UIEdgeInsetsMake(<#CGFloat top#>, <#CGFloat left#>, <#CGFloat bottom#>, <#CGFloat right#>)
    flowLayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    flowLayout.minimumLineSpacing = 10;
    flowLayout.minimumInteritemSpacing = 4;
    flowLayout.itemSize = CGSizeMake((WIDTH - 18 - 18) / 3, WIDTH / 3 + 40);
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT) collectionViewLayout:flowLayout];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    [self.collectionView registerClass:[ForumItemCell class] forCellWithReuseIdentifier:CellID];
    [self.collectionView registerClass:[ForumReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerSection];
    
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    
    [self.view addSubview:self.collectionView];
}

- (void)loadData {
    
    [DZApiRequest requestWithConfig:^(JTURLRequest *request) {
        request.isCache = YES;
        request.urlString = url_Forumindex;
    } success:^(id responseObject, JTLoadType type) {
        [self.HUD hide];
        [self.collectionView.mj_header endRefreshing];
        
        self.hotSource = [NSMutableArray array];
        [self setHotData:[[responseObject objectForKey:@"Variables"] objectForKey:@"visitedforums"]];
        [self emptyShow];
        [self.collectionView reloadData];
        
    } failed:^(NSError *error) {
        [self.HUD hide];
        [self showServerError:error];
        [self.collectionView.mj_header endRefreshing];
    }];
}

- (void)emptyShow {
    
    if (self.dataSourceArr.count > 0) {
        self.emptyView.hidden = YES;
    } else {
        self.emptyView.hidden = NO;
        self.emptyView.frame = self.collectionView.frame;
        
        if (!self.emptyView.isOnView) {
            
            [self.collectionView addSubview:self.emptyView];
            self.emptyView.isOnView = YES;
        }
    }
}

//  处理热门版块数据
- (void)setHotData:(NSArray *)dataArr {
    
    self.hotSource = [NSMutableArray array];
    self.dataSourceArr = [NSMutableArray array];
    for (int i = 0; i < dataArr.count; i++)  {
        TreeViewNode * treeNode = [[TreeViewNode alloc] init];
        NSMutableDictionary *nodeDic = [NSMutableDictionary dictionary];
        nodeDic = [dataArr[i] mutableCopy];
        [treeNode setTreeNode:nodeDic];
        [self.hotSource addObject:treeNode];
    }
    self.dataSourceArr = self.hotSource;
}

#pragma mark - UICollectionViewDelegateFlowLayout
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    
    CGSize size = CGSizeMake(0, 0);
    
    return size;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsMake(10, 10, 10, 10);
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.hotSource.count;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    ForumReusableView *cell = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerSection forIndexPath:indexPath];
    return cell;
   
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ForumItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"fourmCollection" forIndexPath:indexPath];
    
    TreeViewNode * node;
    
    node = self.hotSource[indexPath.row];
    
    if (node != nil) {
        [cell setInfo:node.infoModel];
    }
    
    return cell;
}

#pragma mark UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    TreeViewNode * node = self.hotSource[indexPath.row];
    [self pushThreadList:node];
    
}

- (void)pushThreadList:(TreeViewNode *)node {

    LianMixAllViewController *foVC = [[LianMixAllViewController alloc] init];
    foVC.forumFid = node.infoModel.fid;
    [self.navigationController pushViewController:foVC animated:YES];
}

- (NSMutableArray<TreeViewNode *> *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (NSMutableArray<TreeViewNode *> *)hotSource {
    if (!_hotSource) {
        _hotSource = [NSMutableArray array];
    }
    return _hotSource;
}

- (NSMutableArray *)dataSourceArr {
    if (!_dataSourceArr) {
        _dataSourceArr = [NSMutableArray array];
    }
    return _dataSourceArr;
}

@end
