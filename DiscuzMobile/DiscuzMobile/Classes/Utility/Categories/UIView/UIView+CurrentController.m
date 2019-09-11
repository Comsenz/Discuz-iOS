//
//  UIView+CurrentController.m
//  DiscuzMobile
//
//  Created by ZhangJitao on 2018/11/23.
//  Copyright © 2018年 Cjk. All rights reserved.
//

#import "UIView+CurrentController.h"
#import "UIView+Extension.h"

@implementation UIView (CurrentController)

//获取当前屏幕显示的viewcontroller
+ (UIViewController*)getCurrentUIVC {
    __block UIViewController   *cv;
    UINavigationController  *na = (UINavigationController*)[[self class] getCurrentNaVC];
    if ([na isKindOfClass:[UINavigationController class]]) {
        cv =  na.viewControllers.lastObject;
        if (cv.childViewControllers.count>0) {
            
            cv = [[self class] getSubUIVCWithVC:cv];
        }
    } else {
        cv = (UIViewController*)na;
    }
    return cv;
}

+ (UINavigationController*)getCurrentNaVC {
    UIViewController  *viewVC = (UIViewController*)[ self getCurrentWindowVC];
    UINavigationController  *naVC;
    if ([viewVC isKindOfClass:[UITabBarController class]]) {
        UITabBarController  *tabbar = (UITabBarController*)viewVC;
        naVC = (UINavigationController *)tabbar.viewControllers[tabbar.selectedIndex];
        if (naVC.presentedViewController) {
            while (naVC.presentedViewController) {
                naVC = (UINavigationController*)naVC.presentedViewController;
            }
        }
    }else
        if ([viewVC isKindOfClass:[UINavigationController class]]) {
            
            naVC  = (UINavigationController*)viewVC;
            if (naVC.presentedViewController) {
                while (naVC.presentedViewController) {
                    naVC = (UINavigationController*)naVC.presentedViewController;
                }
            }
        }else
            if ([viewVC isKindOfClass:[UIViewController class]])
            {
                if (viewVC.navigationController) {
                    return viewVC.navigationController;
                }
                return  (UINavigationController*)viewVC;
            }
    return naVC;
}


+(UIViewController*)getCurrentWindowVC {
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    //app默认windowLevel是UIWindowLevelNormal，如果不是，找到它
    if (window.windowLevel != UIWindowLevelNormal) {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows) {
            if (tmpWin.windowLevel == UIWindowLevelNormal) {
                window = tmpWin;
                break;
            }
        }
    }
    id nextResponder = nil;
    UIViewController *appRootVC = window.rootViewController;
    //1、通过present弹出VC，appRootVC.presentedViewController不为nil
    if (appRootVC.presentedViewController) {
        nextResponder = appRootVC.presentedViewController;
    }else{
        //2、通过navigationcontroller弹出VC
        //        NSLog(@"subviews == %@",[window subviews]);
        UIView *frontView = [[window subviews] objectAtIndex:0];
        nextResponder = [frontView nextResponder];
    }
    return nextResponder;
}

+ (UIViewController *)getSubUIVCWithVC:(UIViewController*)vc {
    __block UIViewController  *cv;
    
    [vc.childViewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.view hu_intersectsWithAnotherView:nil]) {
            cv =  obj;
        }
    }];
    if (cv.childViewControllers.count > 0) {
        return [[self class] getSubUIVCWithVC:cv];
    }
    else {
        return cv;
    }
}


@end
