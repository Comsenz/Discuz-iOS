//
//  TTContainerController.m
//  DiscuzMobile
//
//  Created by ZhangJitao on 16/4/23.
//  Copyright © 2016年 Cjk. All rights reserved.
//

#import "JTContainerController.h"

@interface JTContainerController()

@property (nonatomic, strong) NSMutableArray *titleArray;
@property (nonatomic, assign) NSInteger selectIndex;

@end

@implementation JTContainerController

#pragma mark - init

- (instancetype)init {
    
    if (self = [super init]) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _flowLayout = flowLayout;
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        flowLayout.minimumLineSpacing = 0;
        flowLayout.minimumInteritemSpacing = 0;
        
        //设置collectionView的属性
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:flowLayout];
        collectionView.pagingEnabled = YES;
        collectionView.showsHorizontalScrollIndicator = NO;
        collectionView.allowsSelection = NO;
        //禁用滚动到最顶部的属性
        collectionView.scrollsToTop = NO;
        collectionView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        
        _collectonView = collectionView;
        [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([self class])];
        collectionView.delegate = self;
        collectionView.dataSource = self;
        
        [self.view addSubview:collectionView];
    }
    return self;
}

- (void)setParentControl:(UIViewController *)parentController {
    if (_parentController == nil) {
        _parentController = parentController;
        [parentController addChildViewController:self];
        [parentController.view addSubview:self.view];
        self.view.frame = CGRectMake(0, 0, parentController.view.width, parentController.view.height);
    }
}

- (void)setSubControllers:(NSArray<UIViewController *>*)viewControllers parentController:(UIViewController *)vc andSegmentRect:(CGRect)segmentRect {
    
    [self setViewControllers:viewControllers];
    [self setParentControl:vc];
    
    if (viewControllers.count > 0) {
        [self.titleArray removeAllObjects];
        if (self.childViewControllers.count > 0) {
            [self.childViewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [obj.view removeFromSuperview];
                [obj removeFromParentViewController];
            }];
            self.segmentedControl = nil;
        }
        
        [viewControllers enumerateObjectsUsingBlock:^(UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            [self addChildViewController:obj];
            [self.titleArray addObject:obj.title ? : @""];
        }];
    }
    
    [self.view addSubview:self.segmentedControl];
    self.segmentedControl.frame = CGRectMake(0, CGRectGetMinY(segmentRect), segmentRect.size.width, segmentRect.size.height);
    [self.segmentedControl setSectionTitles:self.titleArray.copy];
    
    
    CGFloat height = HEIGHT;
    CGFloat navMaxY = CGRectGetMaxY(self.navigationController.navigationBar.frame);
    CGFloat tabbarHeight = CGRectGetHeight(self.tabBarController.tabBar.frame);
    if (self.navigationController) {
        height -= navMaxY;
    }
    if (vc.navigationController.viewControllers.count == 1) {
        height -= tabbarHeight;
    }
    
    self.collectonView.frame = CGRectMake(0, CGRectGetMaxY(segmentRect), WIDTH, height - CGRectGetMaxY(segmentRect));
    self.flowLayout.itemSize = self.collectonView.bounds.size;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
}

#pragma mark - collectionView datasource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.viewControllers.count;
}

- (void)setNavigotionBarBackgroundColor:(UIColor *)navigotionBarBackgroundColor {
    [self.segmentedControl setBackgroundColor:navigotionBarBackgroundColor];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([self class]) forIndexPath:indexPath];
    [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    UIView *view = [self.viewControllers[indexPath.item] view];
    [cell.contentView addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        if ([DataCheck isValidArray:self.viewControllers] && self.viewControllers.count > 1) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(5, 0, 0, 0));
        } else {
            make.edges.equalTo(cell.contentView);
        }
    }];
    return cell;
}

#pragma mark - collectionView delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSInteger index = scrollView.contentOffset.x / self.view.bounds.size.width;
    [self.segmentedControl  setSelectedSegmentIndex:index];
    if (self.sendNotify) {
        if (self.selectIndex != index) {
            // 延迟0.03秒执行 为了界面滑动流畅啊！！！！
            [self performSelector:@selector(firstRequest) withObject:nil afterDelay:0.03];
        }
    }
    self.selectIndex = index;
}

// 通知方法
- (void)firstRequest {
    [[NSNotificationCenter defaultCenter] postNotificationName:JTCONTAINERQUEST object:nil userInfo:@{@"selectIndex":[NSNumber numberWithInteger:self.selectIndex]}];
}

#pragma mark - setting
- (void)setSelectedAtIndex:(NSInteger)selectedIndex {
    
    CGFloat offsetX = self.view.bounds.size.width * selectedIndex;
    self.collectonView.contentOffset = CGPointMake(offsetX, 0);
}

#pragma mark - getting
- (NSMutableArray *)titleArray {
    if (!_titleArray) {
        _titleArray = [NSMutableArray array];
    }
    return _titleArray;
}

- (HMSegmentedControl *)segmentedControl {
    if (_segmentedControl == nil) {
        _segmentedControl = [[HMSegmentedControl alloc] initWithSectionTitles:self.titleArray.copy];
        _segmentedControl.borderType = HMSegmentedControlBorderTypeBottom | HMSegmentedControlBorderTypeTop;
        _segmentedControl.borderColor = LINE_COLOR;
        _segmentedControl.borderWidth = 0.5;
        [_segmentedControl setSelectionIndicatorColor:MAIN_COLLOR];
        [_segmentedControl setSelectionIndicatorHeight:2.0];
        [_segmentedControl setBackgroundColor:[UIColor whiteColor]];
        _segmentedControl.segmentWidthStyle = HMSegmentedControlSegmentWidthStyleFixed;
        _segmentedControl.selectionStyle = HMSegmentedControlSelectionStyleTextWidthMorelittle;
        _segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
        
        CGFloat minsize = 16.0;
        CGFloat maxsize = 17.0;
        CGFloat  space = (self.viewControllers.count <= 4) ? 0 : 16;
        _segmentedControl.segmentEdgeInset = UIEdgeInsetsMake(0, space, 0, space);
        [_segmentedControl setTitleFormatter:^NSAttributedString *(HMSegmentedControl *segmentedControl, NSString *title, NSUInteger index, BOOL selected) {
            NSAttributedString *attString = [[NSAttributedString alloc] init];
            attString = [[NSAttributedString alloc] initWithString:title attributes:@{NSForegroundColorAttributeName : LIGHT_TEXT_COLOR,NSFontAttributeName:[FontSize SlideTitleFontSize:minsize andIsBold:NO]}];
            if (selected) {
                attString = [[NSAttributedString alloc] initWithString:title attributes:@{NSForegroundColorAttributeName : MAIN_COLLOR,NSFontAttributeName:[FontSize SlideTitleFontSize:maxsize andIsBold:YES]}];
            }
            return attString;
        }];
        
        WEAKSELF;
        [_segmentedControl setIndexChangeBlock:^(NSInteger index) {
            [weakSelf setSelectedAtIndex:index];
        }];
        
        [_segmentedControl setSelectedSegmentIndex:self.selectIndex];
    }
    return _segmentedControl;
}

@end
