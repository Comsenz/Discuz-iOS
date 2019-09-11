//
//  UploadImageContainView.m
//  DiscuzMobile
//
//  Created by HB on 16/11/22.
//  Copyright © 2016年 comsenz-service.com.  All rights reserved.
//

#import "UploadImageContainView.h"

#define ROWCOUNT 5
#define DefaultMax 10

@interface UploadImageContainView() {
    CGFloat viewWidth;
}

@property (nonatomic, strong, readwrite) NSMutableArray * aidArray;

@end

@implementation UploadImageContainView

static CGFloat b_space = 15.0;

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.maxImage = DefaultMax;
        self.aidArray = [NSMutableArray array];
        self.images = [NSMutableArray array];
        self.iamgevViews = [NSMutableArray array];
        viewWidth = (WIDTH - b_space * 2) / ROWCOUNT - b_space;
        [self p_setupViews];
    }
    return self;
}

- (void)p_setupViews {
    
    self.imagephoto = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.imagephoto.backgroundColor = [UIColor orangeColor];
    [self.imagephoto setBackgroundImage:[UIImage imageNamed:@"+"] forState:UIControlStateNormal];
    [self.imagephoto addTarget:self action:@selector(addImage) forControlEvents:UIControlEventTouchUpInside];
    self.imagephoto.frame = CGRectMake(b_space, 10, viewWidth, viewWidth);
    [self addSubview:self.imagephoto];
}

// 设置图片
- (void)setImageView:(UIImageView *)smallimage andStr:(NSString *)str{
    [self.iamgevViews addObject:smallimage];
    [self.aidArray addObject:str];
    if (self.sendAidBlock) {
        self.images = [NSMutableArray array];
        for (UIImageView *iv in self.iamgevViews) {
            NSData *data = UIImageJPEGRepresentation(iv.image, 1.0);
            UIImage *image = [UIImage imageWithData:data];
            [self.images addObject:image];
        }
        self.sendAidBlock(self.aidArray);
    }
    
    NSInteger count = self.aidArray.count;
    CGRect oldframe = self.imagephoto.frame;
    smallimage.frame = self.imagephoto.frame;
    
    if (count % ROWCOUNT == 0) {
        oldframe = CGRectMake(b_space - viewWidth - b_space, self.imagephoto.frame.origin.y + viewWidth + 10, viewWidth, viewWidth);
    }
    if (count >= self.maxImage) {
        self.imagephoto.hidden = YES;
    }
    self.imagephoto.frame = CGRectMake(b_space + oldframe.origin.x + viewWidth, oldframe.origin.y, viewWidth, viewWidth);
    smallimage.userInteractionEnabled = YES;
    UIButton *delebtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [delebtn setImage:[UIImage imageNamed:@"delete_scroll"] forState:UIControlStateNormal];
    delebtn.frame = CGRectMake(-5, -5, 22, 22);
    delebtn.tag = 1000 + [str integerValue];
    [delebtn addTarget:self action:@selector(deleteClick:) forControlEvents:(UIControlEventTouchUpInside)];
    [smallimage addSubview:delebtn];
    
    [self addSubview:smallimage];
}

- (void)resetUploadView {
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
    [self p_setupViews];
}

// 点击删除图片
- (void)deleteClick:(UIButton *)sender {
    sender.enabled = NO;
    NSInteger b = [self.aidArray indexOfObject:[NSString stringWithFormat:@"%ld",sender.tag - 1000]];
    [_aidArray removeObject:[NSString stringWithFormat:@"%ld",sender.tag-1000]];
    
    [self.iamgevViews removeObjectAtIndex:b];
    if (self.sendAidBlock) {
        self.images = [NSMutableArray array];
        for (UIImageView *iv in self.iamgevViews) {
            NSData *data = UIImageJPEGRepresentation(iv.image, 1.0);
            UIImage *image = [UIImage imageWithData:data];
            [self.images addObject:image];
        }
        self.sendAidBlock(_aidArray);
    }
    
    [sender.superview removeFromSuperview];
    if ([DataCheck isValidArray:self.aidArray]) {
        for (NSInteger i = b; i < self.aidArray.count; i++) {
            UIImageView *custom = [_iamgevViews objectAtIndex:i];
            CGRect oldFrame = custom.frame;
            custom.frame = CGRectMake(oldFrame.origin.x - viewWidth - b_space, oldFrame.origin.y, viewWidth, viewWidth);
            if ((i + 1) % ROWCOUNT == 0) {
                CGFloat x = (viewWidth + b_space) * (ROWCOUNT - 1) + b_space;
                custom.frame = CGRectMake(x, oldFrame.origin.y - viewWidth - 10, viewWidth, viewWidth);
            }
        }
    }
    CGFloat w = self.imagephoto.frame.size.width;
    CGFloat h = self.imagephoto.frame.size.height;
    CGFloat x;
    x = self.imagephoto.frame.origin.x;
    CGFloat y = self.imagephoto.frame.origin.y;
    if ((self.aidArray.count + 1) % ROWCOUNT == 0) {
        x = (viewWidth + b_space) * ROWCOUNT + b_space;
        self.imagephoto.frame = CGRectMake(x - (viewWidth + b_space), y - (viewWidth + 10), w ,h);
    } else {
        self.imagephoto.frame = CGRectMake(x - (viewWidth + b_space), y, w ,h);
    }
    if (self.aidArray.count < self.maxImage) {
        self.imagephoto.hidden = NO;
        self.imagephoto.enabled = YES;
    }
}

// block干活
- (void)addImage {
    if (self.addPhotoBlock) {
        self.addPhotoBlock();
    }
}

@end
