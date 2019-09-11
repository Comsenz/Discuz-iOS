//
//  JTSegmentView.m
//  DiscuzMobile
//
//  Created by HB on 17/3/31.
//  Copyright © 2017年 comsenz-service.com.  All rights reserved.
//

#import "JTSegmentView.h"
#import "JTSegmentedControl.h"
#import "JTSegmentedCell.h"

@interface JTSegmentView()

@property (nonatomic, strong) UIView *sepLine;

@end

@implementation JTSegmentView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self commitInit];
    }
    return self;
}

- (void)commitInit {
    
    self.segment = [[JTSegmentedControl alloc] initWithFrame:CGRectMake(15, 10, CGRectGetWidth(self.frame) - 30, 35)];
    self.segment.userInteractionEnabled = YES;
    [self addSubview:self.segment];
    
    self.segment.layer.borderColor = MAIN_COLLOR.CGColor;
    self.segment.layer.borderWidth = 0.8;
    self.segment.backgroundColor = [UIColor whiteColor];
    self.segment.indicatorView.backgroundColor = MAIN_COLLOR;
    
    self.sepLine = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.frame) - 0.7, WIDTH, 0.7)];
    self.sepLine.backgroundColor = NAV_SEP_COLOR;
    [self addSubview:self.sepLine];
    
}

- (void)setSegmentCell:(NSArray <NSString *> *)titleArr {
    
    for (NSString *title in titleArr) {
        
        JTSegmentedCell *cell = [self createCell:title andImage:nil];
        cell.layout = onlyText;
        [self.segment add:cell];
    }
}

- (JTSegmentedCell *)createCell:(NSString *)text andImage:(UIImage *)image{
    
    JTSegmentedCell *cell = [[JTSegmentedCell alloc] init];
    cell.label.text = text;
    cell.label.font = [FontSize HomecellTitleFontSize17];
    cell.label.textColor = MAIN_TITLE_COLOR;
    cell.imageView.image = image;
    return cell;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.segment.frame = CGRectMake(15, 10, CGRectGetWidth(self.frame) - 30, 35);
    self.sepLine.frame = CGRectMake(0, CGRectGetHeight(self.frame) - 0.7, WIDTH, 0.7);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
