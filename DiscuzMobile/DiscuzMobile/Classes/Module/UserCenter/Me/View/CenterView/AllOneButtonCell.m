//
//  AllOneButtonCell.m
//  DiscuzMobile
//
//  Created by HB on 16/12/1.
//  Copyright © 2016年 comsenz-service.com.  All rights reserved.
//

#import "AllOneButtonCell.h"

@implementation AllOneButtonCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self p_setupView];
    }
    return self;
}

- (void)p_setupView {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor whiteColor];
    self.ActionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.ActionBtn.cs_acceptEventInterval = 1;
    self.ActionBtn.frame = CGRectMake(10, 25 ,CGRectGetWidth(self.frame) - 20, 40);
    [self.ActionBtn setBackgroundColor:MAIN_COLLOR];
    [self.ActionBtn addTarget:self action:@selector(onAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.ActionBtn];
}

- (void)onAction:(UIButton *)sender {
    if (self.actionBlock) {
        self.actionBlock(sender);
    }
}

- (void)layoutSubviews {
    [super  layoutSubviews];
    self.ActionBtn.frame = CGRectMake(10, CGRectGetHeight(self.frame) * 0.15 ,CGRectGetWidth(self.frame) - 20, CGRectGetHeight(self.frame) * 0.7);
    self.ActionBtn.layer.cornerRadius  =4.0;
    self.ActionBtn.layer.borderWidth = 1.0;
    self.ActionBtn.layer.borderColor = MAIN_COLLOR.CGColor;
}

@end
