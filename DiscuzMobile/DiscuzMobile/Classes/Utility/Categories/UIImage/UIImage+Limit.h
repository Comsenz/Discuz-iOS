//
//  UIImage+Limit.h
//  DiscuzMobile
//
//  Created by ZhangJitao on 2019/7/25.
//  Copyright © 2019 comsenz-service.com.  All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (Limit)

// 限制大小为1M
- (NSData *)limitImageSize;

// 锁定比例缩放
+ (UIImage*)transformWithLockedRatioWidth:(CGFloat)width
                              height:(CGFloat)height rotate:(BOOL)rotate;

// 缩放
+ (UIImage*)transform:(UIImage *)image width:(CGFloat)width
               height:(CGFloat)height rotate:(BOOL)rotate;
@end

NS_ASSUME_NONNULL_END
