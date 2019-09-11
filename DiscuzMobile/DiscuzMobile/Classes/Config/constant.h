//
//  const.h
//  DiscuzMobile
//
//  Created by ZhangJitao on 2018/2/1.
//  Copyright © 2018年 comsenz-service.com.  All rights reserved.
//

// 常量文件
#ifndef constant_h
#define constant_h

#pragma mark - app名称
#define APPDISPLAYNAME [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"]
#define NOWYEAR [[NSDate date] stringFromDateFormat:@"yyyy"]

/** App id */
#define DZAPPID @"1011658227"
#define AppStorePath @"https://itunes.apple.com/cn/app/id1011658227"

// 邮箱
#define DeveloperEmail @"zjt182163@163.com"

#define WEAKSELF __weak typeof(self) weakSelf = self;
#define STRONGSELF __strong typeof(weakSelf) strongSelf = weakSelf;

#define WIDTH [UIScreen mainScreen].bounds.size.width
#define HEIGHT [UIScreen mainScreen].bounds.size.height
#define TIME 1.0
#define ALINE 35


//G－C－D
#define BACK(block) dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block)
#define MAIN(block) dispatch_async(dispatch_get_main_queue(),block)

#ifdef DEBUG
#define DLog( s, ... ) NSLog( @"<%p %@:(%d)> %@", self, [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__] )
#else
#define DLog( s, ... )
#endif

#pragma mark - 网络请求超时时间
#define TIMEOUT 30.0

// 判断系统版本
#define  iOS8   ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0)
#define  iOS9   ([[UIDevice currentDevice].systemVersion floatValue] >= 9.0)
#define  iOS10   ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0)
#define  iOS11   ([[UIDevice currentDevice].systemVersion floatValue] >= 11.0)

#define phoneScale (int)[UIScreen mainScreen].scale
#pragma mark - 判断屏幕适配 ============================================
#define iPhone320 WIDTH == 320
#define iPhone375 WIDTH == 375
#define iPhone414 WIDTH == 414

#define StatusBarHeight [UIApplication sharedApplication].statusBarFrame.size.height
#define SafeAreaTopHeight ((HEIGHT >= 812.0) && [[UIDevice currentDevice].model isEqualToString:@"iPhone"] ? 88 : 64)
#define SafeAreaBottomHeight ((HEIGHT >= 812.0) && [[UIDevice currentDevice].model isEqualToString:@"iPhone"]  ? 30 : 0)

#pragma mark - 通知 ================================================

// tabbar个人中心选中
#define SETSELECTINDEX @"selectIndex"
// 连续点击tabbar刷新
#define TABBARREFRESH @"TabbarButtonClickDidRepeatNotification"
// 刷新个人中心资料
#define REFRESHCENTER @"getZiliao"
#define IMAGEORNOT @"imageOrNot"
#define SIGNOUTNOTIFY @"SIGNOUTNOTIFY"
// 点中statusbar
#define STATUSBARTAP @"statusBarTappedNotification"
// 防止首次加载APP的时候没有数据，划过导航页面的时候刷新一次
#define FIRSTAPP @"FIRSTAPP"

// 首次请求帖子列表的时候通知
#define THREADLISTFISTREQUEST @"THREADLISTFISTREQUEST"
// 使用JTContainerController控件，请求的时候
#define JTCONTAINERQUEST @"JTCONTAINERQUEST"

// 登录后刷新一些页面，获取cookie或者formhash
#define LOGINEDREFRESHGETINFO @"LOGINEDREFRESHGETINFO"
#define COLLECTIONFORUMREFRESH @"COLLECTIONFORUMREFRESH"
#define REFRESHWEB @"refreshWeb"

#define DOMAINCHANGE @"DOMAINCHANGE"

#endif /* const_h */
