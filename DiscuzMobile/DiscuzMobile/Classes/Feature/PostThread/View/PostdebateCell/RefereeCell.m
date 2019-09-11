//
//  RefereeCell.m
//  DiscuzMobile
//
//  Created by HB on 2017/6/23.
//  Copyright © 2017年 comsenz-service.com.  All rights reserved.
//

#import "RefereeCell.h"

@implementation RefereeCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self commitInit];
    }
    return self;
}

- (void)commitInit {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.contentView addSubview:self.titleLab];
    [self.contentView addSubview:self.contentTextfield];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.titleLab.frame = CGRectMake(10, 10, 50, 35);
    self.contentTextfield.frame = CGRectMake(CGRectGetMaxX(self.titleLab.frame) + 8, CGRectGetMinY(self.titleLab.frame), WIDTH - CGRectGetMaxX(self.titleLab.frame) - 20, 35);
}

- (UILabel *)titleLab {
    if (_titleLab == nil) {
        _titleLab = [[UILabel alloc] init];
        _titleLab.text = @"裁判";
        _titleLab.font = [FontSize forumtimeFontSize14];
        _titleLab.textAlignment = NSTextAlignmentLeft;
    }
    return _titleLab;
}

- (UITextField *)contentTextfield {
    if (_contentTextfield == nil) {
        _contentTextfield = [[UITextField alloc] init];
        _contentTextfield.placeholder = @"请输入裁判名称";
        _contentTextfield.font = [FontSize HomecellTitleFontSize15];
    }
    return _contentTextfield;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
