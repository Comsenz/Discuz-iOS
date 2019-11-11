//
//  DZLaunchImageView.h
//  DiscuzMobile
//
//  Created by HB on 16/5/25.
//  Copyright © 2016年 comsenz-service.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DZLaunchImageView : UIImageView

@property (nonatomic, strong) NSString *URLString;

@property (nonatomic, copy) void (^clickedImageURLHandle)(NSString *URLString);

@end
