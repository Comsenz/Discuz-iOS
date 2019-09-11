//
//  ChatYYLabel.m
//  DiscuzMobile
//
//  Created by ZhangJitao on 2018/7/2.
//  Copyright © 2018年 comsenz-service.com.  All rights reserved.
//

#import "ChatYYLabel.h"

@implementation ChatYYLabel

//自己能否成为第一响应者
- (BOOL)canBecomeFirstResponder {
    return YES;
}

-(BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    if (action == @selector(deleteAction) || action == @selector(copyAction)) {
        return YES;
    }
    return NO;
}

- (void)deleteAction {
    self.deleteBlock?self.deleteBlock():nil;
    
}
- (void)copyAction {
    self.copyBlock?self.copyBlock():nil;
}

@end
