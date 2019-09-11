//
//  UIImageView+FindHairline.m
//  DiscuzMobile
//
//  Created by ZhangJitao on 2018/3/16.
//  Copyright © 2018年 comsenz-service.com.  All rights reserved.
//

#import "UIImageView+FindHairline.h"

@implementation UIImageView (FindHairline)

// 查找UINavigationBar分割线
+ (UIImageView*)findHairlineImageViewUnder:(UIView*)view {
    if([view isKindOfClass:UIImageView.class] && view.bounds.size.height<=1.0) {
        return (UIImageView*)view;
    }
    for(UIView *subview in view.subviews) {
        UIImageView*imageView = [self findHairlineImageViewUnder:subview];
        if(imageView) {
            return imageView;
        }
    }
    return nil;
}

@end
