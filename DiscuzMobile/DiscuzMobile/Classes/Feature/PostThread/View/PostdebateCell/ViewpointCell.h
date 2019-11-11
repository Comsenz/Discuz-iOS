//
//  ViewpointCell.h
//  DiscuzMobile
//
//  Created by HB on 2017/6/23.
//  Copyright © 2017年 comsenz-service.com.  All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DZPlaceholderTextView.h"

@interface ViewpointCell : UITableViewCell

@property (nonatomic, strong) UILabel *positiveLab;
@property (nonatomic, strong) UILabel *oppositeLab;

@property (nonatomic, strong) DZPlaceholderTextView *positiveTextView; // 正方
@property (nonatomic, strong) DZPlaceholderTextView *oppositeTextView; // 反方

@end
