//
//  DropTipView.m
//  DiscuzMobile
//
//  Created by ZhangJitao on 2018/7/13.
//  Copyright © 2018年 comsenz-service.com.  All rights reserved.
//

#import "DropTipView.h"
#import "UIButton+EnlargeEdge.h"

@implementation DropTipView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
    }
    return self;
}

- (void)initUI {
    self.backgroundColor = [UIColor orangeColor];
    self.alpha = 0.8;
    
    [self addSubview:self.tipLabel];
    [self addSubview:self.closeBtn];
    
    [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@40);
        make.width.equalTo(@(WIDTH - 80));
        make.top.bottom.equalTo(self);
    }];
    
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(- 20);
        make.width.height.equalTo(@15);
        make.centerY.equalTo(self.tipLabel);
    }];
    
    [self.closeBtn setEnlargeEdgeWithTop:15 right:20 bottom:15 left:5];
}

- (void)clickTip {
    self.clickTipAction?self.clickTipAction():nil;
}

- (UIButton *)closeBtn {
    if (!_closeBtn) {
        _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeBtn setImage:[UIImage imageNamed:@"type_close"] forState:UIControlStateNormal];
    }
    return _closeBtn;
}

- (UILabel *)tipLabel {
    if (!_tipLabel) {
        _tipLabel = [[UILabel alloc] init];
        _tipLabel.textAlignment =  NSTextAlignmentCenter;
        _tipLabel.font = [FontSize messageFontSize14];
        _tipLabel.textColor = [UIColor whiteColor];
        _tipLabel.userInteractionEnabled = YES;
        [_tipLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickTip)]];
    }
    return _tipLabel;
}

@end
