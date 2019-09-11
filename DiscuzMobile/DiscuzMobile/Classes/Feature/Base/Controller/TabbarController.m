//
//  TabbarController.m
//  DiscuzMobile
//
//  Created by HB on 16/7/12.
//  Copyright © 2016年 comsenz-service.com. All rights reserved.
//

#import "TabbarController.h"

#import "DiscoverManagerController.h"
#import "ForumManagerController.h"
#import "LoginController.h"
#import "UserController.h"
#import "FastPlaceController.h"
#import "TTSearchController.h"

@interface TabbarController () <UITabBarControllerDelegate>
@property (nonatomic, assign) NSInteger oldSelected;
@property (nonatomic, assign) NSInteger notitySelected;
@property (nonatomic, strong) UIButton *composeButton;
@end

@implementation TabbarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.delegate = self;
    
    
    [self addChildViewControllers];
    
//    [self.tabBar addSubview:self.composeButton];
//    CGFloat b_width = self.tabBar.width / self.childViewControllers.count;
//    CGFloat b_height = self.tabBar.height;
//    self.composeButton.frame = CGRectMake(2 * b_width, 0, b_width, b_height);
//    [self.composeButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(@4);
//        make.height.equalTo(@(b_height));
//        make.width.equalTo(@(b_width));
//    }];

    self.tabBar.tintColor = MAIN_COLLOR;
    self.tabBar.translucent = YES;
//    [[UINavigationBar appearance] setBarTintColor:NAVI_BAR_COLOR];
    self.selectedIndex = 0;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ttsetSelectInex:) name:SETSELECTINDEX object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    if (self.oldSelected == viewController.tabBarItem.tag) { // 双击刷新
        if (viewController.tabBarItem.tag == 0) {
            [[NSNotificationCenter defaultCenter] postNotificationName:TABBARREFRESH object:nil];
        }
    }
    self.oldSelected = viewController.tabBarItem.tag;
    if (viewController.tabBarItem.tag == self.viewControllers.count - 1 || viewController.tabBarItem.tag == 2) {
        if (![LoginModule isLogged]) {
            [self login];
            return NO;
        }
    } else {
        self.notitySelected = viewController.tabBarItem.tag;
    }
    return YES;
}

- (void)ttsetSelectInex:(NSNotification *)notify {
    
    if (notify.userInfo != nil) {
        NSDictionary *userInfo = notify.userInfo;
        if ([[userInfo objectForKey:@"type"] isEqualToString:@"cancel"]) {
            if (self.selectedIndex == self.viewControllers.count - 1) {
                self.selectedIndex = 0;
            }
        } else if ([[userInfo objectForKey:@"type"] isEqualToString:@"loginSuccess"]) {
            self.selectedIndex = self.viewControllers.count - 1;
        }
    } else {
        self.selectedIndex = self.notitySelected;
    }
    self.oldSelected = self.selectedIndex;
}

- (void)login {
    LoginController * lvc = [[LoginController alloc] init];
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:lvc];
    [self presentViewController:nc animated:YES completion:nil];
}

- (void)addChildViewControllers {
    // 国际化方法
    // DLog(@"%@",NSLocaleCountryCode);
    // [self addChildVc:dicoverVC title:NSLocalizedStringFromTable(@"tab1", @"DZLocalized", nil) image:@"homem" selectedImage:@"homes" andTag:0];
    
    DiscoverManagerController *dicoverVC = [[DiscoverManagerController alloc] init];
    ForumManagerController *forumVC = [[ForumManagerController alloc] init];
    UserController *userVC = [[UserController alloc] init];
//    FastPlaceController *fastVC = [[FastPlaceController alloc] init];
//    TTSearchController *searchVC = [[TTSearchController alloc] init];
//    searchVC.type = searchPostionTypeTabbar;
    
    [self addChildVc:dicoverVC title:@"发现" image:@"homem" selectedImage:@"homes"];
    [self addChildVc:forumVC title:@"版块" image:@"forumm" selectedImage:@"fourms"];
//    [self addChildVc:fastVC title:@"" image:@"clarity" selectedImage:@""];
//    [self addChildVc:LiveController title:@"直播" image:@"pl_zhibo" selectedImage:@"pl_zhibos"];
    [self addChildVc:userVC title:@"我的" image:@"my" selectedImage:@"mys"];
}

- (void)addChildVc:(UIViewController *)childVc title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage {
    // 设置子控制器的文字 设置tabbar和navigationBar的文字
    childVc.title = title;
    
    // 设置子控制器的图片
//    childVc.tabBarItem.image = [UIImage imageNamed:image];
    childVc.tabBarItem.image = [[UIImage imageNamed:image] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    childVc.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImage] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    // 设置文字的样式
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName] = DARK_TEXT_COLOR;
    NSMutableDictionary *selectTextAttrs = [NSMutableDictionary dictionary];
    selectTextAttrs[NSForegroundColorAttributeName] = MAIN_COLLOR;
    [childVc.tabBarItem setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
    [childVc.tabBarItem setTitleTextAttributes:selectTextAttrs forState:UIControlStateSelected];
    
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:childVc];
//    if ([title isEqualToString:@"发现"]) {
//        nav = [[PLVNavigationController alloc] initWithRootViewController:childVc];
//    } else {
//        nav = [[UINavigationController alloc] initWithRootViewController:childVc];
//    }
    nav.navigationBar.barTintColor = [UIColor whiteColor];
    
    childVc.tabBarItem.tag = self.viewControllers.count;
    // 添加为子控制器
    [self addChildViewController:nav];
}

- (BOOL)shouldAutorotate {
    return NO;
}

#if __IPHONE_OS_VERSION_MAX_ALLOWED < __IPHONE_9_0
- (NSUInteger)supportedInterfaceOrientations
#else
- (UIInterfaceOrientationMask)supportedInterfaceOrientations
#endif
{
    return UIInterfaceOrientationMaskPortrait;
}

- (UIButton *)composeButton {
    if (!_composeButton) {
        _composeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _composeButton.alpha = 1;
        [_composeButton setImage:[UIImage imageNamed:@"addTz"] forState:UIControlStateNormal];
    }
    return _composeButton;
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
}

@end
