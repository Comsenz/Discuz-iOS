//
//  SubForumCell.m
//  DiscuzMobile
//
//  Created by HB on 2017/5/22.
//  Copyright © 2017年 comsenz-service.com.  All rights reserved.
//

#import "SubForumCell.h"
#import "TreeViewNode.h"
#import "ForumInfoModel.h"
#import "NSString+MoreMethod.h"

@interface SubForumCell()

@property (nonatomic, strong) UIImageView *AccessoryV;

@end

@implementation SubForumCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self p_setupView];
    }
    return self;
}

- (void)p_setupView {
    self.iconV = [[UIImageView alloc] init];
    self.iconV.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:self.iconV];
    
    self.titleLab = [[UILabel alloc] init];
    self.titleLab.font = [FontSize HomecellTitleFontSize15];
    [self.contentView addSubview:self.titleLab];
    
    self.numLab = [[UILabel alloc] init];
    self.numLab.font = [FontSize forumtimeFontSize14];
    self.numLab.textColor = LIGHT_TEXT_COLOR;
    [self.contentView addSubview:self.numLab];
    
    self.postsLab = [[UILabel alloc] init];
    self.postsLab.font = [FontSize forumtimeFontSize14];
    self.postsLab.textColor = LIGHT_TEXT_COLOR;
    [self.contentView addSubview:self.postsLab];
    
    self.AccessoryV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"to"]];
    [self.contentView addSubview:self.AccessoryV];
    
    [self.iconV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@15);
        make.top.equalTo(@10);
        make.height.width.equalTo(self.mas_height).offset(-20);
    }];
    
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconV.mas_right).offset(10);
        make.top.equalTo(self.iconV);
        make.right.equalTo(self.AccessoryV.mas_left).offset(-5);
        make.height.mas_equalTo(self.iconV.mas_height).multipliedBy(0.5);
    }];

    [self.AccessoryV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-15);
        make.top.equalTo(self.titleLab);
        make.width.equalTo(@9);
        make.height.equalTo(@16);
    }];
    
    [self.numLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.height.equalTo(self.titleLab);
        make.top.equalTo(self.titleLab.mas_bottom);
        make.width.equalTo(self.titleLab).multipliedBy(0.4);
    }];

    [self.postsLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.numLab.mas_right).offset(5);
        make.top.equalTo(self.numLab);
        make.width.height.equalTo(self.numLab);
    }];
    
}

/**
 * 设置数据
 */
- (void)setInfo:(ForumInfoModel *)infoModel {
    //    self.textLabel.text = node.infoModel.name;
    if ([DataCheck isValidString:infoModel.title]) {
        self.titleLab.text = infoModel.title;
    } else {
        self.titleLab.text = infoModel.name;
    }
    
    if ([DataCheck isValidString:infoModel.threads]) {
        self.numLab.text = [NSString stringWithFormat:@"主题：%@",infoModel.threads];
    } else {
        self.numLab.text = @"主题：-";
    }
    if ([DataCheck isValidString:infoModel.posts]) {
        self.postsLab.text = [NSString stringWithFormat:@"帖数：%@",infoModel.posts];
    } else {
        self.postsLab.text = @"帖数：-";
    }
    
    if ([infoModel.todayposts integerValue] > 0) {
        self.iconV.image = [UIImage imageNamed:@"forumNew_l"];
    } else {
        self.iconV.image = [UIImage imageNamed:@"forumCommon_l"];
    }
    
    if ([DataCheck isValidString:infoModel.icon]) {
        
        [self.iconV sd_setImageWithURL:[NSURL URLWithString:infoModel.icon] placeholderImage:[UIImage imageNamed:@"forumCommon_l"] options:SDWebImageLowPriority | SDWebImageRetryFailed];
    }
    
    [self layoutIfNeeded];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.iconV.layer.masksToBounds = YES;
    self.iconV.layer.cornerRadius = 8;
   
}



@end

