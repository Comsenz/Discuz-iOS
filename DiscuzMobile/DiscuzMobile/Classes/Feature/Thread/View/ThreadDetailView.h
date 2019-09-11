//
//  ThreadDetailView.h
//  DiscuzMobile
//
//  Created by HB on 16/11/25.
//  Copyright © 2016年 comsenz-service.com.  All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "ThreadKeyboard.h"
#import "EmoticonKeyboard.h"

@interface ThreadDetailView : UIView

@property (nonatomic, strong) EmoticonKeyboard *emoKeyboard;

@property (nonatomic,strong) UIWebView *webView;


@end
