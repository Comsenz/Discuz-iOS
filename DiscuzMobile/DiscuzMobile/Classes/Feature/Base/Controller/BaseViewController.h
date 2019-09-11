//
//  BaseViewController.h
//  DiscuzMobile
//
//  Created by gensinimac1 on 15/5/4.
//  Copyright (c) 2015年 Cjk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginModule.h"
#import "MBProgressHUD.h"
#import "MBProgressHUD+Add.h"
#import "EmptyAlertView.h"

typedef NS_ENUM(NSUInteger, NavDirection) {
    NavDirectionLeft,
    NavDirectionRight,
};

typedef NS_ENUM(NSUInteger, NavItemContentType) {
    NavItemImage,
    NavItemText,
};

@interface BaseViewController : UIViewController

@property (nonatomic, assign) CGFloat navbarMaxY;
@property (nonatomic, assign) CGFloat tabbarHeight;
@property (nonatomic, assign) CGFloat statusbarHeight;

@property (nonatomic, strong) MBProgressHUD *HUD;
@property (nonatomic, strong) EmptyAlertView *emptyView;


/**
 * 创建左右 导航按钮
 @param titleORImageUrl  标题或者图片路径
 @param type  类型 图片 或者 文字
 @param direction  方向 right or left
*/
-(void)createBarBtn:(NSString *)titleORImageUrl type:(NavItemContentType)type Direction:(NavDirection)direction;

/**
 服务器返回错误提示

 @param error NSError
 */
- (void)showServerError:(NSError *)error;

/**
 弹出登录界面
 */
- (void)initLogin;

/**
 判断是否登录，未登录弹出登录界面

 @return 是或否 YES or NO
 */
- (BOOL)isLogin;

/**
 导航栏右按钮点击事件
 */
-(void)rightBarBtnClick;

/**
 导航栏左按钮点击事件
 */
-(void)leftBarBtnClick;

@end
