//
//  TopMlCell.m
//  DiscuzMobile
//
//  Created by HB on 2017/5/25.
//  Copyright © 2017年 comsenz-service.com.  All rights reserved.
//

#import "TopMlCell.h"
#import "ThreadListModel.h"

@implementation TopMlCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self commitInit];
    }
    return  self;
}

- (void)commitInit {
    self.titleLabel = [[TopLabel alloc] init];
    self.titleLabel.font = [FontSize HomecellTitleFontSize15];
    self.titleLabel.textColor = MAIN_TITLE_COLOR;
    
    [self.contentView addSubview:self.titleLabel];
    
    self.titleLabel.preferredMaxLayoutWidth = WIDTH-20;
//    self.titleLabel.numberOfLines = 2;
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(@10);
        make.width.mas_equalTo(WIDTH - 20);
    }];
}

- (void)setDataWithModel:(ThreadListModel *)model {
    
    if (model.subject != nil) {

        [self.titleLabel setText:model.subject andImageName:@"置顶" andSize:CGSizeMake(34 ,17) andPosition:P_before];
//        self.titleLabel.text = [NSString stringWithFormat:@"#[09_09]%@",model.subject];
    } else {
        self.titleLabel.text = @"";
    }
    [self layoutIfNeeded];

}

- (CGFloat)cellHeight {
    
    return CGRectGetMaxY(self.titleLabel.frame) + 5;
}

@end
