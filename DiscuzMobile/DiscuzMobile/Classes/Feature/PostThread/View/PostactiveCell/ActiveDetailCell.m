//
//  ActiveDetailCell.m
//  DiscuzMobile
//
//  Created by HB on 16/11/30.
//  Copyright © 2016年 comsenz-service.com.  All rights reserved.
//

#import "ActiveDetailCell.h"

@implementation ActiveDetailCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupViews];
    }
    return self;
}

-(void)setupViews {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.detailTextView = [[DZPlaceholderTextView alloc] initWithFrame:CGRectMake(5, 10, KScreenWidth-10, CGRectGetHeight(self.frame) -20)];
    self.detailTextView.font = [DZFontSize HomecellTitleFontSize15];
    
    [self.contentView addSubview:self.detailTextView];
    self.detailTextView.placeholder = @" 活动详情";
    self.detailTextView.font  = [DZFontSize HomecellTitleFontSize15];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.detailTextView.frame = CGRectMake(5, 10, KScreenWidth-10, CGRectGetHeight(self.frame) - 20);
}


@end
