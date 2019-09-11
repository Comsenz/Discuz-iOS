//
//  BaseViewController.m
//  DiscuzMobile
//
//  Created by gensinimac1 on 15/5/4.
//  Copyright (c) 2015年 Cjk. All rights reserved.
//

#import "BaseViewController.h"

#import "LoginController.h"
#import "PostVoteViewController.h"
#import "Environment.h"
#import "UIImageView+FindHairline.h"
#import "WBEmoticonInputView.h"

@interface BaseViewController ()<UIGestureRecognizerDelegate>

@end

@implementation BaseViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:NAVI_TITLE_COLOR,NSForegroundColorAttributeName,[FontSize NavTitleFontSize18],NSFontAttributeName, nil];
    self.navigationController.navigationBar.titleTextAttributes = dict;
    [self createBarBtn:@"back" type:NavItemImage Direction:NavDirectionLeft];
    
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(initLogin) name:@"LOGIN" object:nil];
    // 监听UIWindow隐藏 播放视频的时候，状态栏会自动消失，处理后让状态栏重新出现
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(endFullScreen:) name:UIWindowDidBecomeHiddenNotification object:nil];
    
}

- (void)endFullScreen:(NSNotification *)noti {
    UIWindow * win = (UIWindow *)noti.object;
    if(win){
        UIViewController *rootVC = win.rootViewController;
        
        NSArray<__kindof UIViewController *> *vcs = rootVC.childViewControllers;
        if([vcs.firstObject isKindOfClass:NSClassFromString(@"AVPlayerViewController")]){
            [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
        }
    }
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if (self.navigationController.viewControllers.count == 1)//关闭主界面的右滑返回
    {
        return NO;
    }
    else
    {
        return YES;
    }
}

- (void)dealloc {
    DLog(@"baseVC销毁了");
}

- (void)showServerError:(NSError *)error {
    if (error != nil) {
        NSString *message = [NSString stringWithFormat:@"错误:%@",[error localizedDescription]];
#ifdef DEBUG        
#else
        if (error.code == NSURLErrorTimedOut) {
            message = @"网络请求超时！";
        } else {
            message = @"服务器数据获取失败";
        }
#endif
        [MBProgressHUD showInfo:message];
    }
}

// 弹出登录界面
- (void)initLogin {
    LoginController *login = [[LoginController alloc] init];
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:login];
    [self presentViewController:nc animated:YES completion:nil];
}
// 界面是否登录
- (BOOL)isLogin {
    if (![LoginModule isLogged]) {
        [self initLogin];
        return NO;
    }
    return YES;
}

/**
 * 创建左右 导航按钮
 @param titleORImageUrl  标题或者图片路径
 @param type  类型 图片 或者 title
 @param direction  方向 左右
 */
-(void)createBarBtn:(NSString *)titleORImageUrl type:(NavItemContentType)type Direction:(NavDirection)direction {
    
    if (direction == NavDirectionLeft) {
        UIBarButtonItem *leftBtn;
        if (type == NavItemText) {
            if ([DataCheck isValidString:titleORImageUrl]) {
                leftBtn = [[UIBarButtonItem alloc] initWithTitle:titleORImageUrl style:UIBarButtonItemStylePlain target:self action:@selector(leftBarBtnClick)];
            }
        } else {
            leftBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:titleORImageUrl] style:UIBarButtonItemStylePlain target:self action:@selector(leftBarBtnClick)];
        }
        self.navigationItem.leftBarButtonItem = leftBtn;
        self.navigationItem.leftBarButtonItem.tintColor = MAIN_TITLE_COLOR;
    } else {
        UIBarButtonItem *rightBtn;
        if (type == NavItemText) {
            if ([DataCheck isValidString:titleORImageUrl]) {
                rightBtn = [[UIBarButtonItem alloc] initWithTitle:titleORImageUrl style:UIBarButtonItemStylePlain target:self action:@selector(rightBarBtnClick)];
            }
            
        } else {
            rightBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:titleORImageUrl] style:UIBarButtonItemStylePlain target:self action:@selector(rightBarBtnClick)];
        }
        self.navigationItem.rightBarButtonItem = rightBtn;
        self.navigationItem.rightBarButtonItem.tintColor = MAIN_TITLE_COLOR;
    }
    
}

-(void)leftBarBtnClick{
    DLog(@"左按钮");
    if (self.navigationController.viewControllers.count > 1) {
        [WBEmoticonInputView sharedView].hidden = YES;
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

-(void)rightBarBtnClick {
    DLog(@"you按钮");
}

#pragma mark - 懒加载
// 加载圈
- (MBProgressHUD *)HUD {
    if (!_HUD) {
        _HUD = [[MBProgressHUD alloc] initWithView:self.view];
    }
    return _HUD;
}

// 空白页
- (EmptyAlertView *)emptyView {
    if (_emptyView == nil) {
        _emptyView = [[EmptyAlertView alloc] init];
        _emptyView.hidden = YES;
    }
    return _emptyView;
}

- (CGFloat)tabbarHeight {
    if (!_tabbarHeight) {
        CGRect rectOfTabbar = self.tabBarController.tabBar.frame;
        _tabbarHeight = CGRectGetHeight(rectOfTabbar);
    }
    return _tabbarHeight;
}

- (CGFloat)statusbarHeight {
    if (!_statusbarHeight) {
        CGRect rectOfStatusbar = [[UIApplication sharedApplication] statusBarFrame];
        _statusbarHeight = CGRectGetHeight(rectOfStatusbar);
    }
    return _statusbarHeight;
}

- (CGFloat)navbarMaxY {
    if (!_navbarMaxY) {
        CGRect rectOfNavigationbar = self.navigationController.navigationBar.frame;
        _navbarMaxY = CGRectGetMaxY(rectOfNavigationbar);
    }
    return _navbarMaxY;
}

@end
