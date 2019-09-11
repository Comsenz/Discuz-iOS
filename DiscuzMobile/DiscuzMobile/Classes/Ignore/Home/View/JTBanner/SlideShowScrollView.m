//
//  SlideShowScrollView.m
//  DiscuzMobile
//
//  Created by HB on 17/1/13.
//  Copyright © 2017年 comsenz-service.com.  All rights reserved.
//

#import "SlideShowScrollView.h"
#import "JTBannerModel.h"
#import "BannerImageView.h"
#import "JudgeImageModel.h"

@implementation SlideShowScrollView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.bannerArray = [NSMutableArray array];
        [self p_setUpView];
        
    }
    return self;
}

- (void)p_setUpView {
    // 取消弹簧效果
    self.bounces = NO;
    // 隐藏指示条
    self.showsHorizontalScrollIndicator = NO;
    // 设置代理
    self.delegate = self;
    // 设置翻页属性
    self.pagingEnabled  = YES;
    
    _pageControl = [[UIPageControl alloc] init];
//    _pageControl.currentPageIndicatorTintColor = [UIColor colorWithWhite:0.99 alpha:0.95];
    
    _pageControl.currentPageIndicatorTintColor = mRGBColor(28, 183, 255);
    _pageControl.pageIndicatorTintColor = mRGBColor(160, 160, 160);;
    
    _pageControl.currentPage = 0;
}

- (void)setAddsPicture {
    
    [_pageControl removeFromSuperview];
    // 需要将幻灯和pageControl放在同一个容器里
    _pageControl.frame = CGRectMake(WIDTH  - 60, CGRectGetHeight(self.frame) - 25, 55, 10);
    _pageControl.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.7, 0.7);
    if (_pageControl.hidden == YES) {
        self.showsHorizontalScrollIndicator = YES;
    }
    
    [self removeTimer];
    
    if (_isPlaceholder) {
        
        BannerImageView *placeholderV = [[BannerImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame) - 6)];
        placeholderV.image = [UIImage imageNamed:@"wutu"];
        [self addSubview:placeholderV];
        placeholderV.bgView.hidden = YES;
        return;
    }
    
    if (self.bannerArray.count == 0) {
        return;
    }
    
    [self.superview addSubview:_pageControl];
    self.contentSize = CGSizeMake(CGRectGetWidth(self.frame) * (self.bannerArray.count + 2), 0);
    UITapGestureRecognizer *tap =  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    self.pageControl.numberOfPages = self.bannerArray.count;
    
    BannerImageView *v1 = [self imageViewWithIndex:-1];
    [self addSubview:v1];
    
    for (int i = 0; i < self.bannerArray.count; i++) {
        
        BannerImageView *temp = [self imageViewWithIndex:i];
        temp.titleLabel.text = self.bannerArray[i].title;
        [self addSubview:temp];
    }
    
    BannerImageView *v2 = [self imageViewWithIndex:self.bannerArray.count];
    [self addSubview:v2];
    
    [self addGestureRecognizer:tap];
    
    self.contentOffset = CGPointMake(CGRectGetWidth(self.frame), 0);
    
    if (self.bannerArray.count > 1) {
        [self addTimer];
    }
}

- (BannerImageView *)imageViewWithIndex:(NSInteger)index {
    
    BannerImageView *temp = [[BannerImageView alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.frame) * (index + 1), 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame) - 6)];
    
    NSInteger bannerIndex = [self bannerOfIndex:index];
    
    NSString *tempStr;
    tempStr = [self.bannerArray[bannerIndex].imageurl makeDomain];

    temp.titleLabel.text = self.bannerArray[bannerIndex].title;
    
    if ([JudgeImageModel graphFreeModel] == NO) {
        [temp sd_setImageWithURL:[NSURL URLWithString:tempStr] placeholderImage:[UIImage imageNamed:@"wutu"] options:SDWebImageRetryFailed];
    } else {
        temp.image = [UIImage imageNamed:@"wutu"];
    }
    [self addSubview:temp];
    
    return temp;
}

- (NSInteger)bannerOfIndex:(NSInteger)index {
    if (index == self.bannerArray.count) {
        return 0;
    } else if (index == -1) {
        return self.bannerArray.count - 1;
    } else {
        return index;
    }
}

// 关闭定时器
- (void)removeTimer {
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

//  添加定时器
- (void)addTimer {
    if (!self.timer) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:TIME * 5 target:self selector:@selector(nextImage) userInfo:nil repeats:YES];
        // 不用scheduled方式初始化的，需要手动addTimer:forMode: 将timer添加到一个runloop中。而scheduled的初始化方法将以默认mode直接添加到当前的runloop中.
//        [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
    }
}

// 定时器方法
- (void)nextImage {
    
    //判断当前的view是否与窗口重合 判断window是否在窗口上
    if (![self hu_intersectsWithAnotherView:nil]) {
        return;
    }
    int page = (int)self.pageControl.currentPage + 1; // page表示scrollview中的第几张图片，从第0张开始，一共（count + 1）张
    self.isTimer = YES;
    [UIView animateWithDuration:0.5 animations:^{
        self.contentOffset = CGPointMake((page + 1 ) * CGRectGetWidth(self.frame), 0);
    } completion:^(BOOL finished) {
        self.isTimer = NO;
    }];
    if (page == self.bannerArray.count) {//scrollview中的倒数第二张，也就是数组中的最后一张，滚动到第一张的位置
        self.contentOffset = CGPointMake(CGRectGetWidth(self.frame), 0);
    }
}

#pragma mark - UIScrollViewDelegate 代理方法

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    // 判断是tableView滚动
    if ([scrollView isKindOfClass:[UITableView class]]) {
        return;
    }
    if (self.bannerArray.count == 0) {
        return;
    }
    
    // 设置当前页数
    self.pageControl.currentPage = (NSInteger)(self.contentOffset.x / CGRectGetWidth(self.frame)) - 1;
    
    // 设置轮播效果
    if (self.contentOffset.x == 0) {
        _pageControl.currentPage = self.pageControl.numberOfPages;
         self.contentOffset = CGPointMake(CGRectGetWidth(self.frame) * self.bannerArray.count, 0);
        
    }
    if (self.contentOffset.x >= CGRectGetWidth(self.frame) * (self.bannerArray.count + 1)) {
        if (self.isTimer == YES) {
            self.isTimer = NO;
            return;
        }
        _pageControl.currentPage = 0;
        self.contentOffset = CGPointMake(CGRectGetWidth(self.frame), 0);
        
    }
    
}
// 将要结束拖拽时添加定时器
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    // 判断是tableView滚动
    if ([scrollView isKindOfClass:[UITableView class]]) {
        return;
    }
    if (self.bannerArray.count > 1) {
        
        [self addTimer];
    }
}

// 如果开始拖拽视图的时候停止定时器
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    // 判断是tableView滚动
    if ([scrollView isKindOfClass:[UITableView class]]) {
        // 返回
        return;
    }
    [self removeTimer];
}

// 点击图片响应事件
- (void)tapAction {
    
    if (self.touchBlock != nil) {
        self.touchBlock(_pageControl.currentPage);
    }
}

- (void)touchInSlideShow:(TouchBlock)block {
    if (block != nil) {
        self.touchBlock = block;
    }
    
}
@end
