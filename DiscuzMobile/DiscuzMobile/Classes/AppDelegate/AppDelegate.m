//  2017branch
//  AppDelegate.m
//  DiscuzMobile
//
//  Created by HB on 16/7/12.
//  Copyright © 2016年 comsenz-service.com. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginModule.h"
#import "RNCachingURLProtocol.h"
#import "TabbarController.h"
#import "ShareCenter.h"
#import "LaunchImageManager.h"
#import "ThreadViewController.h"
#import "WebImageCacheNSURLProtocol.h"

#import "VersionUpdate.h"
#import "SELUpdateAlert.h"

#define _IPHONE80_ 80000

@implementation AppDelegate

static AppDelegate *_appDelegate;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    _appDelegate = self;
    
    TabbarController * rootVC = [[TabbarController alloc] init];
    self.window.rootViewController = rootVC;
    [self.window makeKeyAndVisible];
    
    [[IQKeyboardManager sharedManager] setKeyboardDistanceFromTextField:60];
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    // 注册监听键盘是否弹起
    [DZMonitorKeyboard shareInstance];

    // 判断网络
    [JTRequestOperation startMonitoring];
    
    if (![self isFirstInstall]) {
        // 设置 自动登录 cookie等
        [LoginModule setAutoLogin];
        [self versionUpdate];
    }
    
    
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    
    // 分享平台参数配置
    [[ShareCenter shareInstance] setupShareConfigure];
    
//    // 设置开机启动画面
//    [self setLaunchView];
//    [[LaunchImageManager shareInstance] setLaunchView];
    
    [self initCacheConfigure];
    
    // 修改iOS12.1 tababar的图标漂浮上移的问题
    [[UITabBar appearance] setTranslucent:NO];
    //    [UINavigationBar appearance].translucent = NO;
    
//    [self printFamilyName];
//    [NSThread sleepForTimeInterval:1];
    
    return YES;
}

- (void)versionUpdate {
    [VersionUpdate compareUpdate:^(NSString * _Nonnull newVersion, NSString * _Nonnull releaseNotes) {
        [SELUpdateAlert showUpdateAlertWithVersion:newVersion Descriptions:@[releaseNotes]];
    }];
}

- (void)initCacheConfigure {
    // 离线缓存
    [NSURLProtocol registerClass:[RNCachingURLProtocol class]];
//    [NSURLProtocol registerClass:[WebImageCacheNSURLProtocol class]];
    
    SDWebImageManager.sharedManager.imageDownloader.downloadTimeout = 10;
    SDWebImageManager.sharedManager.imageDownloader.maxConcurrentDownloads = 6;
#if Penjing
    SDWebImageManager.sharedManager.imageDownloader.executionOrder = SDWebImageDownloaderLIFOExecutionOrder;  // 图片加载方式默认FIFO先进先出，后入先出
#endif
    // 设置图片缓存信息
    [SDImageCache sharedImageCache].config.maxCacheAge = 7 * 24 * 60 * 60; //7天
    [SDImageCache sharedImageCache].config.maxCacheSize = 1024 * 1024 * 100; //100MB
    [SDImageCache sharedImageCache].maxMemoryCost = 1024 * 1024 * 40; //40MB
}

#pragma mark - Status bar 点击tableview滚到顶部
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    CGPoint location = [[[event allTouches] anyObject] locationInView:self.window];
    CGRect statusBarFrame = [UIApplication sharedApplication].statusBarFrame;
    if (CGRectContainsPoint(statusBarFrame, location)) {
        [[NSNotificationCenter defaultCenter] postNotificationName:STATUSBARTAP object:nil];
    }
}

#pragma 打印系统支持字体
- (void)printFamilyName {
    NSArray *familyNames = [UIFont familyNames];
    for(NSString *familyName in familyNames) {
        DLog(@"%@", familyName);
        NSArray *fontNames = [UIFont fontNamesForFamilyName:familyName];
        for(NSString *fontName in fontNames) {
            DLog(@"\t%@", fontName);
        }
    }
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options {
    self.isOpenUrl = YES;
    return YES;
}

+ (AppDelegate *)appDelegate {
    return _appDelegate;
}

- (void)applicationWillResignActive:(UIApplication *)application {
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
#pragma mark - 添加首次使用指导
    if ([self isFirstInstall]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstStart"];
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"COOKIEVALU"];
        //        // 首次打开APP
        //        InstroductionView *helpView = [[InstroductionView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        //        [self.window addSubview:helpView];
        //
        //        NSMutableArray *imageArr = [NSMutableArray array];
        //        for (int i = 0; i < 6; i ++) {
        //            [imageArr addObject:[UIImage imageNamed:[NSString stringWithFormat:@"instroduction%d.jpg",i]]];
        //        }
        //        [helpView setPerpage:imageArr];
        //        helpView.dismissBlock = ^ {
        //            [[NSNotificationCenter defaultCenter] postNotificationName:FIRSTAPP object:nil];
        //        };
    } else {
        if (!self.isOpenUrl) {
            // 检查cookie是否过期
            [LoginModule checkCookie];
        }
        self.isOpenUrl = NO;
    }
}

- (void)applicationWillTerminate:(UIApplication *)application {
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    DLog(@"内存警告了");
    [[SDWebImageManager sharedManager] cancelAll];
    [[SDImageCache sharedImageCache] clearMemory];
}

- (BOOL)isFirstInstall {
    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"firstStart"]) {
        return YES;
    }
    return NO;
}

@end
