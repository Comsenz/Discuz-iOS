//
//  ForumItemCell.m
//  DiscuzMobile
//
//  Created by HB on 17/5/2.
//  Copyright © 2017年 comsenz-service.com.  All rights reserved.
//

#import "ForumItemCell.h"
#import "ForumInfoModel.h"
#import "JudgeImageModel.h"

@implementation ForumItemCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commitInit];
    }
    return self;
}

- (void)commitInit {
    
    self.iconV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"forumCommon"]];
    [self.contentView addSubview:self.iconV];
    
    self.titleLab = [[UILabel alloc] init];
    self.titleLab.font = [FontSize HomecellTitleFontSize15];
//    self.titleLab.numberOfLines = 0;
//    self.titleLab.textAlignment = NSTextAlignmentLeft;
    self.titleLab.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.titleLab];
    [self.contentView addSubview:_titleLab];
    
    self.numLab = [[UILabel alloc] init];
    self.numLab.font = [FontSize ForumInfoFontSize];
    self.numLab.textAlignment = NSTextAlignmentCenter;
    self.numLab.textColor = LIGHT_TEXT_COLOR;
    [self.contentView addSubview:self.numLab];
    
//    self.postsLab = [[UILabel alloc] init];
//    self.postsLab.font = [FontSize HomecellmessageNumLFontSize10];
//    self.postsLab.textColor = LIGHT_TEXT_COLOR;
//    [self.contentView addSubview:self.postsLab];

    [self.iconV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(@8);
        make.width.height.equalTo(self.contentView.mas_width).offset(-16);
    }];
    
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@5);
        make.top.equalTo(self.iconV.mas_bottom).offset(5);
        make.width.equalTo(self).offset(-10);
        make.height.equalTo(@30);
    }];
    
    [self.numLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@5);
        make.bottom.equalTo(self).offset(-8);
        make.width.equalTo(self).offset(-10);
        make.height.equalTo(@15);
    }];
    
}


/**
 * 设置数据
 */
- (void)setInfo:(ForumInfoModel *)infoModel {
    
    if ([DataCheck isValidString:infoModel.title]) {
        self.titleLab.text = infoModel.title;
    } else if ([DataCheck isValidString:infoModel.name]) {
        
        self.titleLab.text = infoModel.name;
        
    } else {
        self.titleLab.text = @"--";
    }
    
    if ([DataCheck isValidString:infoModel.threads]) {
        
        NSString *threads = [NSString stringWithFormat:@"主题:%@",infoModel.threads];
        
        if ([DataCheck isValidString:infoModel.todayposts] && [infoModel.todayposts integerValue] > 0) {
            
            NSString *todays = [NSString stringWithFormat:@"(%@)",infoModel.todayposts];
            NSMutableAttributedString *describe = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@",threads,todays]];
            NSRange todayRange = NSMakeRange(describe.length - todays.length, todays.length);
            [describe addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:todayRange];
            self.numLab.attributedText = describe;
        } else {
            self.numLab.text = threads;
        }
        
    } else {
        self.numLab.text = @"主题:--";
    }
    
    if ([DataCheck isValidString:infoModel.icon] && [JudgeImageModel graphFreeModel] == NO) {
        
        [self.iconV sd_setImageWithURL:[NSURL URLWithString:infoModel.icon] placeholderImage:[UIImage imageNamed:@"forumCommon"] options:SDWebImageRetryFailed];
        
    } else {
        if ([infoModel.todayposts integerValue] > 0) {
            self.iconV.image = [UIImage imageNamed:@"forumNew"];
        } else {
            self.iconV.image = [UIImage imageNamed:@"forumCommon"];
        }
    }
    [self layoutIfNeeded];
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.contentView.layer.borderWidth = 1;
    self.contentView.layer.borderColor = LINE_COLOR.CGColor;
    self.contentView.layer.masksToBounds = YES;
    self.contentView.layer.cornerRadius = 5;
    
    self.iconV.layer.masksToBounds = YES;
    self.iconV.layer.cornerRadius = 6;
}

@end
