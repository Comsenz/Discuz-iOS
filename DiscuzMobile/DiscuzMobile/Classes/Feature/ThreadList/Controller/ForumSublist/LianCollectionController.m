//
//  LianCollectionController.m
//  DiscuzMobile
//
//  Created by HB on 2017/5/19.
//  Copyright © 2017年 comsenz-service.com.  All rights reserved.
//

#import "LianCollectionController.h"
#import "FListController.h"
#import "LianMixAllViewController.h"

@interface LianCollectionController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, assign) NSInteger selectIndex;

@end

@implementation LianCollectionController

- (void)setParentControl:(UIViewController *)parentController {
    
    self.parentController = parentController;
    
    LianMixAllViewController *bdVC = (LianMixAllViewController *)self.parentController;
    self.collectonView.bounces = NO;
    [bdVC addChildViewController:self];
    [bdVC.contentView addSubview:self.view];
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
        make.edges.mas_equalTo(UIEdgeInsetsMake(5, 0, -5, 0));
    }];
    return cell;
}

- (void)setChildCanScroll:(BOOL)childCanScroll {
    //修改所有的子控制器的状态
    for (LianBaseTableController *ctrl in self.viewControllers) {
        ctrl.canScroll = childCanScroll;
    }
}

#pragma mark - collectionView delegate
// 这里覆盖了父类的方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSInteger index = scrollView.contentOffset.x / self.collectonView.frame.size.width;
    [self.segmentedControl  setSelectedSegmentIndex:index];
    
    [(LianMixAllViewController *)self.parentController setSelectIndex:index];
    DLog(@"===================%ld=====================",index);
    if (self.selectIndex != index) {
        self.selectIndex = index;
        // 延迟0.03秒执行 为了界面滑动流畅啊！！！！
        [self performSelector:@selector(threadListFirstRequest) withObject:nil afterDelay:0.03];
    }
}

// 通知方法
- (void)threadListFirstRequest {
    [[NSNotificationCenter defaultCenter] postNotificationName:THREADLISTFISTREQUEST object:nil userInfo:@{@"selectIndex":[NSNumber numberWithInteger:self.selectIndex]}];
}

// 防止拖动collection的时候，tableview乱动
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [(LianMixAllViewController *)self.parentController setScrollEnable:NO];
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    
    [(LianMixAllViewController *)self.parentController setScrollEnable:YES];
}

// 这里不能少， 不能用super方法，不让页面布局错乱
- (void)setSelectedAtIndex:(NSInteger)selectedIndex {
    CGFloat offsetX = self.collectonView.frame.size.width * selectedIndex;
    self.collectonView.contentOffset = CGPointMake(offsetX, 0);
}

@end
