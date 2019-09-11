//
//  LiveRecommentView.m
//  DiscuzMobile
//
//  Created by HB on 2017/5/5.
//  Copyright © 2017年 comsenz-service.com.  All rights reserved.
//

#import "LiveRecommentView.h"

@implementation LiveRecommentView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commitInit];
    }
    return self;
}

- (void)commitInit {
    _picView = [[UIImageView alloc] init];
    _picView.clipsToBounds = YES;
    _picView.contentMode = UIViewContentModeScaleAspectFill;
    _picView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self addSubview:self.picView];
    
    _titleLab = [[UILabel alloc] init];
    _titleLab.textColor = MAIN_TITLE_COLOR;
    _titleLab.font = [FontSize HomecellNameFontSize16];
    _titleLab.numberOfLines = 2;
    [self addSubview:self.titleLab];
    
    [self viewMakeContranints];
    
}

- (void)viewMakeContranints {
    
    CGFloat heightP = (WIDTH == 320) ? 0.63 : 0.65;
    
    [_picView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(@0);
        make.width.equalTo(self);
        make.height.equalTo(self).multipliedBy(heightP);
    }];
    
    [_titleLab mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0);
        make.top.equalTo(self.picView.mas_bottom).offset(5);
        make.width.equalTo(self);
    }];
}

@end
