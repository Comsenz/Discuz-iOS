//
//  MYCenterHeader.h
//  DiscuzMobile
//
//  Created by HB on 17/1/19.
//  Copyright © 2017年 comsenz-service.com.  All rights reserved.
//

#import <UIKit/UIKit.h>
@class CenterUserInfoView,CenterToolView;

@interface MYCenterHeader : UIView
@property (nonatomic, strong) CenterUserInfoView *userInfoView;
@property (nonatomic, strong) CenterToolView *tooView;
@end
