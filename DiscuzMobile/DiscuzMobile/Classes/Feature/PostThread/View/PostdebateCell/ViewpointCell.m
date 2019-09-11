//
//  ViewpointCell.m
//  DiscuzMobile
//
//  Created by HB on 2017/6/23.
//  Copyright © 2017年 comsenz-service.com.  All rights reserved.
//

#import "ViewpointCell.h"

@implementation ViewpointCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self commitInit];
    }
    return self;
}

- (void)commitInit {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.positiveLab.text = @"正方观点";
    [self.contentView addSubview:self.positiveLab];
    self.oppositeLab.text = @"反方观点";
    [self.contentView addSubview:self.oppositeLab];
    [self.contentView addSubview:self.positiveTextView];
    [self.contentView addSubview:self.oppositeTextView];
}


- (void)layoutSubviews {
    [super layoutSubviews];
    self.positiveLab.frame = CGRectMake(10, 10, 200, 20);
    self.positiveTextView.frame  = CGRectMake(CGRectGetMinX(self.positiveLab.frame), CGRectGetMaxY(self.positiveLab.frame) + 10, WIDTH - 20, 80); // 120
    self.positiveTextView.layer.cornerRadius = 4;
    
    self.oppositeLab.frame  = CGRectMake(CGRectGetMinX(self.positiveTextView.frame), CGRectGetMaxY(self.positiveTextView.frame) + 15, CGRectGetWidth(self.positiveLab.frame), CGRectGetHeight(self.positiveLab.frame)); // 155
    self.oppositeTextView.frame = CGRectMake(CGRectGetMinX(self.oppositeLab.frame), CGRectGetMaxY(self.oppositeLab.frame) + 10, WIDTH - 20, 80); // 245
    self.oppositeTextView.layer.cornerRadius = 4;
    
}


- (UILabel *)positiveLab {
    if (_positiveLab == nil) {
        _positiveLab = [self getTypeLabel];
    }
    return _positiveLab;
}

- (UILabel *)oppositeLab {
    if (_oppositeLab == nil) {
        _oppositeLab = [self getTypeLabel];
    }
    return _oppositeLab;
}

- (JTPlaceholderTextView *)positiveTextView {
    if (_positiveTextView == nil) {
        _positiveTextView = [self getTypeTextview];
    }
    return _positiveTextView;
}

- (JTPlaceholderTextView *)oppositeTextView {
    if (_oppositeTextView == nil) {
        _oppositeTextView = [self getTypeTextview];
    }
    return _oppositeTextView;
}

- (UILabel *)getTypeLabel {
    UILabel *lab = [[UILabel alloc] init];
    lab.font = [FontSize HomecellTitleFontSize15];
    lab.textAlignment = NSTextAlignmentLeft;
    return lab;
}
- (JTPlaceholderTextView *)getTypeTextview {
    JTPlaceholderTextView *textview = [[JTPlaceholderTextView alloc] init];
    textview.placeholder = @"  请输入投票选项";
    textview.layer.borderWidth = 1;
    textview.layer.masksToBounds = YES;
    textview.layer.borderColor = LINE_COLOR.CGColor;
    textview.font = [FontSize HomecellTitleFontSize15];
    return textview;
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
