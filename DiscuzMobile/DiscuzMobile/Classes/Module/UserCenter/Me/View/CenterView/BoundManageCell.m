//
//  BoundManageCell.m
//  DiscuzMobile
//
//  Created by HB on 2017/7/13.
//  Copyright © 2017年 comsenz-service.com.  All rights reserved.
//

#import "BoundManageCell.h"
#import "HorizontalImageTextView.h"
#import "BoundInfoModel.h"

@implementation BoundManageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self p_setupView];
    }
    return self;
}

- (void)p_setupView {
    self.nameV = [[HorizontalImageTextView alloc] init];
    [self.contentView addSubview:self.nameV];
    
    self.detailBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.detailBtn.cs_acceptEventInterval = 1;
    self.detailBtn.titleLabel.textAlignment = NSTextAlignmentRight;
    self.detailBtn.titleLabel.font = [DZFontSize fontSize:14];
    
    [self.detailBtn setTitleColor:K_Color_Theme forState:UIControlStateNormal];
    [self.detailBtn setTitleColor:K_Color_DarkText forState:UIControlStateSelected];
    [self.detailBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 40, 0, -40)];
    [self.contentView addSubview:self.detailBtn];
    [self.detailBtn setTitle:@"绑定" forState:UIControlStateNormal];
    [self.detailBtn setTitle:@"解绑" forState:UIControlStateSelected];
}

- (void)setData:(BoundInfoModel *)model {
    if (model != nil) {
        
        self.nameV.iconV.image = [UIImage imageNamed:model.icon];
        NSString *name = model.name;
        self.detailBtn.selected = YES;
        if ([model.status isEqualToString:@"1"]) {
            name = [name stringByAppendingString:@"(已绑定)"];
        } else {
            self.detailBtn.selected = NO;
            name = [name stringByAppendingString:@"(未绑定)"];
            if ([model.type isEqualToString:@"minapp"]) {
                [self.detailBtn setTitleColor:K_Color_LightText forState:UIControlStateNormal];
            }
        }
        NSMutableAttributedString *attName = [[NSMutableAttributedString alloc] initWithString:name];
        NSRange brange = {name.length - 5, 5};
        [attName addAttribute:NSFontAttributeName value:[DZFontSize forumInfoFontSize12] range:brange];
        [attName addAttribute:NSForegroundColorAttributeName value:K_Color_Message range:brange];
        self.nameV.textLabel.attributedText = attName;
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.nameV.frame = CGRectMake(15, 11, 200, CGRectGetHeight(self.frame) - 20);
    self.detailBtn.frame = CGRectMake(KScreenWidth - 120 - 10, CGRectGetMinY(self.nameV.frame), 120, CGRectGetHeight(self.nameV.frame));
}

@end
