//
//  TitleSelectView.m
//  DiscuzMobile
//
//  Created by HB on 16/12/23.
//  Copyright © 2016年 comsenz-service.com.  All rights reserved.
//

#import "TitleSelectView.h"

@implementation TitleSelectView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self p_setupViews];
    }
    return self;
}

- (void)p_setupViews {
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 2, 80,20)];
    self.titleLabel.text = @"全部版块";
    _titleLabel.font = [FontSize HomecellTitleFontSize17];
    [_titleLabel setTextColor:[UIColor colorWithRed:95 green:190 blue:125 alpha:1]];
    [self addSubview:self.titleLabel];
    
    UIImage *image = [UIImage imageNamed:@"to"];
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(80, 3, image.size.width, image.size.height)];
    self.imageView.tag = 100000000;
    self.imageView.image = image;
    self.imageView.userInteractionEnabled = YES;
    [self addSubview:self.imageView];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageClick:)];
    [self addGestureRecognizer:tap];
}

- (void)imageClick:(UITapGestureRecognizer *)sender {
    if (self.selectBlock) {
        self.selectBlock(sender);
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
