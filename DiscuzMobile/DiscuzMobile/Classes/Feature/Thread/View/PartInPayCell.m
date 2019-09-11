//
//  PartInPayCell.m
//  DiscuzMobile
//
//  Created by HB on 2017/8/4.
//  Copyright © 2017年 comsenz-service.com.  All rights reserved.
//

#import "PartInPayCell.h"

@implementation PartInPayCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self commitInit];
    }
    return self;
}

- (void)commitInit {
    _tipLab = [[UILabel alloc] init];
    _tipLab.font = [FontSize forumInfoFontSize12];
    _tipLab.textColor = [UIColor orangeColor];
    [self.contentView addSubview:self.tipLab];
    
    _tipLab2 = [[UILabel alloc] init];
    _tipLab2.font = [FontSize forumInfoFontSize12];
    _tipLab2.text = @"支付方式:";
    [self.contentView addSubview:self.tipLab2];
    
    
    _selfRadio = [[QRadioButton alloc] initWithDelegate:self groupId:@"selfId1"];
    [_selfRadio setImage:[UIImage imageNamed:@"option"] forState:(UIControlStateNormal)];
    [_selfRadio setImage:[UIImage imageNamed:@"option_select"] forState:(UIControlStateSelected)];
    [_selfRadio setTitle:@"自己承担应付的花销" forState:UIControlStateNormal];
    [_selfRadio setTitleColor:MAIN_TITLE_COLOR forState:UIControlStateNormal];
    _selfRadio.titleLabel.font = [FontSize HomecellTimeFontSize14];
    [self.contentView addSubview:self.selfRadio];
    
    _payRadio = [[QRadioButton alloc] initWithDelegate:self groupId:@"selfId1"];
    [_payRadio setImage:[UIImage imageNamed:@"option"] forState:(UIControlStateNormal)];
    [_payRadio setImage:[UIImage imageNamed:@"option_select"] forState:(UIControlStateSelected)];
    [_payRadio setTitle:@"支付" forState:UIControlStateNormal];
    [_payRadio setTitleColor:MAIN_TITLE_COLOR forState:UIControlStateNormal];
    _payRadio.titleLabel.font = [FontSize HomecellTimeFontSize14];
    [self.contentView addSubview:self.payRadio];
    
    _payTextField = [[UITextField alloc] init];
    _payTextField.font = [FontSize HomecellTimeFontSize14];
    _payTextField.keyboardType = UIKeyboardTypeNumberPad;
    [self.contentView addSubview:self.payTextField];
    
    _yuanLab = [[UILabel alloc] init];
    _yuanLab.font = [FontSize HomecellTimeFontSize14];
    _yuanLab.text = @"元";
    [self.contentView addSubview:_yuanLab];
    
}

// 90
- (void)layoutSubviews {
    [super layoutSubviews];
//    self.tipLab.frame = CGRectMake(15, 15, WIDTH - 30, 20);
    self.tipLab.frame = CGRectMake(15, 0, WIDTH - 30, 0);
    
    self.tipLab2.frame = CGRectMake(CGRectGetMinX(self.tipLab.frame), CGRectGetMaxY(self.tipLab.frame) + 15, 80, 20);
    self.selfRadio.frame = CGRectMake(CGRectGetMaxX(self.tipLab2.frame) + 10, CGRectGetMinY(self.tipLab2.frame), 150, 20);
    self.payRadio.frame = CGRectMake(CGRectGetMinX(self.selfRadio.frame), CGRectGetMaxY(self.selfRadio.frame) + 10, 60, 20);
    self.payTextField.frame = CGRectMake(CGRectGetMaxX(self.payRadio.frame) + 5, CGRectGetMinY(self.payRadio.frame), 60, 20);
    self.payTextField.layer.borderColor = LINE_COLOR.CGColor;
    self.payTextField.layer.borderWidth = 1;
    self.yuanLab.frame = CGRectMake(CGRectGetMaxX(self.payTextField.frame) + 5, CGRectGetMinY(self.payRadio.frame), 20, 20);
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
