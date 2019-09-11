//
//  ForumCell.m
//  DiscuzMobile
//
//  Created by HB on 17/1/13.
//  Copyright © 2017年 comsenz-service.com.  All rights reserved.
//

#import "ForumCell.h"
#import "TreeViewNode.h"
#import "ForumInfoModel.h"
#import "NSString+MoreMethod.h"

@interface ForumCell()

@property (nonatomic, strong) UIImageView *AccessoryV;

@end

@implementation ForumCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self p_setupView];
    }
    return self;
}

- (void)p_setupView {
    self.iconV = [[UIImageView alloc] init];
    [self.contentView addSubview:self.iconV];
    
    self.titleLab = [[UILabel alloc] init];
    self.titleLab.font = [FontSize HomecellTitleFontSize17];
    [self.contentView addSubview:self.titleLab];
    
    self.numLab = [[UILabel alloc] init];
    self.numLab.font = [FontSize HomecellTimeFontSize16];
    self.numLab.textColor = LIGHT_TEXT_COLOR;
    [self.contentView addSubview:self.numLab];
    
    self.postsLab = [[UILabel alloc] init];
    self.postsLab.font = [FontSize HomecellTimeFontSize16];
    self.postsLab.textColor = LIGHT_TEXT_COLOR;
    [self.contentView addSubview:self.postsLab];
    
    self.desLab = [[UILabel alloc] init];
    self.desLab.font = [FontSize HomecellTimeFontSize16];
    self.desLab.textColor = LIGHT_TEXT_COLOR;
    [self.contentView addSubview:self.desLab];
    
    self.AccessoryV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"to"]];
    [self.contentView addSubview:self.AccessoryV];
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.iconV.frame = CGRectMake(15, 10, CGRectGetHeight(self.frame) - 20, CGRectGetHeight(self.frame) - 20);
    self.iconV.layer.masksToBounds = YES;
    self.iconV.layer.cornerRadius = 8;
    self.titleLab.frame = CGRectMake(CGRectGetMaxX(self.iconV.frame) + 10, CGRectGetMinY(self.iconV.frame), WIDTH - CGRectGetWidth(self.iconV.frame) - 35 - 12 - 5, (CGRectGetHeight(self.iconV.frame)- 10)/3);
    
    self.AccessoryV.frame = CGRectMake(CGRectGetMaxX(self.titleLab.frame) + 5, CGRectGetMinY(self.titleLab.frame), 9, 16);
    
    self.numLab.frame = CGRectMake(CGRectGetMinX(self.titleLab.frame), CGRectGetMaxY(self.titleLab.frame) + 5, CGRectGetWidth(self.titleLab.frame) / 2.5 , CGRectGetHeight(self.titleLab.frame));
    self.postsLab.frame = CGRectMake(CGRectGetMaxX(self.numLab.frame) + 5, CGRectGetMinY(self.numLab.frame), CGRectGetWidth(self.numLab.frame), CGRectGetHeight(self.titleLab.frame));
    self.desLab.frame = CGRectMake(CGRectGetMinX(self.numLab.frame), CGRectGetMaxY(self.numLab.frame) + 5, CGRectGetWidth(self.titleLab.frame), CGRectGetHeight(self.titleLab.frame));
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
    
    self.desLab.text = [NSString stringWithFormat:@"最后发表：%@",infoModel.lastpost];
    [self.iconV sd_setImageWithURL:[NSURL URLWithString:infoModel.icon] placeholderImage:[UIImage imageNamed:@"forumCommon"] options:SDWebImageLowPriority | SDWebImageRetryFailed];
}

@end
