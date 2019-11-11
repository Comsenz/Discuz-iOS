//
//  VoteDayVisableCell.m
//  DiscuzMobile
//
//  Created by HB on 16/11/30.
//  Copyright © 2016年 comsenz-service.com.  All rights reserved.
//

#import "VoteDayVisableCell.h"

@implementation VoteDayVisableCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self p_setupViews];
    }
    return self;
}

- (void)p_setupViews {
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UILabel *tipSelect = [[UILabel alloc] initWithFrame:CGRectMake(10, 20, 60, 20)];
    tipSelect.text = @"最多可选";
    tipSelect.font = [DZFontSize HomecellTitleFontSize15];
    [self.contentView addSubview:tipSelect];
    
    self.selectNumTextField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(tipSelect.frame) + 10, 12, KScreenWidth - CGRectGetWidth(tipSelect.frame) - 20 - 30 - 15, 35)];
    self.selectNumTextField.placeholder = @"  最多可选";
    self.selectNumTextField.keyboardType = UIKeyboardTypeNumberPad;
    self.selectNumTextField.layer.borderWidth = 1.0;
    self.selectNumTextField.layer.cornerRadius = 4.0;
    self.selectNumTextField.text = @"1";
    self.selectNumTextField.font = [DZFontSize HomecellTitleFontSize15];
    self.selectNumTextField.layer.borderColor = K_Color_Line.CGColor;
    
    UILabel *itemLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.selectNumTextField.frame) + 10,CGRectGetMinY(self.selectNumTextField.frame) + 10, 30, 15)];
    itemLab.font = [DZFontSize HomecellTitleFontSize15];
    itemLab.text =@"项";
    [self.contentView addSubview:itemLab];
    
    [self.contentView addSubview:self.selectNumTextField];
    
    UILabel *tipDay = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.selectNumTextField.frame) + 20, 60, 20)];
    tipDay.text = @"计票天数";
    tipDay.font = [DZFontSize HomecellTitleFontSize15];
    [self.contentView addSubview:tipDay];
    
    self.dayNumTextField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(tipSelect.frame) + 10, CGRectGetMaxY(self.selectNumTextField.frame) + 10, KScreenWidth - CGRectGetWidth(tipSelect.frame) - 20 - 30 - 15, 35)];
    self.dayNumTextField.placeholder = @"  计票天数";
    self.dayNumTextField.keyboardType = UIKeyboardTypeNumberPad;
    self.dayNumTextField.layer.borderWidth = 1.0;
    self.dayNumTextField.layer.cornerRadius = 4.0;
    self.dayNumTextField.font = [DZFontSize HomecellTitleFontSize15];
    self.dayNumTextField.layer.borderColor = K_Color_Line.CGColor;
    
    [self.contentView addSubview:self.dayNumTextField];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.dayNumTextField.frame) + 10,CGRectGetMinY(self.dayNumTextField.frame) + 10, 30, 15)];
    label.font = [DZFontSize HomecellTitleFontSize15];
    label.text =@"天";
    [self.contentView addSubview:label];
    
    UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.dayNumTextField.frame) + 25, KScreenWidth-20, 1)];
    lineLabel.backgroundColor = mRGBColor(211, 211, 211);
    [self.contentView addSubview:lineLabel];
    
    self.checkBox = [[QCheckBox alloc] initWithDelegate:self];;
    self.checkBox.frame = CGRectMake(10, CGRectGetMaxY(lineLabel.frame) + 15, 155, 30);
    self.checkBox.titleLabel.font = [DZFontSize HomecellTimeFontSize16];
    [self.checkBox setTitle:@"投票后结果可见" forState:UIControlStateNormal];
    [self.checkBox setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.checkBox setImage:[UIImage imageNamed:@"check"] forState:UIControlStateNormal];
    [self.checkBox setImage:[UIImage imageNamed:@"check_select"] forState:UIControlStateSelected];
    
    [self.contentView addSubview:self.checkBox];
    
    
    
    
    self.checkBox1 = [[QCheckBox alloc] initWithDelegate:self];
    
    self.checkBox1.frame = CGRectMake(CGRectGetMaxX(self.checkBox.frame) + 20, CGRectGetMinY(self.checkBox.frame), 155, 30);
    self.checkBox1.titleLabel.font = [DZFontSize HomecellTimeFontSize16];
    [self.checkBox1 setTitle:@"公开投票参与人" forState:UIControlStateNormal];
    [self.checkBox1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.checkBox1 setImage:[UIImage imageNamed:@"check"] forState:UIControlStateNormal];
    [self.checkBox1 setImage:[UIImage imageNamed:@"check_select"] forState:UIControlStateSelected];
    
    [self.contentView addSubview:self.checkBox1];
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
