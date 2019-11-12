//
//  DZMobileCtrl+Navi.m
//  DiscuzMobile
//
//  Created by WebersonGao on 2019/11/12.
//  Copyright © 2019 comsenz-service.com. All rights reserved.
//

#import "DZMobileCtrl+Navi.h"
#import "DZOtherUserController.h"


@implementation DZMobileCtrl (Navi)

-(void)transToController:(UIViewController *)CtrlVC{
    [self.mainNavi pushViewController:CtrlVC animated:YES];
}

-(void)transToOtherUserController:(NSString *)userId{
    NSString *userIdStr = checkNull(userId);
    if (userIdStr.length) {
        DZOtherUserController * ovc = [[DZOtherUserController alloc] init];
        ovc.authorid = userIdStr;
        [self.mainNavi pushViewController:ovc animated:YES];
    }
}






@end
