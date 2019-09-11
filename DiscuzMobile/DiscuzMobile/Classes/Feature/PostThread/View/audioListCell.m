//
//  audioListCell.m
//  DiscuzMobile
//
//  Created by HB on 2017/6/8.
//  Copyright © 2017年 comsenz-service.com.  All rights reserved.
//

#import "audioListCell.h"

@implementation audioListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self p_setupViews];
    }
    return self;
}

- (void) p_setupViews {
    self.audioIv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"audio_list"]];
    self.audioIv.backgroundColor = [UIColor whiteColor];
    
    [self.contentView addSubview:self.audioIv];
    
    self.timeLabel = [[UILabel alloc] init];
    self.timeLabel.textAlignment = NSTextAlignmentLeft;
    self.timeLabel.textColor = MAIN_TITLE_COLOR;
    self.timeLabel.font = [FontSize HomecellTitleFontSize15];
    
//    self.audioIv.frame = CGRectMake(15, 12, CGRectGetHeight(self.frame) - 24, CGRectGetHeight(self.frame) - 24);
//    self.timeLabel.frame = CGRectMake(CGRectGetMaxX(self.audioIv.frame) + 20, CGRectGetMinY(self.audioIv.frame), 100, CGRectGetHeight(self.audioIv.frame));
    
    [self.contentView addSubview:self.timeLabel];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.audioIv.frame = CGRectMake(15, 12, CGRectGetHeight(self.frame) - 24, CGRectGetHeight(self.frame) - 24);
    self.timeLabel.frame = CGRectMake(CGRectGetMaxX(self.audioIv.frame) + 20, CGRectGetMinY(self.audioIv.frame), 100, CGRectGetHeight(self.audioIv.frame));
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
