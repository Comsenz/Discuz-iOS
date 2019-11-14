//
//  TPBaseViewController.h
//  PandaReader
//
//  Created by WebersonGao on 2019/2/28.
//  Copyright © 2019 comsenz-service.com.  All rights reserved.
//

#import "TPBaseNavigationBarViewController.h"

static NSInteger TPSPECIAL_TOPBAR_TAG = 1313; //子控制器的顶部topbar不是tp_NavigationBar的话设置的tag，用来错误视图覆盖的时候寻找置顶


@interface TPBaseViewController : TPBaseNavigationBarViewController

{
    BOOL _isHideTabBarWhenPushed;
}

/**
 push该控制器时是否隐藏TabBar
 */
@property (nonatomic, assign) BOOL isHideTabBarWhenPushed;

#pragma mark - Hook
/**
 子控制器决定，是否根据 - (BOOL)systemNavBarHidden自动设置导航栏的隐藏属性
 */
- (BOOL)autoSettingSystemNavBarHidden;

/**
 子控制器决定，是否隐藏系统导航条
 */
- (BOOL)systemNavBarHidden;

/**
 是否开启左滑返回手势
 
 在TPBaseNavigationController启用该手势时才有效
 */
- (BOOL)popGestureEnabled;


@end

