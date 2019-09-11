//
//  InstroductionView.m
//  DiscuzMobile
//
//  Created by HB on 16/12/19.
//  Copyright © 2016年 comsenz-service.com.  All rights reserved.
//

#import "InstroductionView.h"

@interface InstroductionView() <UIScrollViewDelegate>

@property (nonatomic, strong) UIPageControl *pageControl;

@end

@implementation InstroductionView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commitInit];
    }
    return self;
}

- (void)commitInit {
    self.pagingEnabled = YES;
    self.backgroundColor = [UIColor whiteColor];
    self.delegate = self;
    self.showsHorizontalScrollIndicator = NO;
    
}

- (void)setPerpage:(NSMutableArray<UIImage *> *)imageArr {
    self.pageControl.numberOfPages = imageArr.count;
    self.contentSize = CGSizeMake(WIDTH * imageArr.count, HEIGHT);
    for (int i = 0; i < imageArr.count; i ++ ) {
        UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake(i * WIDTH, 0, WIDTH, HEIGHT)];
        imgV.image= imageArr[i];
        if (i == imageArr.count - 1) {
            imgV.userInteractionEnabled = YES;
            UIButton *button = [UIButton buttonWithType:(UIButtonTypeCustom)];
            [button addTarget:self action:@selector(hidInstroduction) forControlEvents:UIControlEventTouchUpInside];
            button.frame = CGRectMake(WIDTH / 2 - 80, HEIGHT - 105, 160, 50);
            [imgV addSubview:button];
            //            button.layer.borderColor = [UIColor redColor].CGColor;
            //            button.backgroundColor = [UIColor redColor];
            //            button.layer.borderWidth = 1.5;
            //            button.layer.cornerRadius = 10;
            //            [button setTitle:@"立即进入" forState:UIControlStateNormal];
            //            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            //            button.titleLabel.font = [UIFont boldSystemFontOfSize:16.0];
        }
        [self addSubview:imgV];
    }
    
}

- (void)hidInstroduction {
    if (self.dismissBlock) {
        self.dismissBlock();
    }
    [UIView animateWithDuration:1 animations:^{
        self.alpha = 0;
        self.pageControl.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        [self.pageControl removeFromSuperview];
    }];
}

- (UIPageControl *)pageControl {
    if (_pageControl == nil) {
        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(WIDTH / 2 - 30, HEIGHT - 40, 60, 30)];
        _pageControl.currentPage = 0;
        _pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
        _pageControl.currentPageIndicatorTintColor = MAIN_COLLOR;
        [[[UIApplication sharedApplication].delegate window] addSubview:_pageControl];
    }
    return _pageControl;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    self.pageControl.currentPage = (NSInteger)(scrollView.contentOffset.x / WIDTH);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/



@end
