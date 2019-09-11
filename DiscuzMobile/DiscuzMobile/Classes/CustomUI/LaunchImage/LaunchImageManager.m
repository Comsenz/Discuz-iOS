//
//  LaunchImageManager.m
//  DiscuzMobile
//
//  Created by HB on 17/3/28.
//  Copyright © 2017年 comsenz-service.com.  All rights reserved.
//

#import "LaunchImageManager.h"
#import "UIView+TYLaunchAnimation.h"
#import "TYLaunchFadeScaleAnimation.h"
#import "UIImage+TYLaunchImage.h"
#import "TTLaunchImageView.h"
#import "TTUrlController.h"

@implementation LaunchImageManager

+ (instancetype)shareInstance {
    static LaunchImageManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[LaunchImageManager alloc] init];
    });
    return manager;
}

- (void)setLaunchView {
    if([[NSUserDefaults standardUserDefaults] boolForKey:@"firstStart"]) {
        // 开机启动画
        self.launchImageView = [[TTLaunchImageView alloc] initWithImage:[UIImage ty_getLaunchImage]];
        [self.launchImageView addInWindow];
        // 不是第一次启动 设置开机启动动画
        [DZApiRequest requestWithConfig:^(JTURLRequest *request) {
//            request.urlString = url_LaunchImage;
            request.timeoutInterval = 2;
        } success:^(id responseObject, JTLoadType type) {
            DLog(@"responseObject:%@",responseObject);
            [self anylyLaunchData:responseObject];
        } failed:^(NSError *error) {
            [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication].delegate window] animated:NO];
            DLog(@"请求超时或失败，加载缓存本地图片");
        }];
    }
}

- (void)anylyLaunchData:(id)resp {
    
    
//    [self test];
//    return;
    WEAKSELF;
    [self.launchImageView showInWindowWithAnimation:[TYLaunchFadeScaleAnimation fadeAnimationWithDelay:5.0] completion:^(BOOL finished) {
        NSLog(@"finished");
    }];
    if ([DataCheck isValidString:[[[resp objectForKey:@"Variables"] objectForKey:@"openimage"] objectForKey:@"imgsrc"]]) {
        NSString *openimageStr = [[[resp objectForKey:@"Variables"] objectForKey:@"openimage"] objectForKey:@"imgsrc"];
        
        openimageStr = [openimageStr makeDomain];
        
        self.launchImageView.URLString = openimageStr;
        // 点击广告block
        [self.launchImageView setClickedImageURLHandle:^(NSString *URLString) {
            [weakSelf pushAdViewCntroller:[[[resp objectForKey:@"Variables"] objectForKey:@"openimage"] objectForKey:@"imgurl"]];
        }];
    } else {
        self.launchImageView.URLString = @"";
    }
}

- (void)test {
    WEAKSELF;
    [self.launchImageView showInWindowWithAnimation:[TYLaunchFadeScaleAnimation fadeAnimationWithDelay:5.0] completion:^(BOOL finished) {
        NSLog(@"finished");
    }];
    NSString *openimageStr = @"http://img1.126.net/channel6/2015/020002/2.jpg?dpi=6401136";
    self.launchImageView.URLString = openimageStr;
    // 点击广告block
    [self.launchImageView setClickedImageURLHandle:^(NSString *URLString) {
        [weakSelf pushAdViewCntroller:@"https://www.baidu.com"];
    }];
}

// 点击启动页跳转的控制器，webview
- (void)pushAdViewCntroller:(NSString *)Url {
    
        if (![Url isEqualToString:@""]) {
            UIWindow *window = [[UIApplication sharedApplication].delegate window];
            UITabBarController *tabbBarVC = (UITabBarController *)window.rootViewController;
            UINavigationController *navVC = tabbBarVC.selectedViewController;
            // 你要推出的VC
            TTUrlController *urlVC = [[TTUrlController alloc]init];
            urlVC.hidesBottomBarWhenPushed = YES;
            urlVC.urlString = Url;
            [navVC pushViewController:urlVC animated:YES];
        }
}


@end
