//
//  JTSegmentedCell.m
//  Test_Segment
//
//  Created by HB on 17/1/12.
//  Copyright © 2017年 comsenz-service.com.  All rights reserved.
//

#import "JTSegmentedCell.h"

@implementation JTSegmentedCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commitInit];
    }
    return self;
}

- (void)commitInit {
    self.layout = onlyText;
    self.iconRelativeScaleFactor = 0.5;
    self.spaceBetweenImageAndLabelRelativeFactor = 0.044;
    
    self.label.text = @"";
    self.label.textColor = [UIColor whiteColor];
    self.label.backgroundColor = [UIColor clearColor];
    [self addSubview:self.label];
    
    self.imageView.backgroundColor = [UIColor clearColor];
    [self addSubview:self.imageView];
    
    [self addObserver:self forKeyPath:@"layout" options:NSKeyValueObservingOptionNew context:nil];
    [self addObserver:self forKeyPath:@"spaceBetweenImageAndLabelRelativeFactor" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)dealloc {
    [self removeObserver:self forKeyPath:@"layout" context:nil];
    [self removeObserver:self forKeyPath:@"spaceBetweenImageAndLabelRelativeFactor" context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"layout"] || [keyPath isEqualToString:@"spaceBetweenImageAndLabelRelativeFactor"]) {
        [self layoutIfNeeded];
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

//#define MMIN(A,B) A < B ? A : B
//emptyData = 0,
//onlyText,
//onlyImage,
//textWithImage,
- (void)layoutSubviews {
    [super layoutSubviews];
    self.label.frame = CGRectZero;
    self.imageView.frame = CGRectZero;
    
    CGFloat w = self.frame.size.width;
    CGFloat h = self.frame.size.height;
    CGFloat min = MIN(w, h);
    switch (self.layout) {
        case onlyImage: {
            CGFloat sideSize = min * self.iconRelativeScaleFactor;
            self.imageView.frame = CGRectMake(0, 0, sideSize, sideSize);
            self.imageView.center = CGPointMake(w / 2, h / 2);
        }
            break;
        case onlyText: {
            self.label.textAlignment = NSTextAlignmentCenter;
            self.label.frame = self.bounds;
        }
            break;
        case textWithImage: {
            [self.label sizeToFit];
            CGFloat sideSize = min * self.spaceBetweenImageAndLabelRelativeFactor;
            self.imageView.frame = CGRectMake(0, 0, sideSize, sideSize);
            CGFloat space = w * self.spaceBetweenImageAndLabelRelativeFactor;
            CGFloat elementsWidth = self.imageView.frame.size.width + space + self.label.frame.size.width;
            CGFloat leftEdge = (w - elementsWidth) / 2;
            CGFloat centeringHeight = h / 2;
            self.imageView.center = CGPointMake(leftEdge + self.imageView.frame.size.width / 2, centeringHeight);
            self.label.center = CGPointMake(leftEdge + self.imageView.frame.size.width + space + self.label.frame.size.width / 2, centeringHeight);
        }
            break;
        default:
            break;
    }
}



#pragma mark - 懒加载
- (UILabel *)label {
    if (!_label) {
        _label = [[UILabel alloc] init];
    }
    return _label;
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
    }
    return _imageView;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
