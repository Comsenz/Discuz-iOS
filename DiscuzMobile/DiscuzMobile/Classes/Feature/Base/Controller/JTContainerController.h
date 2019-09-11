//
//  TTContainerController.h
//  DiscuzMobile
//
//  Created by ZhangJitao on 16/4/23.
//  Copyright © 2016年 Cjk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HMSegmentedControl.h"

@interface JTContainerController : UIViewController<UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic,strong) UIColor *navigotionBarBackgroundColor;
@property (nonatomic, assign) BOOL sendNotify;

@property (nonatomic, weak) UIViewController *parentController;
@property (strong, nonatomic) NSArray *viewControllers;
@property (nonatomic,weak) UICollectionView *collectonView;
@property (nonatomic,weak) UICollectionViewFlowLayout *flowLayout;
@property (strong, nonatomic) HMSegmentedControl *segmentedControl;

- (void)setSubControllers:(NSArray<UIViewController *>*)viewControllers parentController:(UIViewController *)vc andSegmentRect:(CGRect)segmentRect;

@end
