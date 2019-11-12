//
//  TPBaseViewController.m
//  PandaReader
//
//  Created by WebersonGao on 2019/2/28.
//  Copyright © 2019 comsenz-service.com.  All rights reserved.
//

#import "TPBaseViewController.h"

@interface TPBaseViewController ()


@end

@implementation TPBaseViewController

- (instancetype)init {
    if (self = [super init]) {
        _isHideTabBarWhenPushed = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configBaseViewController];
    self.view.backgroundColor = KColor(KFFFFFF_Color, 1.0);
    [self.view setExclusiveTouch:YES];
}

-(void)configBaseViewController{
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self updateSystemNavBarHiddenWhenViewWillAppear];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

#pragma mark - system NavBar
- (BOOL)autoSettingSystemNavBarHidden {
    return YES;
}

- (BOOL)systemNavBarHidden {
    return NO;
}

- (BOOL)popGestureEnabled {
    return YES;
}

#pragma mark -
- (void)updateSystemNavBarHiddenWhenViewWillAppear {
    if (!self.autoSettingSystemNavBarHidden) {
        return;
    }
    
    if (self.isHiddenNavigationBar != self.systemNavBarHidden) {
        self.isHiddenNavigationBar = self.systemNavBarHidden;
    }
}

#pragma mark  -- define NavBar


@end
