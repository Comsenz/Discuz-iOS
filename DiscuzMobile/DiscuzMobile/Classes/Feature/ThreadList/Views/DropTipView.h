//
//  DropTipView.h
//  DiscuzMobile
//
//  Created by ZhangJitao on 2018/7/13.
//  Copyright © 2018年 comsenz-service.com.  All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DropTipView : UIView
@property (nonatomic, strong) UILabel *tipLabel;
@property (nonatomic, strong) UIButton *closeBtn;
@property (nonatomic, assign) BOOL tipAnimatefinsh;

@property (nonatomic, copy) void(^clickTipAction)(void);
@end
