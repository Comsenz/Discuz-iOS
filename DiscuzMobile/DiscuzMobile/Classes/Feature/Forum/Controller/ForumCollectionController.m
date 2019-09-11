//
//  ForumCollectionController.m
//  DiscuzMobile
//
//  Created by HB on 17/5/2.
//  Copyright © 2017年 comsenz-service.com.  All rights reserved.
//

#import "ForumCollectionController.h"
#import "TreeViewNode.h"

#import "ForumItemCell.h"
#import "ForumReusableView.h"
#import "ForumManagerController.h"
#import "LianMixAllViewController.h"
#import "AsyncAppendency.h"

@interface ForumCollectionController () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSMutableArray<TreeViewNode *> *dataSourceArr;

@property (nonatomic, strong) NSString *currentType;

@end

@implementation ForumCollectionController


static NSString *CellID = @"fourmCollection";
static NSString * headerSection = @"CellHeader";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.currentType = self.type == Forum_hot ? @"hotforum" : @"forumindex";
    
    [self initCollectionView];
    
    [self cacheRequest];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refresh) name:TABBARREFRESH object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadImage) name:IMAGEORNOT object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshData) name:DOMAINCHANGE object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)refresh {
    if ([self viewIsShow]) {
        // 刷新
        [self.collectionView.mj_header beginRefreshing];
    }
}

- (void)refreshData {
    // 刷新
    [self loadData:self.currentType andLoadType:JTRequestTypeRefresh];
}

- (void)reloadImage {
    [self.collectionView reloadData];
}

- (BOOL)viewIsShow {
    //判断window是否在窗口上
    if (self.view.window == nil) {
        return NO;
    }
    //判断当前的view是否与窗口重合
    if (![self.view hu_intersectsWithAnotherView:nil]) {
        return NO;
    }
    
    return YES;
}

- (void)initCollectionView {
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    flowLayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    flowLayout.minimumLineSpacing = 10;
    flowLayout.minimumInteritemSpacing = 4;
//    flowLayout.itemSize = CGSizeMake((WIDTH - 18 - 18) / 3, WIDTH / 3 + 52);
    flowLayout.itemSize = CGSizeMake((WIDTH - 20 - 20) / 3, WIDTH / 3 + 40);
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT) collectionViewLayout:flowLayout];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    [self.collectionView registerClass:[ForumItemCell class] forCellWithReuseIdentifier:CellID];
    [self.collectionView registerClass:[ForumReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerSection];
    
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    [self.view addSubview:self.collectionView];
    
    WEAKSELF;
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf loadData:weakSelf.currentType andLoadType:JTRequestTypeRefresh];
    }];
}

- (void)cacheRequest {
    [self.HUD showLoadingMessag:@"正在刷新" toView:self.view];
    [self loadData:self.currentType andLoadType:JTRequestTypeCache]; // 读缓存，没有缓存的话自己会请求网络
    NSString *urlStr = self.type == Forum_hot ? url_Hotforum : url_Forumindex;
    if ([JTRequestManager isCache:urlStr andParameters:nil]) { // 缓存有的话，要刷新一次。缓存没有的话，不请求了，上面那个方法已经请求了
        [self loadData:self.currentType andLoadType:JTRequestTypeRefresh];
    }
}

- (void)loadData:(NSString *)forumType andLoadType:(JTLoadType)type {
    
    [DZApiRequest requestWithConfig:^(JTURLRequest *request) {
        
        request.urlString = (self.type == Forum_hot) ? url_Hotforum : url_Forumindex;
        request.isCache = YES;
        request.loadType = type;
        
    } success:^(id responseObject, JTLoadType type) {
        [self.HUD hide];
        [self.collectionView.mj_header endRefreshing];
        
        if (self.type == Forum_hot) {
            [self setHotData:responseObject];
            
        } else {
            
            [self setForumList:responseObject];
        }
        [self.collectionView reloadData];
        [self emptyShow];
        
    } failed:^(NSError *error) {
        [self.HUD hide];
        [self showServerError:error];
        [self.collectionView.mj_header endRefreshing];
        [self emptyShow];
    }];
}

//  处理热门版块数据
- (void)setHotData:(id)responseObject {
    self.dataSourceArr = [NSMutableArray arrayWithArray:[TreeViewNode setHotData:responseObject]];
}

// 处理全部版块数据
- (void)setForumList:(id)responseObject {
    self.dataSourceArr = [NSMutableArray arrayWithArray:[TreeViewNode setAllforumData:responseObject]];
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

#pragma mark - UICollectionViewDelegateFlowLayout
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    
    CGSize size = CGSizeMake(0, 0);
    if (self.type == Forum_index) {
        size = CGSizeMake(WIDTH, 54);
    }
    return size;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    if (self.type == Forum_index) {
        if (!self.dataSourceArr[section].isExpanded)  {
            return UIEdgeInsetsMake(0, 10, 0, 10);
        }
    }
    return UIEdgeInsetsMake(10, 10, 10, 10);
}


#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    if (self.type == Forum_index)  {
        return self.dataSourceArr.count;
    }
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.type == Forum_index)  {
        if (self.dataSourceArr[section].isExpanded) {
            return self.dataSourceArr[section].nodeChildren.count;
        }
        return 0;
    }
    return self.dataSourceArr.count;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    ForumReusableView *cell = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerSection forIndexPath:indexPath];
    if (self.type == Forum_index) {
        cell.tag = indexPath.section;
        UITapGestureRecognizer *tapG = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didSelectHeaderWithSection:)];
        [cell addGestureRecognizer:tapG];
        cell.node = self.dataSourceArr[indexPath.section];
        
    }
    return cell;
   
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ForumItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"fourmCollection" forIndexPath:indexPath];
    
    TreeViewNode * node;
    if (self.type == Forum_index) {
        node = self.dataSourceArr[indexPath.section].nodeChildren[indexPath.row];
    } else {
        node = self.dataSourceArr[indexPath.row];
    }
    if (node != nil) {
        [cell setInfo:node.infoModel];
    }
    
    return cell;
}

#pragma mark UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    TreeViewNode * node;
    if (self.type == Forum_index) {
        node = self.dataSourceArr[indexPath.section].nodeChildren[indexPath.row];
        
    } else {
        node = self.dataSourceArr[indexPath.row];
    }
    [self pushThreadList:node];
}

- (void)pushThreadList:(TreeViewNode *)node {

    LianMixAllViewController *foVC = [[LianMixAllViewController alloc] init];
    foVC.forumFid = node.infoModel.fid;
    [self.navigationController pushViewController:foVC animated:YES];
}

- (void)didSelectHeaderWithSection:(UITapGestureRecognizer *)sender {
    if (self.type == Forum_index) {
        TreeViewNode *node = self.dataSourceArr[sender.view.tag];
        node.isExpanded = !node.isExpanded;
        [self.collectionView reloadData];
    }
}

- (NSMutableArray *)dataSourceArr {
    if (!_dataSourceArr) {
        _dataSourceArr = [NSMutableArray array];
    }
    return _dataSourceArr;
}

@end
