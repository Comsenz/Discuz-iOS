//
//  UIImageView+FindHairline.h
//  DiscuzMobile
//
//  Created by ZhangJitao on 2018/3/16.
//  Copyright © 2018年 comsenz-service.com.  All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (FindHairline)
// 查找UINavigationBar分割线
+ (UIImageView*)findHairlineImageViewUnder:(UIView*)view;
@end
