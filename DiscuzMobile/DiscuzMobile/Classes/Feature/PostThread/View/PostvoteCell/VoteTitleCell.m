//
//  VoteTitleCell.m
//  DiscuzMobile
//
//  Created by HB on 16/11/30.
//  Copyright © 2016年 comsenz-service.com.  All rights reserved.
//

#import "VoteTitleCell.h"

@interface VoteTitleCell()

@property (nonatomic, strong) UIView *lineV;

@end

@implementation VoteTitleCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self p_setupViews];
    }
    return self;
}

- (void)p_setupViews {
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.titleTextField = [[UITextField alloc] initWithFrame:CGRectMake(15, 5, WIDTH - 20, 45)];
    self.titleTextField.placeholder = @" 标题(最多只能输入80个字符)";
    self.titleTextField.font = [FontSize HomecellTitleFontSize15];
    [self.contentView addSubview:self.titleTextField];
}


- (void)layoutSubviews {
    [super layoutSubviews];
    self.titleTextField.frame = CGRectMake(10, 5, WIDTH, 45);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
