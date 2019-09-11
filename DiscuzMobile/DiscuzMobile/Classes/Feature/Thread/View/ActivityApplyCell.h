//
//  ActivityApplyCell.h
//  DiscuzMobile
//
//  Created by HB on 2017/7/28.
//  Copyright © 2017年 comsenz-service.com.  All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ApplyItemView.h"
#import "ApplyActiver.h"

@interface ActivityApplyCell : UITableViewCell
@property (nonatomic, strong) ApplyItemView *applyLab;
@property (nonatomic, strong) ApplyItemView *timeLab;
@property (nonatomic, strong) ApplyItemView *statusView;

- (void)setInfo:(ApplyActiver *)model;

@end
