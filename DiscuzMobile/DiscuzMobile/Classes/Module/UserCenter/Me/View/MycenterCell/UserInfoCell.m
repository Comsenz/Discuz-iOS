//
//  UserInfoCell.m
//  DiscuzMobile
//
//  Created by HB on 16/12/1.
//  Copyright © 2016年 comsenz-service.com.  All rights reserved.
//

#import "UserInfoCell.h"

@implementation UserInfoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self p_setupViews];
    }
    return self;
}

- (void)p_setupViews {
    self.backgroundColor = [UIColor whiteColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.headImageV = [[UIImageView alloc] initWithFrame:CGRectMake(11,11, 42, 42)];
    [self.contentView addSubview:self.headImageV];
    
    self.nameLabel = [[UILabel alloc] init];
    self.nameLabel.font = [UIFont systemFontOfSize:16.0];
    [self.contentView addSubview:self.nameLabel];
    
    self.groupLabel = [[UILabel alloc] init];
    self.groupLabel.font = [UIFont systemFontOfSize:10.0];
    self.groupLabel.textColor = [UIColor whiteColor];
    self.groupLabel.backgroundColor = mRGBColor(253, 197, 78);
    self.groupLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.groupLabel];
    
    self.editHeadBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.editHeadBtn.titleLabel.font = [UIFont systemFontOfSize:12.0];
    [self.editHeadBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.editHeadBtn.titleLabel.textColor = mRGBColor(131, 131, 131);
    self.editHeadBtn.backgroundColor = mRGBColor(249, 249, 249);
    [self.editHeadBtn setTitle:@"编辑头像" forState:UIControlStateNormal];
    [self.editHeadBtn addTarget:self action:@selector(editBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.editHeadBtn];
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.headImageV.frame = CGRectMake(11,11, 42, 42);
    self.headImageV.layer.masksToBounds = YES;
    self.headImageV.layer.cornerRadius = self.headImageV.frame.size.width / 2;
    
    self.nameLabel.frame = CGRectMake(68,13, 110, 20);
    
    self.groupLabel.frame = CGRectMake(68,13 + 20 + 3, 20, 15);
    CGRect fla = self.groupLabel.frame;
    if ([DataCheck isValidString:self.groupLabel.text]) {
        int i = [self.groupLabel.text convertToInt:self.groupLabel.text];
        self.groupLabel.frame = CGRectMake(fla.origin.x, fla.origin.y, 15*i, fla.size.height);
    }
    
    self.groupLabel.layer.cornerRadius = 3.0;
    self.groupLabel.layer.masksToBounds =YES;
    
    self.editHeadBtn.frame = CGRectMake(WIDTH-65, 20,55, 24);
    self.editHeadBtn.layer.borderWidth = 1.0;
    self.editHeadBtn.layer.borderColor = mRGBColor(211, 211, 211).CGColor;
    self.editHeadBtn.layer.cornerRadius = 2.0;
}

- (void)editBtnClick {
    
}

@end
