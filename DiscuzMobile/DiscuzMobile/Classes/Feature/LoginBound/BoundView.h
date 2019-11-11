//
//  BoundView.h
//  DiscuzMobile
//
//  Created by HB on 16/10/27.
//  Copyright © 2016年 comsenz-service.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BoundView : UIScrollView

@property (nonatomic,strong) UITextField *nameField;
@property (nonatomic,strong) UITextField *passwordField;
@property (nonatomic,strong) UITextField *authCodeField;
@property (nonatomic,strong) DZAuthCodeView *codeView;
@property (nonatomic,strong) UIButton *boundBtn;

@end
