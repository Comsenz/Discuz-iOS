//
//  VerticalImageTextView.h
//  DiscuzMobile
//
//  Created by HB on 17/1/19.
//  Copyright © 2017年 comsenz-service.com.  All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VerticalImageTextView : UIView

@property (nonnull, strong) UIImageView *iconV;
@property (nonnull, strong) UILabel *textLabel;

- (void)addTarget:(nonnull id)target action:(nonnull SEL)action;

@end
