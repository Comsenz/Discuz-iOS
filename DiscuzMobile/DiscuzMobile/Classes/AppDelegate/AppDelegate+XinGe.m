//
//  AppDelegate+XinGe.m
//  DiscuzMobile
//
//  Created by ZhangJitao on 2018/2/1.
//  Copyright © 2018年 comsenz-service.com.  All rights reserved.
//

#import "AppDelegate+XinGe.h"
#import "XinGeCenter.h" // 信鸽

@implementation AppDelegate (XinGe)

// 连接信鸽
- (void)connectXinge:(NSDictionary *)launchOptions {
    
    // 注册通知,信鸽注册设备
    [[XinGeCenter shareInstance] Reregistration];
    // 信鸽启动APP时收到消息
    if (launchOptions) {
        [self xingeGetPushLunch:launchOptions];
    }
    //角标清0
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    
    //清除所有通知(包含本地通知)
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    [[XinGeCenter shareInstance] setXG];
}

#pragma mark - 信鸽推送收到（APP启动）
- (void)xingeGetPushLunch:(NSDictionary *)launchOptions {
    NSDictionary* pushNotificationKey =[launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    
    if (pushNotificationKey) {
        [[XinGeCenter shareInstance] getNotiToview:pushNotificationKey];
        //这里定义自己的处理方式
        [[XinGeCenter shareInstance] receiveNotificationFeeback:pushNotificationKey];
    } else {
        [[XinGeCenter shareInstance] cancelPushBadge];
    }
}

-(void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    //notification是发送推送时传入的字典信息
    [XGPush localNotificationAtFrontEnd:notification userInfoKey:@"clockID" userInfoValue:@"myid"];
    
    //删除推送列表中的这一条
    [XGPush delLocalNotification:notification];
    //[XGPush delLocalNotification:@"clockID" userInfoValue:@"myid"];
    //清空推送列表
    //[XGPush clearLocalNotifications];
}


#if __IPHONE_OS_VERSION_MAX_ALLOWED >= _IPHONE80_
//注册UserNotification成功的回调
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    //用户已经允许接收以下类型的推送
    //UIUserNotificationType allowedTypes = [notificationSettings types];
    
}

//按钮点击事件回调
- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void (^)(void))completionHandler{
    if([identifier isEqualToString:@"ACCEPT_IDENTIFIER"]){
        NSLog(@"ACCEPT_IDENTIFIER is clicked");
    }
    completionHandler();
}

#endif

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    //注册设备
    //    [[XGSetting getInstance] setChannel:@"掌上论坛"];
    //    XGSetting * setting = (XGSetting *)[XGSetting getInstance];
    //    [setting setChannel:@"掌上论坛"];
    //    [[XGSetting getInstance] setGameServer:@"巨神峰"];
    void (^successBlock)(void) = ^() {
        //成功之后的处理
        DLog(@"[XGPush]register successBlock");
    };
    
    void (^errorBlock)(void) = ^() {
        //失败之后的处理
        DLog(@"[XGPush]register errorBlock");
    };
    NSString * deviceTokenStr = [XGPush registerDevice:deviceToken successCallback:successBlock errorCallback:errorBlock];
    [[NSUserDefaults standardUserDefaults] setObject:deviceToken forKey:XGTOKEN];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    DLog(@"deviceTokenStr=%@",deviceTokenStr);
    //如果不需要回调
    //    NSString * deviceTokenStr = [XGPush registerDevice:deviceToken];
}

// 如果deviceToken获取不到会进入此事件
- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSString *str = [NSString stringWithFormat: @"Error: %@",error];
    DLog(@"%@",str);
}

#pragma mark - iOS10 收到推送处理(APP运行时)
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler {
    [[XinGeCenter shareInstance] isActivePushAlert:notification.request.content.userInfo];
}

// (APP在后台)
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler {
    
    [[XinGeCenter shareInstance] getNotiToview:response.notification.request.content.userInfo];
    
}

#pragma mark - 收到推送处理(APP运行时)
- (void)application:(UIApplication*)application didReceiveRemoteNotification:(NSDictionary*)userInfo
{
    if([UIApplication sharedApplication].applicationState == UIApplicationStateActive) {
        // 本来就在前台的时候
        [[XinGeCenter shareInstance] isActivePushAlert:userInfo];
        
    } else if ([UIApplication sharedApplication].applicationState == UIApplicationStateInactive) {
        //        点击推送通知进入界面的时候
        [[XinGeCenter shareInstance] getNotiToview:userInfo];
    }
    
    [[XinGeCenter shareInstance] receiveNotificationFeeback:userInfo];
}


@end
