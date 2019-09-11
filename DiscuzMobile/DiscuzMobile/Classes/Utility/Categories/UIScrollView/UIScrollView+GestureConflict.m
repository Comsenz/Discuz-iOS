//
//  UIScrollView+GestureConflict.m
//  DiscuzMobile
//
//  Created by ZhangJitao on 2018/8/20.
//  Copyright © 2018年 comsenz-service.com.  All rights reserved.
//

#import "UIScrollView+GestureConflict.h"

@implementation UIScrollView (GestureConflict)
//处理UIScrollView上的手势和侧滑返回手势的冲突
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    
    // 首先判断otherGestureRecognizer是不是系统pop手势
    if ([otherGestureRecognizer.view isKindOfClass:NSClassFromString(@"UILayoutContainerView")]) {
//         再判断系统手势的state是began还是fail，同时判断scrollView的位置是不是正好在最左边
        if (otherGestureRecognizer.state != UIGestureRecognizerStateFailed && self.contentOffset.x == 0) {
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"kLeaveTopNtf" object:@1];
            return YES;
        }
    }
    NSLog(@"%lf,%lf",self.contentOffset.x,self.contentOffset.y);
    return NO;
}
@end
