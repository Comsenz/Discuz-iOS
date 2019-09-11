//
//  XinGeCenter.h
//  DiscuzMobile
//
//  Created by HB on 16/12/19.
//  Copyright © 2016年 comsenz-service.com.  All rights reserved.
//

#import <Foundation/Foundation.h>
//信鸽
#import "XGPush.h"
#import "XGSetting.h"

@interface XinGeCenter : NSObject

+ (instancetype)shareInstance;

/** 配置推送*/
- (void)setXG;

/** 收到推送后跳到某页 */
- (void)getNotiToview:(NSDictionary *)userInfo;

/** 本来就在前台的时候 */
- (void)isActivePushAlert:(NSDictionary *)userInfo;

/** 角标清0 */
- (void)cancelPushBadge;

/** 回调版本示例 */
- (void)receiveNotificationFeeback:(NSDictionary *)userInfo;

/** 信鸽注册 */
- (void)Reregistration;

@end
