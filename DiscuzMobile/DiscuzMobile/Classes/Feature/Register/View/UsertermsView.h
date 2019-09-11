//
//  UsertermsView.h
//  DiscuzMobile
//
//  Created by HB on 17/3/8.
//  Copyright © 2017年 Cjk. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ReadTermsBlock)(void);

@interface UsertermsView : UIView

@property (nonatomic, assign) BOOL isAgree;

@property (nonatomic, copy) ReadTermsBlock readTermBlock;

@end
