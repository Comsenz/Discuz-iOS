//
//  TopLabel.h
//  DiscuzMobile
//
//  Created by HB on 2017/5/8.
//  Copyright © 2017年 comsenz-service.com.  All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, AttchPosition) {
    P_before,
    P_after
};

@interface TopLabel : UILabel

- (void)setText:(NSString *)text andImageName:(NSString *)imageName andSize:(CGSize)size andPosition:(AttchPosition)position;

- (void)setText:(NSString *)text andImage:(UIImage *)image andSize:(CGSize)size andPosition:(AttchPosition)position;

@end
