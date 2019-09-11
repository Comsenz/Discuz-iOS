//
//  ForumLeftCell.m
//  DiscuzMobile
//
//  Created by piter on 2018/1/30.
//  Copyright © 2018年 comsenz-service.com.  All rights reserved.
//

#import "ForumLeftCell.h"

@interface ForumLeftCell()

@property (nonatomic, strong) UIView *line2;

@end

@implementation ForumLeftCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    self.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.selectedBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0.5, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame) - 0.5)];
    self.selectedBackgroundView.backgroundColor = [UIColor whiteColor];
    self.backgroundColor = FORUM_GRAY_COLOR;
    
    self.titleLab = [[UILabel alloc] init];
    self.titleLab.font = [UIFont systemFontOfSize:14.0];
    self.titleLab.textColor = DARK_TEXT_COLOR;
    self.titleLab.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.titleLab];
    
    
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    self.textLabel.font = [UIFont systemFontOfSize:15.0];
    self.textLabel.textColor = DARK_TEXT_COLOR;
    
//    UIView *line1 = [[UIView alloc] init];
//    line1.backgroundColor = [UIColor redColor];
//    [self addSubview:line1];
//    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.left.width.equalTo(self);
//        make.height.equalTo(@1);
//    }];
    
    self.line2 = [[UIView alloc] init];
    self.line2.backgroundColor = NAV_SEP_COLOR;
    [self.contentView addSubview:self.line2];
    [self.line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.width.equalTo(self.contentView);
        make.bottom.equalTo(@-0.1);
        make.height.equalTo(@0.5);
    }];
    
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.selectedBackgroundView.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame) - 0.5);
    self.line2.backgroundColor = NAV_SEP_COLOR;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:NO];
    if (selected == YES) {
        self.titleLab.textColor = MAIN_COLLOR;
    } else {
        self.titleLab.textColor = DARK_TEXT_COLOR;
    }
}


@end
