//
//  JudgeBoundView.m
//  DiscuzMobile
//
//  Created by HB on 16/10/27.
//  Copyright © 2016年 Cjk. All rights reserved.
//

#import "JudgeBoundView.h"

@implementation JudgeBoundView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    if (@available(iOS 11.0, *)) {
        self.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    self.contentSize = CGSizeMake(WIDTH, HEIGHT + 1);
    
    _headView = [[UIImageView alloc] initWithFrame:CGRectMake((WIDTH - 98) / 2, 22, 98, 98)];
    _headView.image = [UIImage imageNamed:@"defaultHead"];
    
    [self addSubview:_headView];
    
    _desclabl = [[UILabel alloc] initWithFrame:CGRectMake(8, CGRectGetMaxY(_headView.frame) + 22, WIDTH - 16, 60)];
    _desclabl.numberOfLines = 0;
    [self addSubview:_desclabl];
    
    UILabel *notips = [[UILabel alloc] initWithFrame:CGRectMake(8, CGRectGetMaxY(_desclabl.frame) + 22, WIDTH - 16, 40)];
    notips.text = @"还没有论坛账户？";
    notips.font = [FontSize HomecellTimeFontSize16];
    notips.textColor = LIGHT_TEXT_COLOR;
    [self addSubview:notips];
    
    _registerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _registerBtn.frame = CGRectMake(10, CGRectGetMaxY(notips.frame) + 10, WIDTH-20, 44);
    [_registerBtn setTitle:@"立即注册" forState:UIControlStateNormal];
    _registerBtn.backgroundColor = MAIN_COLLOR;
    _registerBtn.layer.cornerRadius = 5.0;
    [self addSubview:_registerBtn];
    
    UILabel *havetips = [[UILabel alloc] initWithFrame:CGRectMake(8, CGRectGetMaxY(_registerBtn.frame) + 22, WIDTH - 16, 40)];
    havetips.text = @"已有论坛账号！";
    havetips.font = [FontSize HomecellTimeFontSize16];
    havetips.textColor = LIGHT_TEXT_COLOR;
    [self addSubview:havetips];
    
    _boundBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    _boundBtn.frame = CGRectMake(10, CGRectGetMaxY(havetips.frame) + 10, WIDTH-20, 44);
    [_boundBtn setTitleColor:MAIN_COLLOR forState:UIControlStateNormal];
    _boundBtn.layer.borderColor = mRGBColor(210, 210, 210).CGColor;
    _boundBtn.layer.borderWidth = 0.5;
    [_boundBtn setTitle:@"立即关联" forState:UIControlStateNormal];
    _boundBtn.backgroundColor = [UIColor whiteColor];
    _boundBtn.layer.cornerRadius = 5.0;
    [self addSubview:_boundBtn];
}

@end
