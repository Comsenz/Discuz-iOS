//
//  JTAttributedTextCell.m
//  MyCoreTextDemo
//
//  Created by HB on 2017/8/28.
//  Copyright © 2017年 comsenz-service.com.  All rights reserved.
//

#import "LiveHostCell.h"
#import "LiveDetailModel.h"
#import "SDPhotoBrowser.h"
#import "JudgeImageModel.h"
#import "JTWebImageBrowerHelper.h"

@interface LiveHostCell()
@property (nonatomic, strong) UIImageView *timeImagV;
@end


@implementation LiveHostCell

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.timeImagV = [[UIImageView alloc] init];
        self.imageBgV = [[UIView alloc] init];
        self.webClickDelegate = self;
        [self.contentView addSubview:self.imageBgV];
        [self.webImageArray removeAllObjects];
    }
    return self;
}

- (void)setFrame:(CGRect)frame {
    frame.size.height -= 5;
    [super setFrame:frame];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (!self.superview) {
        return;
    }
    CGSize sugestSize = [self.attributedTextContextView suggestedFrameSizeToFitEntireStringConstraintedToWidth:self.contentView.bounds.size.width - 20];
    CGFloat neededContentHeight = sugestSize.height;
    // after the first call here the content view size is correct
    CGRect frame = CGRectMake(10, 10, WIDTH - 20, neededContentHeight);
    self.imageBgV.frame = CGRectMake(0, CGRectGetMaxY(frame), WIDTH, 0);
    if (self.imagesArray.count > 0) {
        self.imageBgV.frame = CGRectMake(0, CGRectGetMaxY(frame), WIDTH, 90);
    }
    self.attributedTextContextView.frame = frame;
    self.timeImagV.frame = CGRectMake(0, 3, 38, 16);
}

- (CGFloat)requiredRowHeightInTableView:(UITableView *)tableView {
    CGSize neededSize = [self.attributedTextContextView suggestedFrameSizeToFitEntireStringConstraintedToWidth:WIDTH - 20];
    if (self.imagesArray.count > 0) {
        return neededSize.height + 20 + 90 + 5;
    }
    // note: non-integer row heights caused trouble < iOS 5.0
    return neededSize.height + 20 + 5;
}

#pragma mark Properties
- (void)setInfo:(LiveDetailModel *)model {
    for (UIView *iv in self.imageBgV.subviews) {
        [iv removeFromSuperview];
    }
    
    NSString *time = [NSDate timeStringFromTimestamp:model.dbdateline format:@"HH:mm"];
    NSString *message = message = [NSString stringWithFormat:@"&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;%@",model.message];;
    
    [self setHTMLString:message];
    
    UIImage *timeImage = [self createShareImage:@"time_image" Context:time];
    
    self.timeImagV.frame = CGRectMake(0, 0, 38, 16);
    self.timeImagV.contentMode = UIViewContentModeScaleAspectFit;
    self.timeImagV.image = timeImage;
    [self.attributedTextContextView addSubview:self.timeImagV];
    
    self.imagesArray = [NSMutableArray array];
    self.thumbArray = [NSMutableArray array];
    if (model.imglist.count > 0 && [JudgeImageModel graphFreeModel] == NO) { // 有附件图片的，接口没有返回，这里假数据占位
        CGFloat picWidth = (WIDTH - 30 - 20) / 3;
        self.imageBgV.frame = CGRectMake(0, CGRectGetMaxY(self.attributedTextContextView.frame), WIDTH, 90);
        NSInteger count = (model.imglist.count > 3)?3:model.imglist.count;
        
        for (int i = 0; i < model.imglist.count; i ++) {
            
            [self.imagesArray addObject:model.imglist[i]];
            if ([DataCheck isValidArray:model.thumlist]) {
                [self.thumbArray addObject:model.thumlist[i]];
            } else {
                [self.thumbArray addObject:model.imglist[i]];
            }
            
            
            if (i < count) {
                UIImageView *imageV = [[UIImageView alloc] init];
                imageV.backgroundColor = [UIColor groupTableViewBackgroundColor];
                [self.imageBgV addSubview:imageV];
                
                if ([model.imglist[i] isKindOfClass:[UIImage class]]) {
                    
                    imageV.image = model.imglist[i];
                    
                } else {
                    [imageV sd_setImageWithURL:[NSURL URLWithString:model.thumlist[i]] placeholderImage:[UIImage imageNamed:@"wutu"] options:SDWebImageRetryFailed];
                    
                }
                
                
                imageV.userInteractionEnabled = YES;
                imageV.clipsToBounds = YES;
                imageV.contentMode = UIViewContentModeScaleAspectFill;
                imageV.tag = 100 + i;
                UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageClick:)];
                [imageV addGestureRecognizer:tapGes];

                imageV.frame = CGRectMake(15 + (picWidth + 12) * i, 10, picWidth, CGRectGetHeight(self.imageBgV.frame) - 10);
                
                if (i == count - 1 && count < model.imglist.count) {
                    UILabel *tipLab = [[UILabel alloc] initWithFrame:imageV.bounds];
                    [imageV addSubview:tipLab];
                    tipLab.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.3];
                    tipLab.textAlignment = NSTextAlignmentCenter;
                    tipLab.text = [NSString stringWithFormat:@"+%ld",model.imglist.count - count];
                    tipLab.textColor = [UIColor whiteColor];
                    tipLab.font = [UIFont boldSystemFontOfSize:30.0];
                    tipLab.userInteractionEnabled = NO;
                }
            }
            
            
        }
    } else {
        self.imageBgV.frame = CGRectMake(0, CGRectGetMaxY(self.attributedTextContextView.frame), WIDTH, 0);
    }
    
}

// imageName 图片名字， text 需画的字体
- (UIImage *)createShareImage:(NSString *)imageName Context:(NSString *)text {
    UIImage *sourceImage = [UIImage imageNamed:imageName];
    CGSize imageSize; //画的背景 大小
    imageSize = [sourceImage size];
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0.0);
    [sourceImage drawAtPoint:CGPointMake(0, 0)];
    //获得 图形上下文
    CGContextRef context=UIGraphicsGetCurrentContext();
    CGContextDrawPath(context, kCGPathStroke);
    CGFloat nameFont = 25.f;
    //画 自己想要画的内容
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:nameFont],NSForegroundColorAttributeName:[UIColor whiteColor]};
    CGRect sizeToFit = [text boundingRectWithSize:CGSizeMake(90, nameFont) options:NSStringDrawingUsesDeviceMetrics attributes:attributes context:nil];
    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
    [text drawAtPoint:CGPointMake((imageSize.width - sizeToFit.size.width)/2 - 3,(imageSize.height-sizeToFit.size.height)/2 - 5)  withAttributes:attributes];
    //返回绘制的新图形
    UIImage *newImage=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (void)imageClick:(UITapGestureRecognizer *)sender {
    NSInteger index = [sender view].tag - 100;
    [[JTWebImageBrowerHelper shareInstance] showPhotoImageSources:self.imagesArray thumImages:self.thumbArray currentIndex:index imageContainView:self.imageBgV];
}

#pragma mark - DTWebClickDelegate
- (void)linkDidClick:(NSString *)linkUrl {
    
}

- (void)webImageClick:(NSString *)imageUrl index:(NSInteger)index {
    [[JTWebImageBrowerHelper shareInstance] showPhotoImageSources:self.webImageArray thumImages:self.webImageArray currentIndex:index imageContainView:self];
}

- (NSMutableArray *)imagesArray {
    if (!_imagesArray) {
        _imagesArray = [NSMutableArray array];
    }
    return _imagesArray;
}

- (NSMutableArray *)thumbArray {
    if (!_thumbArray) {
        _thumbArray = [NSMutableArray array];
    }
    return _thumbArray;
}

@end
