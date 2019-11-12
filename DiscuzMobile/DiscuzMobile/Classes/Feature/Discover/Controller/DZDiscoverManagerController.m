//
//  DZDiscoverManagerController.m
//  DiscuzMobile
//
//  Created by HB on 2017/5/4.
//  Copyright © 2017年 comsenz-service.com.  All rights reserved.
//

#import "DZDiscoverManagerController.h"
#import "DZContainerController.h"
#import "RecommendController.h"
#import "DigestListController.h"
#import "NewestListController.h"
#import "FootmarkController.h"
#import "DZSettingController.h"

@interface DZDiscoverManagerController ()

@property (nonatomic, strong) NSMutableArray *controllerArr;
@property (nonatomic, strong) DZContainerController *rootVC;

@end

@implementation DZDiscoverManagerController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configNaviBar];
    [self configDiscoverPageView];
}

-(void)configNaviBar {
    [self createBarBtn:@"setting" type:NavItemImage Direction:NavDirectionLeft];
    [self createBarBtn:@"bar_search" type:NavItemImage Direction:NavDirectionRight];
}

- (void)configDiscoverPageView {
    
    [self addItemClass:[RecommendController class] andTitle:@"推荐"];
    [self addItemClass:[NewestListController class] andTitle:@"最新"];
    [self addItemClass:[DigestListController class] andTitle:@"精华"];
    
    CGRect segmentRect = CGRectMake(0, 0, KScreenWidth, 44);
    self.rootVC = [[DZContainerController alloc] init];
    self.rootVC.sendNotify = YES;
    [self.rootVC setSubControllers:self.controllerArr parentController:self andSegmentRect:segmentRect];
}

- (void)addItemClass:(Class)class andTitle:(NSString *)title {
    UIViewController *vc = [class new];
    vc.title = title;
    [self.controllerArr addObject:vc];
}

- (void)leftBarBtnClick {
    DZSettingController *setVC = [[DZSettingController alloc] init];
    [self showViewController:setVC sender:nil];
}

- (void)rightBarBtnClick {
    [[DZMobileCtrl sharedCtrl]PushToSearchController];
}

- (NSMutableArray *)controllerArr {
    if (_controllerArr == nil) {
        _controllerArr = [NSMutableArray array];
    }
    return _controllerArr;
}

@end
