//
//  ForumReusableView.m
//  DiscuzMobile
//
//  Created by HB on 17/5/2.
//  Copyright © 2017年 comsenz-service.com.  All rights reserved.
//

#import "ForumReusableView.h"
#import "TreeViewNode.h"

@interface ForumReusableView()

@property (nonatomic, strong) UIView *sepLine;

@end

@implementation ForumReusableView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
//    self.backgroundColor = [UIColor whiteColor];
    //    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    [self addSubview:self.button];
    [self addSubview:self.textLab];
    [self addSubview:self.sepLine];
    
    [self.textLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@10);
        make.centerY.equalTo(self);
        make.width.mas_equalTo(WIDTH - 85);
    }];
    
    [self.button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-5);
        make.centerY.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    
    [self.sepLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0);
        make.bottom.equalTo(self).offset(-0.5);
        make.width.mas_equalTo(WIDTH);
        make.height.equalTo(@0.5);
    }];

}


/**
 * 设置可折叠的cell数据
 */
- (void)setNode:(TreeViewNode *)node {
    
    NSString *openStr;
    if (node.nodeLevel == 0) {
        if (node.isExpanded) {
            openStr = @"open";
        } else {
            openStr = @"close";
        }
    }
    
    [self.button setImage:[UIImage imageTintColorWithName:openStr andImageSuperView:self.button] forState:UIControlStateNormal];
    _node = node;
    self.textLab.text = node.nodeName;
    
    [self layoutIfNeeded];
}


- (UIView *)sepLine {
    if (_sepLine == nil) {
        _sepLine = [[UIView alloc] init];
        _sepLine.backgroundColor = LINE_COLOR;
    }
    return _sepLine;
}

- (UILabel *)textLab {
    if (_textLab == nil) {
        _textLab = [[UILabel alloc] init];
        _textLab.font = [FontSize HomecellTitleFontSize17];
        _textLab.textColor = MAIN_COLLOR;
    }
    return _textLab;
}

- (UIButton *)button {
    if (_button == nil) {
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        _button.userInteractionEnabled = NO;
        [_button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [_button setImage:[UIImage imageTintColorWithName:@"close" andImageSuperView:_button] forState:UIControlStateNormal];
    }
    return _button;
}
@end
