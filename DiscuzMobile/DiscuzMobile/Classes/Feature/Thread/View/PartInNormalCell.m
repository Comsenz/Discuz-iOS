//
//  PartInNormalCell.m
//  DiscuzMobile
//
//  Created by HB on 2017/8/4.
//  Copyright © 2017年 comsenz-service.com.  All rights reserved.
//

#import "PartInNormalCell.h"

@implementation PartInNormalCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self commitInit];
    }
    return self;
}

- (void)commitInit {
    self.titleLab = [[UILabel alloc] init];
    self.titleLab.textColor = MESSAGE_COLOR;
    self.titleLab.font = [FontSize HomecellTimeFontSize14];
    [self.contentView addSubview:self.titleLab];
    
    self.textField = [[UITextField alloc] init];
    self.textField.font = [FontSize HomecellTimeFontSize14];
    [self.contentView addSubview:self.textField];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.titleLab.frame = CGRectMake(15, 10, 80, 25);
    self.textField.frame = CGRectMake(CGRectGetMaxX(self.titleLab.frame) + 10, CGRectGetMinY(self.titleLab.frame), WIDTH - CGRectGetMaxX(self.titleLab.frame) - 5, CGRectGetHeight(self.titleLab.frame));
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
