//
//  TTLaunchImageView.m
//  DiscuzMobile
//
//  Created by HB on 16/5/25.
//  Copyright © 2016年 Cjk. All rights reserved.
//

#import "TTLaunchImageView.h"

@interface TTLaunchImageView()

@property (nonatomic, weak) UIImageView *adImageView;
@property (nonatomic, weak) UIButton *button;
@property (nonatomic, weak) NSTimer *timer;
@property (nonatomic, assign) NSInteger ss;

@property (nonatomic, weak)  UILabel *timelabel;

@end

@implementation TTLaunchImageView


- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        [self commitInit];
    }
    return self;
}

- (instancetype)initWithImage:(UIImage *)image
{
    if (self = [super initWithImage:image]) {
        
        [self commitInit];
    }
    return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"URLString"]) {
        [self addClipbutton];
    }
}

- (void)dealloc {
    [self removeObserver:self forKeyPath:@"URLString"];
}

- (void)commitInit {
    [self addAdImageView];
    [self addSingleTapGesture];
    [self addObserver:self forKeyPath:@"URLString" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)addAdImageView {
    UIImageView *imageView = [[UIImageView alloc]init];
    [self addSubview:imageView];
    _adImageView = imageView;
}

- (void)addClipbutton {
    
    _ss = 5;
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timeFuntion:) userInfo:nil repeats:YES];
    
    UIButton *wobutton = [UIButton buttonWithType:UIButtonTypeSystem];
    [wobutton setTitle:@"跳 过" forState:UIControlStateNormal];
    [wobutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    wobutton.titleLabel.font = [UIFont boldSystemFontOfSize:16.0];
    
    UILabel *timelabel = [[UILabel alloc] init];
    timelabel.text = @"5";
    timelabel.font = [UIFont boldSystemFontOfSize:16.0];
    timelabel.textColor = [UIColor redColor];
    [wobutton addSubview:timelabel];
    _timelabel = timelabel;
    
    [wobutton addTarget:self action:@selector(jumpAction:) forControlEvents:UIControlEventTouchUpInside];
    wobutton.alpha = 0;
    wobutton.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.5];
    _button = wobutton;
    [self addSubview:wobutton];
}

- (void)timeFuntion:(NSTimer *)timer {
    _ss--;
    if (_ss == 0) {
        _timelabel.text = @"";
        [_timer invalidate];
    } else {
        _timelabel.text = [NSString stringWithFormat:@"%ld",_ss];
    }
    
}

- (void)jumpAction:(UITapGestureRecognizer *)sender {
    [self removeFromSuperview];
    [_timer invalidate];
}

- (void)addSingleTapGesture
{
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(singleTapGesture:)];
    [self addGestureRecognizer:singleTap];
}

#pragma maek - setter

- (void)setURLString:(NSString *)URLString
{
    _adImageView.alpha = 0;
    
    [_adImageView sd_setImageWithURL:[NSURL URLWithString:URLString] placeholderImage:[UIImage imageNamed:@""] options:SDWebImageRetryFailed | SDWebImageHighPriority completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        if (image != nil) {
            _adImageView.alpha = 1.0;
            _button.alpha = 1.0;
            [[SDWebImageManager sharedManager] saveImageToCache:image forURL:[NSURL URLWithString:URLString]];
        } else {
            [self removeFromSuperview];
        }
        
    }];

    
}

#pragma mark - action

- (void)singleTapGesture:(UITapGestureRecognizer *)recognizer
{
    
    NSInteger tagnum = recognizer.view.tag;
    DLog(@"%ld",tagnum);
    if (self.clickedImageURLHandle) {
        self.clickedImageURLHandle(self.URLString);
    }
    if (self.superview) {
        [self removeFromSuperview];
    }
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    
    if (self.hidden == NO && _adImageView.alpha > 0 && CGRectContainsPoint(_button.frame,point) ) {
        return _button;
    }
    if (self.hidden == NO && _adImageView.alpha > 0 && CGRectContainsPoint(self.frame, point) && _adImageView.image != nil) {
        return self;
    }
    return nil;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _adImageView.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame) * 0.79);
    _button.frame = CGRectMake(CGRectGetMaxX(_adImageView.frame) - 100, 50, 90, 40);
    _timelabel.frame = CGRectMake(8, 0, 20, 40);
    _button.layer.masksToBounds = YES;
    _button.layer.cornerRadius = 10;
    _button.layer.borderColor = [UIColor colorWithWhite:0.9 alpha:0.5].CGColor;
    _button.layer.borderWidth = 1;
    
    
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
