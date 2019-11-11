//
//  CenterCell.h
//  DiscuzMobile
//
//  Created by HB on 17/1/19.
//  Copyright © 2017年 comsenz-service.com.  All rights reserved.
//

#import <UIKit/UIKit.h>
@class HorizontalImageTextView,TextIconModel;

@interface CenterCell : UITableViewCell

@property (nonatomic, strong) HorizontalImageTextView *nameV;
@property (nonatomic, strong) UILabel *detailLab;

- (void)setData:(TextIconModel *)model;

@end
