//
//  LiveTipView.m
//  DiscuzMobile
//
//  Created by HB on 2017/7/18.
//  Copyright © 2017年 comsenz-service.com.  All rights reserved.
//

#import "LiveTipCell.h"

@interface LiveTipCell()

@property (nonatomic, strong) UILabel *timeLab;

@end

@implementation LiveTipCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
         [self commitInit];
    }
    return self;
}

- (void)commitInit {
    [self.contentView addSubview:self.timeLab];
    self.contentView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
}

- (void)setText:(NSString *)text {
    
    self.timeLab.text = text;
    if ([DataCheck isValidString:self.timeLab.text]) {
        self.timeLab.hidden = NO;
        CGSize maxSize = CGSizeMake(120, 20);
        CGSize textSize = [self.timeLab.text sizeWithFont:[FontSize HomecellTimeFontSize14] maxSize:maxSize];
        int width = textSize.width + 6;
        int height = textSize.height + 4;
        self.timeLab.frame = CGRectMake((WIDTH - width) / 2, (CGRectGetHeight(self.frame) - height) / 2 - 3, width, height);
        //    self.timeLab.center = self.center;
        self.timeLab.layer.masksToBounds = YES;
        self.timeLab.layer.cornerRadius = 6;
    } else {
        self.timeLab.hidden = YES;
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if ([DataCheck isValidString:self.timeLab.text]) {
        self.timeLab.hidden = NO;
        CGSize maxSize = CGSizeMake(120, 20);
        CGSize textSize = [self.timeLab.text sizeWithFont:[FontSize HomecellTimeFontSize14] maxSize:maxSize];
        int width = textSize.width + 6;
        int height = textSize.height + 4;
        self.timeLab.frame = CGRectMake((WIDTH - width) / 2, (CGRectGetHeight(self.frame) - height) / 2 - 3, width, height);
        //    self.timeLab.center = self.center;
        self.timeLab.layer.masksToBounds = YES;
        self.timeLab.layer.cornerRadius = 6;
    } else {
        self.timeLab.hidden = YES;
    }
}

- (UILabel *)timeLab {
    if (_timeLab == nil) {
        _timeLab = [[UILabel alloc] init];
        _timeLab.textAlignment = NSTextAlignmentCenter;
        _timeLab.textColor = [UIColor whiteColor];
        _timeLab.font = [FontSize HomecellTimeFontSize14];
        _timeLab.backgroundColor = mRGBColor(211, 211, 211);
    }
    return _timeLab;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
