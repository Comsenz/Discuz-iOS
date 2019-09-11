//
//  ActivityApplyReplyCell.m
//  DiscuzMobile
//
//  Created by HB on 2017/7/31.
//  Copyright © 2017年 comsenz-service.com.  All rights reserved.
//

#import "ActivityApplyReplyCell.h"

@implementation ActivityApplyReplyCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self commitInit];
    }
    return self;
}

- (void)commitInit {
    self.tipLab = [[UILabel alloc] init];
    self.tipLab.font = [FontSize HomecellTimeFontSize14];
    self.tipLab.textColor = LIGHT_TEXT_COLOR;
    [self.contentView addSubview:self.tipLab];
    
    self.detailView = [[UITextView alloc] init];
    self.detailView.font = [FontSize forumtimeFontSize14];
    self.detailView.layer.borderColor = LINE_COLOR.CGColor;
    self.detailView.layer.borderWidth = 1;
    [self.contentView addSubview:self.detailView];

}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.tipLab.frame = CGRectMake(15, 0, 69, 38);
    
    self.detailView.frame = CGRectMake(CGRectGetMaxX(self.tipLab.frame), 12, CGRectGetWidth(self.contentView.frame) - 69 - 30, 38 * 3);
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
