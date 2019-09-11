//
//  BaseFloatingView.m
//  DiscuzMobile
//
//  Created by HB on 2017/7/27.
//  Copyright © 2017年 comsenz-service.com.  All rights reserved.
//

#import "BaseFloatingView.h"
#import "UIButton+EnlargeEdge.h"

@interface BaseFloatingView() <UIGestureRecognizerDelegate>


@end

@implementation BaseFloatingView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = RGBACOLOR(83, 83, 83, 0.5);
        UIWindow *window = [UIApplication sharedApplication].delegate.window;
        self.frame = window.bounds;
        [self sup_commitInit];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(close)];
        tap.delegate = self;
        [self addGestureRecognizer:tap];
    }
    
    return self;
}

- (void)sup_commitInit {
    
    self.contentView = [[UIView alloc] init];
    self.contentView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.contentView];
    
    self.closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.closeBtn setImage:[UIImage imageNamed:@"type_close"] forState:UIControlStateNormal];
    [self.closeBtn addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
    [self.closeBtn setEnlargeEdgeWithTop:15 right:15 bottom:15 left:15];
    [self.contentView addSubview:self.closeBtn];
    
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([touch.view isDescendantOfView:self.contentView]) {
        return NO;
    }
    return YES;
}

- (void)show {
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    [window addSubview:self];
}

- (void)close {
    [self removeFromSuperview];
}

@end
