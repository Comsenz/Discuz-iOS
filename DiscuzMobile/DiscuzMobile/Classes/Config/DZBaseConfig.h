//
//  BaseConfig.h
//  DiscuzMobile
//
//  Created by ZhangJitao on 2018/2/1.
//  Copyright © 2018年 comsenz-service.com.  All rights reserved.
//

// 配置文件
#ifndef BaseConfig_h
#define BaseConfig_h

#pragma mark - 不同的项目在这里配置 ========================

#define COMPANYNAME @"北京康创联盛科技有限公司" // 公司
#define APPNAME APPDISPLAYNAME
#define INCINFO [NSString stringWithFormat:@"©2001 - %@ comsenz-service.com.",NOWYEAR] // 版权时间
//#define BASEURL @"https://guanjia.comsenz-service.com/" // 域名  除了两个plugin.php的，别的都需要拼接 api/mobile/
//#define BASEURL @"https://bbs.comsenz-service.com/"
#define BASEURL @"http://demo.516680.com/"
#define MAINCOLOR mRGBColor(50, 120, 230) // 主题色
#define EMPTYIMAGE @"empty_icon" // 无数据显示图片
#define LOGONAME @"ap_name" // 登录、注册页APP名称图片
#define BBSRULE [NSString stringWithFormat:@"bbsrule_%@",@"discuz"]; // 网站服务条款txt名字


#pragma mark - 三方 ================================================
// QQ、微信登录和分享，自己申请的appid 和 secret 微博暂无
// QQ 
#define QQ_APPID @""
#define QQ_APPKEY @""
// 微信
#define WX_APPID @""
#define WX_APPSECRET @""

// 微博
#define WB_APPID @""
#define WB_APPSECRET @""
#define REDIRRCTURI @"https://www.comsenz-service.com"

// 信鸽
#define XGTOKEN @"XGTOKEN"
#define XG_APPID      2200197269
#define XG_APPKEY     @""

#endif

