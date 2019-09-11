//
//  FastLevelCell.m
//  DiscuzMobile
//
//  Created by ZhangJitao on 2018/7/18.
//  Copyright © 2018年 comsenz-service.com.  All rights reserved.
//

#import "FastLevelCell.h"
#import "TreeViewNode.h"
#import "ForumInfoModel.h"
#import "NSString+MoreMethod.h"
#import "UIButton+EnlargeEdge.h"

@interface FastLevelCell()
@end

@implementation FastLevelCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self p_setupView];
        //        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return self;
}

- (void)p_setupView {
    self.separatorInset = UIEdgeInsetsMake(0, 63, 0, 0);
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    self.iconV = [[UIImageView alloc] init];
    [self.contentView addSubview:self.iconV];
    
    self.titleLab = [[UILabel alloc] init];
    self.titleLab.font = [UIFont systemFontOfSize:16.5];
    self.titleLab.textColor = MAIN_TITLE_COLOR;
    [self.contentView addSubview:self.titleLab];
    
    
    [self.iconV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(@10);
        make.bottom.equalTo(@-10);
        make.width.equalTo(self.iconV.mas_height);
    }];
    
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconV.mas_right).offset(10);
        make.centerY.equalTo(self.iconV);
//        make.top.equalTo(self.iconV).offset(-1);
        make.right.equalTo(self).offset(-60);
        make.height.equalTo(self.iconV).multipliedBy(0.6);
    }];
    
    [self addSubview:self.statusBtn];
    
    [self.statusBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.iconV);
        make.right.equalTo(self).offset(-15);
        make.width.height.equalTo(@20);
    }];
    [self.statusBtn setEnlargeEdgeWithTop:20 right:15 bottom:20 left:15];
    [self layoutIfNeeded];
    
}


- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.iconV.layer.masksToBounds = YES;
    self.iconV.layer.cornerRadius = 5;
}

/**
 * 设置数据
 */
- (void)setInfo:(TreeViewNode *)node {
    ForumInfoModel *infoModel = node.infoModel;
    
    if ([DataCheck isValidString:infoModel.title]) {
        self.titleLab.text = infoModel.title;
    } else {
        self.titleLab.text = infoModel.name;
    }
    
    [self.iconV sd_setImageWithURL:[NSURL URLWithString:infoModel.icon] placeholderImage:[UIImage imageNamed:@"forumCommon"] options:SDWebImageLowPriority | SDWebImageRetryFailed];
    
    CGFloat mleft = 10;
    for (int i = 1; i < node.nodeLevel; i++) {
        mleft += 20;
    }
    [self.iconV mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.left.equalTo(@(mleft));
    }];
    
    self.statusBtn.hidden = NO;
    if (node.isExpanded) {
        [self.statusBtn setBackgroundImage:[UIImage imageNamed:@"All_downState"] forState:UIControlStateNormal];
    }else{
        
        if ([DataCheck isValidArray:node.nodeChildren]) {
            [self.statusBtn setBackgroundImage:[UIImage imageNamed:@"All_rightState"] forState:UIControlStateNormal];
            
        }else{
            
            self.statusBtn.hidden = YES;
        }
    }
}

- (UIButton *)statusBtn {
    if (!_statusBtn) {
        _statusBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    }
    return _statusBtn;
}

@end
