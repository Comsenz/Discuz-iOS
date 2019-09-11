//
//  JTImagePickerCell.m
//  WSImagePicker
//
//  Created by ZhangJitao on 2018/3/21.
//  Copyright © 2018年 wsjtwzs. All rights reserved.
//

#import "JTImagePickerCell.h"

@implementation JTImagePickerCell

- (instancetype)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]) {
        [self setupView];
    }
    return self;
}

- (void)setupView {
    self.imageView.frame = self.bounds;
    [self.contentView addSubview:self.imageView];
    
    self.deleteBtn.frame = CGRectMake(-2, -2, 22, 22);
    [self.contentView addSubview:self.deleteBtn];
}

- (UIImageView *)imageView {
    if (_imageView == nil) {
        _imageView = [[UIImageView alloc] init];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.clipsToBounds = YES;
    }
    return _imageView;
}

- (UIButton *)deleteBtn {
    if (_deleteBtn == nil) {
        _deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_deleteBtn setImage:[UIImage imageNamed:@"delete_scroll"] forState:UIControlStateNormal];
    }
    return _deleteBtn;
}

@end
