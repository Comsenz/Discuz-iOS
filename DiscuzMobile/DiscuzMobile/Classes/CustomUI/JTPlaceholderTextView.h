//
//  JTPlaceholderTextView.h
//  DiscuzMobile
//
//  Created by HB on 16/12/1.
//  Copyright © 2016年 comsenz-service.com.  All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JTPlaceholderTextView : UITextView<UITextViewDelegate>

@property (nonatomic, strong) UIColor *placeholderColor;
@property (nonatomic, strong) NSString *placeholder;

@end
