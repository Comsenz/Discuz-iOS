//
//  PostSelectTypeCell.m
//  DiscuzMobile
//
//  Created by HB on 17/4/25.
//  Copyright © 2017年 comsenz-service.com.  All rights reserved.
//

#import "PostSelectTypeCell.h"

@implementation PostSelectTypeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self p_setupViews];
    }
    return self;
}

- (void)p_setupViews {
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.selectField = [[UITextField alloc] initWithFrame:CGRectMake(15, 5, WIDTH - 20, 45)];
    self.selectField.font = [UIFont systemFontOfSize:16.0];
    self.selectField.placeholder = @" 选择分类";
    self.selectField.font = [FontSize HomecellTitleFontSize15];
    self.selectField.tag = 103;
    [self.contentView addSubview:self.selectField];
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.selectField.frame = CGRectMake(10, 5, WIDTH, 45);
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
