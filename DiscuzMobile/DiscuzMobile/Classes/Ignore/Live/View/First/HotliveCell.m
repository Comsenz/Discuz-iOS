//
//  HotliveCell.m
//  DiscuzMobile
//
//  Created by HB on 2017/5/5.
//  Copyright © 2017年 comsenz-service.com.  All rights reserved.
//

#import "HotliveCell.h"
#import "LiveImageView.h"
#import "HotLivelistModel.h"
#import "JudgeImageModel.h"

@interface HotliveCell()

@property (nonatomic, strong) UILabel *tipLab;

@end

@implementation HotliveCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self commitInit];
    }
    return self;
}

- (void)commitInit {
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    self.iconV = [[LiveImageView alloc] init];
    [self.contentView addSubview:self.iconV];
    
    self.titleLab = [[UILabel alloc] init];
    self.titleLab.textColor = MAIN_TITLE_COLOR;
    self.titleLab.font = [FontSize HomecellTitleFontSize15];
    self.titleLab.numberOfLines = 0;
    [self.contentView addSubview:self.titleLab];
    
    self.nameLab = [[UILabel alloc] init];
    self.nameLab.font = [FontSize HomecellNameFontSize16];
    self.nameLab.textColor = LIGHT_TEXT_COLOR;
    [self.contentView addSubview:self.nameLab];
    
    self.gradLab = [[UILabel alloc] init];
    self.gradLab.font = [FontSize gradeFontSize9];
    self.gradLab.textAlignment = NSTextAlignmentCenter;
    self.gradLab.textColor = NAVI_BAR_COLOR;
    self.gradLab.backgroundColor = MAIN_COLLOR;
    [self.contentView addSubview:self.gradLab];
    
    self.tipLab = [[UILabel alloc] init];
    self.tipLab.text = @"#今日热点";
    self.tipLab.textAlignment = NSTextAlignmentRight;
    self.tipLab.textColor = LIGHT_TEXT_COLOR;
    self.tipLab.font = [FontSize HomecellTimeFontSize14];
    [self.contentView addSubview:self.tipLab];
    
    [self viewMakeConstraints];
}

- (void)setInfo:(HotLivelistModel *)info  {
    if ([JudgeImageModel graphFreeModel] == NO) {
        [self.iconV sd_setImageWithURL:[NSURL URLWithString:[info.liveIcon makeDomain]] placeholderImage:[UIImage imageNamed:@"live_p3"] options:SDWebImageRetryFailed];
    } else {
        self.iconV.image = [UIImage imageNamed:@"live_p3"];
    }
    
    self.iconV.nuberLabel.text = info.replies;
    self.titleLab.text = info.subject;
    self.nameLab.text = info.author;
    
    NSString *gradestr = @"";
    if ([DataCheck isValidString:info.grouptitle]) {
        gradestr = [NSString stringWithFormat:@" %@ ",info.grouptitle];
        if ([info.grouptitle integerValue] > 0) {
            gradestr = [NSString stringWithFormat:@" Lv%@ ",info.grouptitle];
        }
    }
    
    self.gradLab.text = gradestr;
    if ([DataCheck isValidDictionary:info.forumnames]) {
        self.tipLab.text = [NSString stringWithFormat:@"#%@",[info.forumnames objectForKey:@"name"]];
    }
    [self layoutIfNeeded];
}

- (void)viewMakeConstraints {
    [self.iconV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(@10);
        make.width.height.equalTo(@80);
    }];
    
    self.titleLab.numberOfLines = 2;
    self.titleLab.preferredMaxLayoutWidth = WIDTH - 80 - 10 - 20;
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconV.mas_right).offset(10);
        make.top.equalTo(self.iconV);
    }];
    
    self.nameLab.preferredMaxLayoutWidth = 120;
    [self.nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLab);
        make.bottom.equalTo(@-10);
    }];
    
    self.gradLab.preferredMaxLayoutWidth = 100;
    [self.gradLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLab.mas_right).offset(5);
        make.centerY.equalTo(self.nameLab);
    }];
    
    [self.tipLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.equalTo(self.contentView).offset(-10);
        make.width.equalTo(@80);
        make.height.equalTo(@20);
    }];
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.gradLab.layer.masksToBounds = YES;
    self.gradLab.layer.cornerRadius = 2;
}

@end
