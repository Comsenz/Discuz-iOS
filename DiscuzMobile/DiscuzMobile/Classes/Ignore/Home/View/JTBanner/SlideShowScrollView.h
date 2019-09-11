//
//  SlideShowScrollView.h
//  DiscuzMobile
//
//  Created by HB on 17/1/13.
//  Copyright © 2017年 comsenz-service.com.  All rights reserved.
//

#import <UIKit/UIKit.h>
@class JTBannerModel;


typedef void(^TouchBlock)(NSInteger currentPage);

@interface SlideShowScrollView : UIScrollView <UIScrollViewDelegate>

@property (nonatomic, assign) BOOL isPlaceholder;

// 页面控制器
@property (nonatomic,strong) UIPageControl *pageControl;
// 定时器
@property (nonatomic,strong) NSTimer *timer;
// 图片的URL字符串
@property (nonatomic,strong) NSMutableArray<JTBannerModel *> *bannerArray;
// 是否定时
@property (nonatomic,assign) BOOL isTimer;

@property (nonatomic,copy) TouchBlock touchBlock;

- (void)setAddsPicture;

- (void)touchInSlideShow:(TouchBlock)block;

- (void)removeTimer;
- (void)addTimer;

@end
