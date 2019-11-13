//
//  ChatContainScrollView.m
//  DiscuzMobile
//
//  Created by HB on 17/4/27.
//  Copyright © 2017年 comsenz-service.com.  All rights reserved.
//

#import "ChatContainScrollView.h"

@implementation ChatContainScrollView


- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
