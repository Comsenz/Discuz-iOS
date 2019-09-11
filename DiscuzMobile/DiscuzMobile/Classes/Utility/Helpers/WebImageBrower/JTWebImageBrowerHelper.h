//
//  JTWebImageBrowerHelper.h
//  DiscuzMobile
//
//  Created by ZhangJitao on 2018/4/13.
//  Copyright © 2018年 comsenz-service.com.  All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JTWebImageBrowerHelper : NSObject

+ (instancetype)shareInstance;

- (void)showPhotoImageSources:(NSArray *)imagesArray thumImages:(NSArray *)thumArray currentIndex:(NSInteger)index imageContainView:(UIView *)imageBgV;

@end
