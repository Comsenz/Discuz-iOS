//
//  PartInSelectCell.m
//  DiscuzMobile
//
//  Created by HB on 2017/8/4.
//  Copyright © 2017年 comsenz-service.com.  All rights reserved.
//

#import "PartInSelectCell.h"

@implementation PartInSelectCell

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
    
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    self.titleLab.frame = CGRectMake(15, 10, 80, 25);
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
