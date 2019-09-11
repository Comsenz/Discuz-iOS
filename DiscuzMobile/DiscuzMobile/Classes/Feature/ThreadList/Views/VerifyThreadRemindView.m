//
//  VerifyThreadRemindView.m
//  DiscuzMobile
//
//  Created by ZhangJitao on 2018/7/16.
//  Copyright © 2018年 comsenz-service.com.  All rights reserved.
//

#import "VerifyThreadRemindView.h"

@interface VerifyThreadRemindView()
@property (nonatomic, strong) UIView *sepView;
@end

@implementation VerifyThreadRemindView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
    }
    return self;
}

- (void)initUI {
    self.backgroundColor = mRGBColor(254, 254, 234);
    [self addSubview:self.textLabel];
    [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(@0);
        make.height.equalTo(self).offset(-5);
        make.width.equalTo(self);
    }];
    
    [self addSubview:self.sepView];
    [self.sepView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.width.equalTo(self);
        make.height.equalTo(@5);
    }];
    
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickRemind)];
    [self addGestureRecognizer:tap];
}

- (void)clickRemind {
    self.clickRemindBlock?self.clickRemindBlock():nil;
}

- (UILabel *)textLabel {
    if (!_textLabel) {
        _textLabel = [[UILabel alloc] init];
        _textLabel.font = [UIFont systemFontOfSize:14];
        _textLabel.textAlignment = NSTextAlignmentCenter;
        _textLabel.textColor = MAIN_COLLOR;
    }
    return _textLabel;
}

- (UIView *)sepView {
    if (!_sepView) {
        _sepView = [[UIView alloc] init];
        _sepView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    }
    return _sepView;
}
@end
