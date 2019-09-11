//
//  CountRootController.m
//  DiscuzMobile
//
//  Created by HB on 2017/7/12.
//  Copyright © 2017年 comsenz-service.com.  All rights reserved.
//

#import "CountRootController.h"
#import "XinGeCenter.h"

@interface CountRootController ()

@end

@implementation CountRootController

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark - 请求成功操作
- (void)setUserInfo:(id)responseObject {
    [LoginModule loginAnylyeData:responseObject andView:self.view andHandle:^{ // 登录成功操作
        [[XinGeCenter shareInstance] setXG]; // 设置信鸽推送
        
        [[NSNotificationCenter defaultCenter] postNotificationName:LOGINEDREFRESHGETINFO object:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:REFRESHCENTER object:nil]; // 获取资料
        [[NSNotificationCenter defaultCenter] postNotificationName:COLLECTIONFORUMREFRESH object:nil]; // 板块列表刷新
        [self dismissViewControllerAnimated:YES completion:nil];
        
        UITabBarController *tabbBarVC = (UITabBarController *)[[UIApplication sharedApplication].delegate window].rootViewController;
        UINavigationController *navVC = tabbBarVC.childViewControllers[tabbBarVC.selectedIndex];
        if (navVC.childViewControllers.count == 1 && !self.isKeepTabbarSelected) {
            NSDictionary *userInfo = @{@"type":@"loginSuccess"};
            [[NSNotificationCenter defaultCenter] postNotificationName:SETSELECTINDEX object:nil userInfo:userInfo];
        }
    }];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}

- (SeccodeverifyView *)verifyView {
    if (!_verifyView) {
        _verifyView = [[SeccodeverifyView alloc] init];
    }
    return _verifyView;
}

@end
