//
//  NormalDetailCell.m
//  DiscuzMobile
//
//  Created by ZhangJitao on 2018/6/29.
//  Copyright © 2018年 comsenz-service.com.  All rights reserved.
//

#import "NormalDetailCell.h"
#import "WBStatusComposeTextParser.h"

@implementation NormalDetailCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupViews];
    }
    return self;
}

-(void)setupViews {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.textView = [YYTextView new];
    _textView.frame = CGRectMake(5, 10, WIDTH-10, CGRectGetHeight(self.frame) -20);
    _textView.showsVerticalScrollIndicator = YES;
    _textView.alwaysBounceVertical = YES;
    _textView.allowsCopyAttributedString = NO;
    _textView.font = [UIFont systemFontOfSize:17];
    _textView.textParser = [WBStatusComposeTextParser new];
    _textView.inputAccessoryView = [UIView new];
    
//    _textView.returnKeyType = UIReturnKeySend; //just as an example
    _textView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    _textView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    _textView.placeholderText = @"请输入内容";
    
    [self.contentView addSubview:self.textView];

}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.textView.frame = CGRectMake(5, 10, WIDTH-10, CGRectGetHeight(self.frame) - 20);
}

@end
