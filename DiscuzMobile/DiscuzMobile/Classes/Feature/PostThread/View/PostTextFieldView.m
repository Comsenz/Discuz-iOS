//
//  PostTextFieldView.m
//  DiscuzMobile
//
//  Created by HB on 17/4/24.
//  Copyright © 2017年 comsenz-service.com.  All rights reserved.
//

#import "PostTextFieldView.h"

@interface PostTextFieldView()

@property (nonatomic, strong) UIView *line;

@end
@implementation PostTextFieldView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commitInit];
    }
    return self;
}

- (void)commitInit {
    self.backgroundColor = [UIColor whiteColor];
    self.textField = [[UITextField alloc] initWithFrame:CGRectMake(10, 5, WIDTH - 10, CGRectGetHeight(self.frame) - 10)];
    [self addSubview:self.textField];
    
    self.line = [[UIView alloc] initWithFrame:CGRectMake(10, CGRectGetHeight(self.frame) - 0.5, WIDTH - 10, 0.5)];
    [self addSubview:self.line];
    self.line.backgroundColor = LINE_COLOR;
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.textField.frame = CGRectMake(10, 5, WIDTH - 10, CGRectGetHeight(self.frame) - 10);
    self.line.frame = CGRectMake(10, CGRectGetHeight(self.frame) - 0.5, WIDTH - 10, 0.5);
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
