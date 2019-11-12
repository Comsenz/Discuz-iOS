//
//  DZAuthCodeView.h
//  DiscuzMobile
//
//  Created by HB on 16/9/18.
//  Copyright © 2016年 comsenz-service.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DZAuthCodeView : UIView

@property (strong, nonatomic) NSArray *dataArray;//字符素材数组

@property (copy, nonatomic) NSMutableString *authCodeStr;//验证码字符串

- (void)updateCode;

@end
