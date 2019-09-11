//
//  LiveHostCell.h
//  MyCoreTextDemo
//
//  Created by HB on 2017/8/28.
//  Copyright © 2017年 comsenz-service.com.  All rights reserved.
//

#import "BaseDTCell.h"
@class LiveDetailModel;

@interface LiveHostCell : BaseDTCell<DTWebClickDelegate>

@property (nonatomic, strong) UIView *imageBgV;
@property (nonatomic, strong) NSMutableArray *imagesArray;
@property (nonatomic, strong) NSMutableArray *thumbArray;

- (void)setInfo:(LiveDetailModel *)model;

@end
