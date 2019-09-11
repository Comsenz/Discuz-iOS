//
//  HotliveCell.h
//  DiscuzMobile
//
//  Created by HB on 2017/5/5.
//  Copyright © 2017年 comsenz-service.com.  All rights reserved.
//

#import <UIKit/UIKit.h>
@class HotLivelistModel;
@class LiveImageView;

@interface HotliveCell : UITableViewCell

@property (nonatomic, strong) LiveImageView *iconV;
@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UILabel *nameLab;
@property (nonatomic, strong) UILabel *gradLab;

- (void)setInfo:(HotLivelistModel *)info;

@end
