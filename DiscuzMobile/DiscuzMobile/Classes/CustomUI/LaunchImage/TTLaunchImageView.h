//
//  TTLaunchImageView.h
//  DiscuzMobile
//
//  Created by HB on 16/5/25.
//  Copyright © 2016年 Cjk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TTLaunchImageView : UIImageView

@property (nonatomic, strong) NSString *URLString;

@property (nonatomic, copy) void (^clickedImageURLHandle)(NSString *URLString);

@end
