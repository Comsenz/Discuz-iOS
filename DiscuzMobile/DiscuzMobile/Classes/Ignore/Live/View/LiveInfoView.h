//
//  LiveInfoView.h
//  DiscuzMobile
//
//  Created by HB on 2017/5/10.
//  Copyright © 2017年 comsenz-service.com.  All rights reserved.
//

#import <UIKit/UIKit.h>
@class HotLivelistModel, TopLabel;

typedef void(^CollectionThreadBlock)(UIButton *sender);

@interface LiveInfoView : UIView

@property (nonatomic, strong) TopLabel *titleLab;
@property (nonatomic, strong) UIImageView *headIcon;
@property (nonatomic, strong) UILabel *nameLab;
@property (nonatomic, strong) UILabel *gradeLab;
@property (nonatomic, strong) UIButton *collectionBtn;

@property (nonatomic, copy) CollectionThreadBlock collectionBlock;

- (void)setInfo:(HotLivelistModel *)model;

@end
