//
//  TitleSelectView.h
//  DiscuzMobile
//
//  Created by HB on 16/12/23.
//  Copyright © 2016年 comsenz-service.com.  All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^SelectBlock)(UITapGestureRecognizer *tap);
@interface TitleSelectView : UIView
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, copy) SelectBlock selectBlock;
@end
