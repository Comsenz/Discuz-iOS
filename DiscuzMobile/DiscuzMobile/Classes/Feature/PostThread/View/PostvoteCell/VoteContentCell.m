//
//  VoteContentCell.m
//  DiscuzMobile
//
//  Created by HB on 16/11/30.
//  Copyright © 2016年 comsenz-service.com.  All rights reserved.
//

#import "VoteContentCell.h"

@implementation VoteContentCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self p_setupViews];
    }
    return self;
}

- (void)p_setupViews {
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.textField = [[UITextField alloc] initWithFrame:CGRectMake(10, 10, CGRectGetWidth(self.frame) - 20 - 60, CGRectGetHeight(self.frame) - 20)];
    self.textField.placeholder = @"    请输入投票选项";
    self.textField.font = [FontSize HomecellTitleFontSize15];
    self.textField.layer.borderWidth = 1.0;
    self.textField.layer.cornerRadius = 4.0;
    self.textField.layer.borderColor = LINE_COLOR.CGColor;
    [self.contentView addSubview:self.textField];
    
    self.postImageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.postImageBtn.frame = CGRectMake(CGRectGetWidth(self.frame) - 60, CGRectGetMinY(self.textField.frame), 55, CGRectGetHeight(self.textField.frame));
//    [self.postImageBtn setImage:[UIImage imageNamed:@"votiPostImage"] forState:UIControlStateNormal];
    [self.postImageBtn setBackgroundImage:[UIImage imageNamed:@"votiPostImage"] forState:UIControlStateNormal];
//    [self.postImageBtn setHidden:YES];
    [self.contentView addSubview:self.postImageBtn];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.textField.frame = CGRectMake(10, 10, CGRectGetWidth(self.frame) - 20 - 100, CGRectGetHeight(self.frame) - 20);
    self.postImageBtn.frame = CGRectMake(CGRectGetWidth(self.frame) - 90, CGRectGetMinY(self.textField.frame), 80, CGRectGetHeight(self.textField.frame));
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
