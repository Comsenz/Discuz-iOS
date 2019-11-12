//
//  DZBaseFloatingView.h
//  DiscuzMobile
//
//  Created by HB on 2017/7/27.
//  Copyright © 2017年 comsenz-service.com.  All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DZBaseFloatingView : UIView

@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIButton *closeBtn;

- (void)show;

- (void)close;

@end
