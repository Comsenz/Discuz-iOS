//
//  RootForumCell.m
//  DiscuzMobile
//
//  Created by HB on 17/1/23.
//  Copyright © 2017年 comsenz-service.com.  All rights reserved.
//

#import "RootForumCell.h"
#import "TreeViewNode.h"

@interface RootForumCell()

@property (nonatomic, strong) UIView *sepLine;

@end

@implementation RootForumCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupViews];
    }
    return self;
}

- (UIView *)sepLine {
    if (_sepLine == nil) {
        _sepLine = [[UIView alloc] init];
        _sepLine.backgroundColor = NAV_SEP_COLOR;
    }
    return _sepLine;
}

- (UILabel *)textLab {
    if (_textLab == nil) {
        _textLab = [[UILabel alloc] init];
        _textLab.font = [FontSize HomecellTitleFontSize15];
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

- (void)setupViews {
    self.backgroundColor = [UIColor whiteColor];
//    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.contentView addSubview:self.button];
    
    [self.contentView addSubview:self.textLab];
    [self.contentView addSubview:self.sepLine];
}


/**
 * 设置可折叠的cell数据
 */
- (void)setNode:(TreeViewNode *)node {
    
    NSString *openStr;
    if (node.nodeLevel == 0) {
        self.accessoryType = UITableViewCellAccessoryNone;
        if (node.isExpanded) {
            openStr = @"open";
        } else {
            openStr = @"close";
        }
    }
    [self.button setImage:[UIImage imageTintColorWithName:openStr andImageSuperView:self.button] forState:UIControlStateNormal];
    
    self.textLab.frame = CGRectMake(15, 15,WIDTH - 85, 30);
    _node = node;
    self.button.frame = CGRectMake(WIDTH - 30 - 10, 15, 30, 30);
    self.textLab.text = node.nodeName;
    self.sepLine.frame = CGRectMake(15, 59.5, WIDTH - 15, 0.5);
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.textLab.frame = CGRectMake(15, (CGRectGetHeight(self.frame) - 30) / 2,WIDTH - 85, 30);
    self.button.frame = CGRectMake(WIDTH - 30 - 10, (CGRectGetHeight(self.frame) - 30) / 2, 30, 30);
    self.sepLine.frame = CGRectMake(0, CGRectGetHeight(self.frame) - 0.5, WIDTH , 0.5);
}

@end
