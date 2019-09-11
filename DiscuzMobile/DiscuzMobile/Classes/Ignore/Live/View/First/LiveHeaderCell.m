//
//  LiveHeaderCell.m
//  DiscuzMobile
//
//  Created by HB on 2017/6/15.
//  Copyright © 2017年 comsenz-service.com.  All rights reserved.
//

#import "LiveHeaderCell.h"

@interface LiveHeaderCell()

@property (nonatomic, strong) UIView *sepView;

@end

@implementation LiveHeaderCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self commitInit];
    }
    return self;
}

- (UIView *)sepView {
    if (_sepView == nil) {
        _sepView = [[UIView alloc] init];
        _sepView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    }
    return _sepView;
}

- (void)commitInit {
    self.titleLab = [[UILabel alloc] init];
    self.titleLab.backgroundColor = [UIColor whiteColor];
    self.titleLab.textAlignment = NSTextAlignmentCenter;
    self.titleLab.textColor = MAIN_COLLOR;
    self.titleLab.font = [FontSize NavTitleFontSize18];
    
    [self.contentView addSubview:self.titleLab];
    
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(@0);
        make.width.mas_equalTo(WIDTH);
        make.height.mas_equalTo(40);
    }];
    
    [self.contentView addSubview:self.sepView];
    
    [self.sepView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0);
        make.bottom.equalTo(@-1);
        make.width.mas_equalTo(WIDTH);
        make.height.equalTo(@1.5);
    }];
}

@end
