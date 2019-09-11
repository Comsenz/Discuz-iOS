//  放头像，用户名，身份
//  CenterUserInfoView.h
//  DiscuzMobile
//
//  Created by HB on 17/1/19.
//  Copyright © 2017年 comsenz-service.com.  All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CenterUserInfoView : UIView

@property (nonatomic, strong) UIImageView *headView;
@property (nonatomic, strong) UILabel *nameLab;
@property (nonatomic, strong) UILabel *identityLab;

- (void)setIdentityText:(NSString *)text;

@end
