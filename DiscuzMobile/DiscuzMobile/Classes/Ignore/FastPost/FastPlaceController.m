//
//  FastPlaceController.m
//  DiscuzMobile
//
//  Created by ZhangJitao on 2018/7/18.
//  Copyright © 2018年 comsenz-service.com.  All rights reserved.
//

#import "FastPlaceController.h"
#import "FastPostController.h"
#import "UIImageView+FindHairline.h"

@interface FastPlaceController ()

@property (nonatomic, strong) UIImageView *navBarHairlineImageView;
@property (nonatomic, strong) FastPostController *listVc;
@property (nonatomic, strong) UINavigationController *navVC;

@end

@implementation FastPlaceController

- (void)viewWillDisappear:(BOOL)animated {
    _navBarHairlineImageView.hidden = NO;
    [super viewWillDisappear:animated];
}

- (void)viewWillAppear:(BOOL)animated {
    _navBarHairlineImageView.hidden = YES;
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self presentViewController:self.navVC animated:NO completion:nil];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _navBarHairlineImageView = [UIImageView findHairlineImageViewUnder:self.navigationController.navigationBar];
    [self createBarBtn:@"" type:NavItemText Direction:NavDirectionLeft];
    
    self.listVc.tabbarHeight = self.tabbarHeight;
}

- (FastPostController *)listVc {
    if (!_listVc) {
        _listVc = [[FastPostController alloc] init];
    }
    return _listVc;
}

- (UINavigationController *)navVC {
    if (!_navVC) {
        _navVC = [[UINavigationController alloc] initWithRootViewController:self.listVc];
    }
    return _navVC;
}

@end
