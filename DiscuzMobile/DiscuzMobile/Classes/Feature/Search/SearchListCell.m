//
//  SearchListCell.m
//  DiscuzMobile
//
//  Created by ZhangJitao on 2018/7/11.
//  Copyright © 2018年 Cjk. All rights reserved.
//

#import "SearchListCell.h"
#import "TTSearchModel.h"

@implementation SearchListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self commitInit];
    }
    return self;
}

- (void)commitInit {
    [self.contentView addSubview:self.contentLabel];
    [self.contentView addSubview:self.timeLabel];
    [self.contentView addSubview:self.evaluateLabel];
    
    self.contentLabel.numberOfLines = 3;
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(@10);
        make.width.mas_equalTo(WIDTH - 20);
    }];
    
    CGFloat textW = (WIDTH - 30) / 2;
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentLabel);
        make.top.equalTo(self.contentLabel.mas_bottom).offset(10);
        make.width.mas_equalTo(textW);
    }];
    
    [self.evaluateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.timeLabel.mas_right).offset(10);
        make.top.equalTo(self.timeLabel);
        make.width.equalTo(self.timeLabel);
    }];
}

- (void)setInfo:(TTSearchModel *)info {
    NSRange range = [info.subject rangeOfString:info.keyword];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:info.subject];
    [str addAttribute:NSForegroundColorAttributeName value:MAIN_COLLOR range:range];
    [str addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:17] range:range];
    self.contentLabel.attributedText = str;
    self.timeLabel.text = info.dateline;
    self.evaluateLabel.text = [NSString stringWithFormat:@"%@个评论",info.replies];
}
- (CGFloat)caculateCellHeight:(TTSearchModel *)info {
    self.info = info;
    [self layoutIfNeeded];
    return [self cellHeight];
}

- (CGFloat)cellHeight {
    return CGRectGetMaxY(self.timeLabel.frame) + 10;
}

- (UILabel *)contentLabel {
    if (_contentLabel == nil) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.font = [FontSize HomecellTitleFontSize17];
    }
    return _contentLabel;
}

- (UILabel *)timeLabel {
    if (_timeLabel == nil) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.font = [FontSize forumtimeFontSize14];
        _timeLabel.textColor = LIGHT_TEXT_COLOR;
    }
    return  _timeLabel;
}

- (UILabel *)evaluateLabel {
    if (_evaluateLabel == nil) {
        _evaluateLabel = [[UILabel alloc] init];
        _evaluateLabel.font = [FontSize forumtimeFontSize14];
        _evaluateLabel.textColor = LIGHT_TEXT_COLOR;
    }
    return _evaluateLabel;
}

@end
