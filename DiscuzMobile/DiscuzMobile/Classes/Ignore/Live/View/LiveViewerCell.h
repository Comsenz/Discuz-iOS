//
//  LiveViewerCell.h
//  DiscuzMobile
//
//  Created by HB on 2017/8/28.
//  Copyright © 2017年 comsenz-service.com.  All rights reserved.
//

#import "BaseDTCell.h"

@class LiveDetailModel;

@interface LiveViewerCell : BaseDTCell

@property (nonatomic, strong) UIView *imageBgV;
@property (nonatomic, strong) NSMutableArray *imagesArray;
@property (nonatomic, strong) NSMutableArray *thumbArray;

@property (nonatomic, strong) UIImageView *headIcon;
@property (nonatomic, strong) UILabel *nameLab;
@property (nonatomic, strong) UILabel *gradeLab;
@property (nonatomic, strong) UILabel *timeLab;

- (void)setInfo:(LiveDetailModel *)model;

@end
