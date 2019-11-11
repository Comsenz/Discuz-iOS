//
//  CollectionForumCell.m
//  DiscuzMobile
//
//  Created by HB on 17/1/22.
//  Copyright © 2017年 comsenz-service.com.  All rights reserved.
//

#import "CollectionForumCell.h"

@implementation CollectionForumCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self commitInit];
    }
    return self;
}

- (void)commitInit {
    self.iconV = [[UIImageView alloc] init];
    self.iconV.image = [UIImage imageNamed:@"forumCommon_l"];
    [self.contentView addSubview:self.iconV];
    
    self.textLab = [[UILabel alloc] init];
    self.textLab.font = [FontSize HomecellTitleFontSize17];
    self.textLab.textColor = MAIN_TITLE_COLOR;
    [self.contentView addSubview:self.textLab];
    
    self.cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.cancelBtn.cs_acceptEventInterval = 1;
    [self.cancelBtn setImage:[UIImage imageNamed:@"bar_xings"] forState:UIControlStateNormal];
    [self.contentView addSubview:self.cancelBtn];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.iconV.frame = CGRectMake(15, 10, 40, 40);
    self.iconV.layer.masksToBounds = YES;
    self.iconV.layer.cornerRadius = 6;
    self.textLab.frame = CGRectMake(CGRectGetMaxX(self.iconV.frame) + 10, CGRectGetMinY(self.iconV.frame), 150, CGRectGetHeight(self.iconV.frame));
    self.cancelBtn.frame = CGRectMake(WIDTH - 25 - 15, 17, 25, 25);
}

@end
