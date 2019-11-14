//
//  TPBaseNavigationController.m
//  PandaReader
//
//  Created by WebersonGao on 2019/3/1.
//  Copyright © 2019 comsenz-service.com.  All rights reserved.
//

#import "TPBaseNavigationController.h"
#import "TPBaseViewController.h"

@interface TPBaseNavigationController () <UIGestureRecognizerDelegate>

@end

@implementation TPBaseNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.popGestureEnabled = YES;
    self.interactivePopGestureRecognizer.delegate = self;
    self.navigationBar.hidden = YES;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    
    return [self.topViewController preferredStatusBarStyle];
}

- (BOOL)prefersStatusBarHidden{
    return [self.topViewController prefersStatusBarHidden];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if ([viewController isKindOfClass:[TPBaseViewController class]]) {
        TPBaseViewController *vc = (TPBaseViewController *)viewController;
        if (vc.isHideTabBarWhenPushed) {
            vc.hidesBottomBarWhenPushed = YES;
        }
        
        if (vc.systemNavBarHidden) {
            [super pushViewController:viewController animated:animated];
            return;
        }
    }
    
    if (self.viewControllers.count > 0) {
        if ([viewController isKindOfClass:[TPBaseNavigationBarViewController class]]) {
            TPBaseNavigationBarViewController *baseCtrl = (TPBaseNavigationBarViewController *)viewController;
            if ([baseCtrl respondsToSelector:@selector(tp_BaseControllerClickBackItem)]) {
                [baseCtrl tp_SetNavigationBackItemWithTarget:baseCtrl action:@selector(tp_BaseControllerClickBackItem)];
            }
        }
    }
    
    [super pushViewController:viewController animated:animated];
}

#pragma mark -
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if (!self.popGestureEnabled) {
        return NO;
    }
    
    TPBaseViewController *vc = (TPBaseViewController *)self.topViewController;
    if ([vc isKindOfClass:[TPBaseViewController class]]) {
        return vc.popGestureEnabled;
    }
    
    return self.popGestureEnabled;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return [self gestureRecognizerShouldBegin:gestureRecognizer];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}


@end
