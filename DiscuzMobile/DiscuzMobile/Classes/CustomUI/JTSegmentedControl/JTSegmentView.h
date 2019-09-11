//
//  JTSegmentView.h
//  DiscuzMobile
//
//  Created by HB on 17/3/31.
//  Copyright © 2017年 comsenz-service.com.  All rights reserved.
//

#import <UIKit/UIKit.h>
@class JTSegmentedControl,JTSegmentedCell;

@interface JTSegmentView : UIView

@property (nonatomic, strong) JTSegmentedControl *segment;

- (void)setSegmentCell:(NSArray <NSString *> *)titleArr;

- (JTSegmentedCell *)createCell:(NSString *)text andImage:(UIImage *)image;

@end
