//
//  DZBaseTableViewCell.m
//  PandaReader
//
//  Created by 孙震 on 2019/5/13.
//  Copyright © 2019 ZHWenXue. All rights reserved.
//

#import "DZBaseTableViewCell.h"

@implementation DZBaseTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self loadSetting];
    }
    return self;
}

- (void)loadSetting {
    self.selectedBackgroundView = [[UIView alloc] initWithFrame:self.frame];
    self.selectedBackgroundView.backgroundColor = KColor(KF7F7F8_Color, 1);
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
