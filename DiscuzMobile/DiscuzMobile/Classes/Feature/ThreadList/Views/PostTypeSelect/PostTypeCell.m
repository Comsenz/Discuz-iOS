//
//  PostTypeCell.m
//  DiscuzMobile
//
//  Created by HB on 2017/5/8.
//  Copyright © 2017年 comsenz-service.com.  All rights reserved.
//

#import "PostTypeCell.h"

@interface PostTypeCell()

@property (nonatomic, strong) UIView *bgView;

@end

@implementation PostTypeCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self commitInit];
    }
    return self;
}

- (void)commitInit {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.bgView = [[UIView alloc] init];
    self.bgView.backgroundColor = mRGBColor(240, 240, 240);
    [self.contentView addSubview:self.bgView];
    
    self.iconV = [[UIImageView alloc] init];
    [self.bgView addSubview:self.iconV];
    
    self.titleLab = [[UILabel alloc] init];
    self.titleLab.textColor = MAIN_COLLOR;
    self.titleLab.textAlignment = NSTextAlignmentCenter;
    self.titleLab.font = [FontSize NavTitleFontSize18];
    [self.bgView addSubview:self.titleLab];
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    self.bgView.frame = CGRectMake(0, 10, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame) - 20);
    self.bgView.layer.masksToBounds = YES;
    self.bgView.layer.cornerRadius = 6;
    self.iconV.frame = CGRectMake(15, 18, 24, 24); // 35 + 25 = 60
    self.titleLab.frame = CGRectMake(CGRectGetMaxX(self.iconV.frame) + 5, CGRectGetMinY(self.iconV.frame), CGRectGetWidth(self.bgView.frame) - CGRectGetMaxX(self.iconV.frame) - 40 - 10, CGRectGetHeight(self.iconV.frame));
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
