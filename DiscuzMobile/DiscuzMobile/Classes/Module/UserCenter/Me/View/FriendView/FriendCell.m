//
//  FriendCell.m
//  DiscuzMobile
//
//  Created by HB on 17/1/20.
//  Copyright © 2017年 comsenz-service.com.  All rights reserved.
//

#import "FriendCell.h"

@implementation FriendCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self commitInit];
    }
    return self;
}

- (void)commitInit {
    self.headV = [[UIImageView alloc] initWithFrame:CGRectMake(15, 10, 40, 40)];
    self.headV.image = [UIImage imageNamed:@"noavatar_small"];
    [self.contentView addSubview:self.headV];
    
    self.nameLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.headV.frame) + 10, CGRectGetMinY(self.headV.frame), 150, CGRectGetHeight(self.headV.frame))];
    self.nameLab.font = [FontSize HomecellNameFontSize16];
//    self.nameLab.backgroundColor = [UIColor redColor];
    [self.contentView addSubview:self.nameLab];
    
    self.sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.sendBtn.frame = CGRectMake(WIDTH - 55, 18, 45, 24);
    [self.sendBtn setTitleColor:NAVI_BUTTON_COLLOR forState:UIControlStateNormal];
    self.sendBtn.highlighted = YES;
    self.sendBtn.titleLabel.font = [FontSize forumInfoFontSize12];
    [self.contentView addSubview:self.sendBtn];
    
    
    self.sendBtn.backgroundColor = mRGBColor(249, 249, 249);
    self.accessoryView = self.sendBtn;
    [self.sendBtn setTitle:@"发消息" forState:UIControlStateNormal];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.headV.frame = CGRectMake(15, 10, 40, 40);
    self.headV.layer.masksToBounds = YES;
    self.headV.layer.cornerRadius = 20;
    self.nameLab.frame = CGRectMake(CGRectGetMaxX(self.headV.frame) + 10, CGRectGetMinY(self.headV.frame), 150, CGRectGetHeight(self.headV.frame));
    
    
    self.sendBtn.frame = CGRectMake(WIDTH - 60, 18, 50, 24);
    self.sendBtn.layer.borderWidth = 1.0;
    self.sendBtn.layer.borderColor = NAVI_BUTTON_COLLOR.CGColor;
    self.sendBtn.layer.cornerRadius = 2.0;
}

@end
