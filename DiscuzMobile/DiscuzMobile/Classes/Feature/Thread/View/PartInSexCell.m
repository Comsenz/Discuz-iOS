//
//  PartInSexCell.m
//  DiscuzMobile
//
//  Created by HB on 2017/8/4.
//  Copyright © 2017年 comsenz-service.com.  All rights reserved.
//

#import "PartInSexCell.h"

@implementation PartInSexCell

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
    
    self.sexSelectView =[[SelectTipView alloc] init];
    self.sexSelectView.layer.masksToBounds = YES;
    self.sexSelectView.tipLab.text = @"保密";
    [self.contentView addSubview:self.sexSelectView];
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    self.titleLab.frame = CGRectMake(10, 10, 80, 30);
    self.sexSelectView.frame = CGRectMake(CGRectGetMaxX(self.titleLab.frame) + 10, CGRectGetMinY(self.titleLab.frame), WIDTH - CGRectGetMaxX(self.titleLab.frame) - 15, CGRectGetHeight(self.titleLab.frame));
    self.sexSelectView.layer.borderColor = LINE_COLOR.CGColor;
    self.sexSelectView.layer.borderWidth = 1;
    self.sexSelectView.layer.cornerRadius = 10;
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
