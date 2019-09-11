//
//  PmlistCell.m
//  DiscuzMobile
//
//  Created by HB on 2017/7/17.
//  Copyright © 2017年 comsenz-service.com.  All rights reserved.
//

#import "PmlistCell.h"
#import "HorizontalImageTextView.h"

@implementation PmlistCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self p_setupView];
    }
    return self;
}

- (void)p_setupView {
    self.iconV = [[UIImageView alloc] init];
    self.iconV.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:self.iconV];
    
    self.titleLab = [[UILabel alloc] init];
    //    self.detailLab.backgroundColor= [UIColor redColor];
    self.titleLab.textAlignment = NSTextAlignmentLeft;
    self.titleLab.textColor = MAIN_TITLE_COLOR;
    self.titleLab.font = [FontSize HomecellNameFontSize16];
    [self.contentView addSubview:self.titleLab];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.iconV.frame = CGRectMake(14, 13, 18, 18);
    self.titleLab.frame = CGRectMake(CGRectGetMaxX(self.iconV.frame) + 8, 10, 180, 24);
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
