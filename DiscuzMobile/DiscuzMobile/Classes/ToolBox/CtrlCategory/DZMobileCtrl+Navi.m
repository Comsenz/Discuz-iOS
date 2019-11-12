//
//  DZMobileCtrl+Navi.m
//  DiscuzMobile
//
//  Created by WebersonGao on 2019/11/12.
//  Copyright © 2019 comsenz-service.com. All rights reserved.
//

#import "DZMobileCtrl+Navi.h"
#import "DZOtherUserController.h"
#import "DZForumThreadController.h"
#import "LianMixAllViewController.h"
#import "DZBaseUrlController.h"
#import "DZLoginController.h"
#import "TTSearchController.h"

@implementation DZMobileCtrl (Navi)

-(void)PushToController:(UIViewController *)CtrlVC{
    [self.mainNavi pushViewController:CtrlVC animated:YES];
}

-(void)PushToOtherUserController:(NSString *)userId{
    NSString *userIdStr = checkNull(userId);
    if (userIdStr.length) {
        DZOtherUserController * ovc = [[DZOtherUserController alloc] init];
        ovc.authorid = userIdStr;
        [self.mainNavi pushViewController:ovc animated:YES];
    }
}


- (void)PushToDetailController:(NSString *)tid {
    DZForumThreadController * threadVC = [[DZForumThreadController alloc] init];
    threadVC.tid = tid;
    [self.mainNavi pushViewController:threadVC animated:YES];
}

- (void)ShowDetailControllerFromVC:(UIViewController *)selfVC tid:(NSString *)tid{
    DZForumThreadController *threadVC = [[DZForumThreadController alloc] init];
    threadVC.tid = checkNull(tid);
    [selfVC showViewController:threadVC sender:nil];
}

- (void)PushToForumlistController:(NSString *)fid {
    LianMixAllViewController *lianMixVc = [[LianMixAllViewController alloc] init];
    lianMixVc.forumFid = fid;
    [self.mainNavi pushViewController:lianMixVc animated:YES];
}

- (void)PushToWebViewController:(NSString *)link {
    DZBaseUrlController *urlCtrl = [[DZBaseUrlController alloc] init];
    urlCtrl.hidesBottomBarWhenPushed = YES;
    urlCtrl.urlString = link;
    [self.mainNavi pushViewController:urlCtrl animated:YES];
}


-(void)PresentLoginController:(UIViewController *)selfVC{
    
    [self PresentLoginController:selfVC tabSelect:NO];
}

-(void)PresentLoginController:(UIViewController *)selfVC tabSelect:(BOOL)select{

    DZLoginController *loginVC = [[DZLoginController alloc] init];
    loginVC.isKeepTabbarSelected = select;
    
    if (!selfVC) {
        [self.mainNavi presentViewController:loginVC animated:YES completion:nil];
    }else{
        UINavigationController * preVC = [[UINavigationController alloc] initWithRootViewController:loginVC];;
        [selfVC presentViewController:preVC animated:YES completion:nil];
    }
}



-(void)PushToSearchController{
    
    TTSearchController *searchVC = [[TTSearchController alloc] init];
    searchVC.hidesBottomBarWhenPushed = YES;
    [self.mainNavi pushViewController:searchVC animated:YES];
}






@end
