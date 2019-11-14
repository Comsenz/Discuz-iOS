//
//  DZMobileCtrl+Navi.h
//  DiscuzMobile
//
//  Created by WebersonGao on 2019/11/12.
//  Copyright © 2019 comsenz-service.com. All rights reserved.
//

#import "DZMobileCtrl.h"

@interface DZMobileCtrl (Navi)

-(void)PushToController:(UIViewController *)CtrlVC;

-(void)PushToOtherUserController:(NSString *)userId;

- (void)PushToDetailController:(NSString *)tid;

- (void)ShowDetailControllerFromVC:(UIViewController *)selfVC tid:(NSString *)tid;

- (void)PushToForumlistController:(NSString *)fid;

- (void)PushToWebViewController:(NSString *)link;

-(void)PresentLoginController:(UIViewController *)selfVC;

-(void)PresentLoginController:(UIViewController *)selfVC tabSelect:(BOOL)select;

-(void)PushToSearchController;

@end


