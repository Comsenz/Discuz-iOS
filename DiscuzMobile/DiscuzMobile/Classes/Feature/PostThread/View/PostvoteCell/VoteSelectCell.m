//
//  VoteSelectCell.m
//  DiscuzMobile
//
//  Created by HB on 16/11/30.
//  Copyright © 2016年 comsenz-service.com.  All rights reserved.
//

#import "VoteSelectCell.h"

@interface VoteSelectCell()

//@property (nonatomic, strong) UILabel *lineLabel;

@end

@implementation VoteSelectCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self p_setupViews];
    }
    return self;
}

- (void)p_setupViews {
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.titleLab = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 100, 20)];
    self.titleLab.backgroundColor = [UIColor whiteColor];
    self.titleLab.text = @"选项类型";
    self.titleLab.textColor = MAIN_TITLE_COLOR;
    self.titleLab.font = [FontSize HomecellTimeFontSize14];
    [self.contentView addSubview:self.titleLab];
    
    self.singleRadio = [[QRadioButton alloc] initWithDelegate:self groupId:@"groupId1"];
    self.singleRadio.frame = CGRectMake(10, CGRectGetMaxY(self.titleLab.frame) + 10, 60, 30);
    [self.singleRadio setTitle:@"单选" forState:UIControlStateNormal];
    [self.singleRadio setTitleColor:MAIN_TITLE_COLOR forState:UIControlStateNormal];
    self.singleRadio.titleLabel.font = [FontSize HomecellNameFontSize16];
    
    [self.singleRadio setImage:[UIImage imageNamed:@"option"] forState:(UIControlStateNormal)];
    [self.singleRadio setImage:[UIImage imageNamed:@"option_select"] forState:(UIControlStateSelected)];
    [self.contentView addSubview:self.singleRadio];
    
    self.multiRadio = [[QRadioButton alloc] initWithDelegate:self groupId:@"groupId1"];
    self.multiRadio.frame = CGRectMake(CGRectGetMaxX(self.singleRadio.frame) + 30, CGRectGetMinY(self.singleRadio.frame), CGRectGetWidth(self.singleRadio.frame), CGRectGetHeight(self.singleRadio.frame));
    [self.multiRadio setTitle:@"多选" forState:UIControlStateNormal];
    [self.multiRadio setTitleColor:MAIN_TITLE_COLOR forState:UIControlStateNormal];
    self.multiRadio.titleLabel.font = [FontSize HomecellNameFontSize16];
    [self.multiRadio setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.multiRadio setImage:[UIImage imageNamed:@"option"] forState:UIControlStateNormal];
    [self.multiRadio setImage:[UIImage imageNamed:@"option_select"] forState:UIControlStateSelected];
    
    [self.contentView addSubview:self.multiRadio];
    
//    self.lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.frame), CGRectGetWidth(self.frame) - 20, 1)];
//    self.lineLabel.backgroundColor = mRGBColor(211, 211, 211);
//    [self.contentView addSubview:self.lineLabel];
    
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
