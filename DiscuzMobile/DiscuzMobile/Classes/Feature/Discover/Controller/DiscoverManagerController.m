//
//  DiscoverManagerController.m
//  DiscuzMobile
//
//  Created by HB on 2017/5/4.
//  Copyright © 2017年 comsenz-service.com.  All rights reserved.
//

#import "DiscoverManagerController.h"
#import "JTContainerController.h"
#import "RecommendController.h"
#import "LiveController.h"
#import "DigestListController.h"
#import "NewestListController.h"
#import "FootmarkController.h"
#import "LoginController.h"
#import "TTSearchController.h"
#import "SettingViewController.h"

@interface DiscoverManagerController ()

@property (nonatomic, strong) NSMutableArray *controllerArr;
@property (nonatomic, strong) JTContainerController *rootVC;

@end

@implementation DiscoverManagerController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavc];
    [self setPageView];
}

-(void)setNavc {
    [self createBarBtn:@"setting" type:NavItemImage Direction:NavDirectionLeft];
    [self createBarBtn:@"bar_search" type:NavItemImage Direction:NavDirectionRight];
}

- (void)setPageView {
    
//    [self addItemClass:[RecommendController class] andTitle:@"推荐"];
//#if Jinbifun
//#else
//    [self addItemClass:[LiveController class] andTitle:@"直播"];
//#endif
    [self addItemClass:[NewestListController class] andTitle:@"最新"];
    [self addItemClass:[DigestListController class] andTitle:@"精华"];
    
    CGRect segmentRect = CGRectMake(0, 0, WIDTH, 44);
    self.rootVC = [[JTContainerController alloc] init];
    self.rootVC.sendNotify = YES;
    [self.rootVC setSubControllers:self.controllerArr parentController:self andSegmentRect:segmentRect];
}

- (void)addItemClass:(Class)class andTitle:(NSString *)title {
    UIViewController *vc = [class new];
    vc.title = title;
    [self.controllerArr addObject:vc];
}

- (void)leftBarBtnClick {
    SettingViewController *setVC = [[SettingViewController alloc] init];
    [self showViewController:setVC sender:nil];
}

- (void)rightBarBtnClick {
    TTSearchController *searchVC = [[TTSearchController alloc] init];
    searchVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:searchVC animated:YES];
}

- (NSMutableArray *)controllerArr {
    if (_controllerArr == nil) {
        _controllerArr = [NSMutableArray array];
    }
    return _controllerArr;
}

@end
