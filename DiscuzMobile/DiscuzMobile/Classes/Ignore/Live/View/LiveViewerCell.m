//
//  LiveViewerCell.m
//  DiscuzMobile
//
//  Created by HB on 2017/8/28.
//  Copyright © 2017年 comsenz-service.com.  All rights reserved.
//

#import "LiveViewerCell.h"
#import "LiveDetailModel.h"
#import "DTWebVideoView.h"
#import "JudgeImageModel.h"
#import "JTWebImageBrowerHelper.h"

@interface LiveViewerCell()<DTWebClickDelegate>

@end

@implementation LiveViewerCell

- (void)setFrame:(CGRect)frame
{
    frame.size.height -= 5;
    [super setFrame:frame];
}

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        self.webClickDelegate = self;
        [self commitInit];
    }
    
    return self;
}

- (void)commitInit {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.headIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"noavatar_small"]];
    self.headIcon.frame = CGRectMake(10, 10, 30, 30);
    self.headIcon.layer.masksToBounds = YES;
    self.headIcon.layer.cornerRadius = CGRectGetWidth(self.headIcon.frame) / 2;
    [self addSubview:self.headIcon];
    
    self.nameLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.headIcon.frame), CGRectGetMinY(self.headIcon.frame), 100, CGRectGetHeight(self.headIcon.frame))];
    self.nameLab.font = [FontSize HomecellNameFontSize16];
    self.nameLab.text = @"Jack";
    self.nameLab.textColor = LIGHT_TEXT_COLOR;
    [self addSubview:self.nameLab];
    
    CGSize maxSize = CGSizeMake(120, 30);
    CGSize textSize = [self.nameLab.text sizeWithFont:[FontSize HomecellNameFontSize16] maxSize:maxSize];
    self.nameLab.frame = CGRectMake(CGRectGetMaxX(self.headIcon.frame) + 10, CGRectGetMidY(self.headIcon.frame) - 15, textSize.width, 30);
    
    self.gradeLab = [[UILabel alloc] init];
    self.gradeLab.font = [FontSize gradeFontSize9];
    self.gradeLab.textAlignment = NSTextAlignmentCenter;
    self.gradeLab.textColor = NAVI_BAR_COLOR;
    self.gradeLab.backgroundColor = MAIN_COLLOR;
    [self.contentView addSubview:self.gradeLab];
    
    self.timeLab = [[UILabel alloc] init];
    self.timeLab.textAlignment = NSTextAlignmentRight;
    self.timeLab.textColor = LIGHT_TEXT_COLOR;
    self.timeLab.font = [FontSize HomecellTimeFontSize14];
    [self.contentView addSubview:self.timeLab];
    
    self.imageBgV = [[UIView alloc] init];
    [self.contentView addSubview:self.imageBgV];
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (!self.superview) {
        return;
    }
    CGSize sugestSize = [self.attributedTextContextView suggestedFrameSizeToFitEntireStringConstraintedToWidth:WIDTH - 20 - CGRectGetMaxX(self.headIcon.frame)];
    
    CGFloat neededContentHeight = sugestSize.height;
    // after the first call here the content view size is correct
    
    CGRect frame = CGRectMake(CGRectGetMinX(self.nameLab.frame), CGRectGetMaxY(self.headIcon.frame) + 5, WIDTH - 20 - CGRectGetMaxX(self.headIcon.frame), neededContentHeight);
    self.imageBgV.frame = CGRectMake(0, CGRectGetMaxY(frame), WIDTH, 0);
    if (self.imagesArray.count > 0) {
        self.imageBgV.frame = CGRectMake(0, CGRectGetMaxY(frame), WIDTH, 90);
    }
    self.attributedTextContextView.frame = frame;
}


- (CGFloat)requiredRowHeightInTableView:(UITableView *)tableView {
    CGSize neededSize = [self.attributedTextContextView suggestedFrameSizeToFitEntireStringConstraintedToWidth:WIDTH - 20 - CGRectGetMaxX(self.headIcon.frame)];
    
    if (self.imagesArray.count > 0) {
        return CGRectGetMaxY(self.headIcon.frame) + neededSize.height + 90 + 15 + 5;
    }
    // note: non-integer row heights caused trouble < iOS 5.0
    return CGRectGetMaxY(self.headIcon.frame) + neededSize.height + 15 + 5;
}

- (void)setInfo:(LiveDetailModel *)model {
    
    for (UIView *iv in self.imageBgV.subviews) {
        [iv removeFromSuperview];
    }
    self.headIcon.frame = CGRectMake(10, 10, 30, 30);
    
    [self.headIcon sd_setImageWithURL:[NSURL URLWithString:model.avatar] placeholderImage:[UIImage imageNamed:@"noavatar_small"] options:SDWebImageRetryFailed];
    self.nameLab.text = model.author;
    self.timeLab.text = [model.dateline transformationStr];
    
//    [self.titleLab setHtmlText:model.message];
    [self setHTMLString:model.message];
    
    
    CGSize maxSize = CGSizeMake(120, 30);
    CGSize textSize = [self.nameLab.text sizeWithFont:[FontSize HomecellNameFontSize16] maxSize:maxSize];
    self.nameLab.frame = CGRectMake(CGRectGetMaxX(self.headIcon.frame) + 10, CGRectGetMidY(self.headIcon.frame) - 15, textSize.width, 30);
    maxSize = CGSizeMake(100, 20);
    textSize = [self.gradeLab.text sizeWithFont:[FontSize gradeFontSize9] maxSize:maxSize];
    self.gradeLab.frame =  CGRectMake(CGRectGetMaxX(self.nameLab.frame) + 10, CGRectGetMidY(self.nameLab.frame) - textSize.height / 2, textSize.width + 4, textSize.height);
    self.gradeLab.layer.masksToBounds = YES;
    self.gradeLab.layer.cornerRadius = 2;
    self.timeLab.frame = CGRectMake(WIDTH - 120 - 15, CGRectGetMinY(self.nameLab.frame), 120, CGRectGetHeight(self.nameLab.frame));
    
//    CGFloat message_w = WIDTH - 20 - CGRectGetMaxX(self.headIcon.frame);
//    CGFloat htmlheight = [self.titleLab preferredSizeWithMaxWidth:message_w].height;
//    self.titleLab.frame = CGRectMake(CGRectGetMinX(self.nameLab.frame), CGRectGetMaxY(self.headIcon.frame) + 5, WIDTH - 20 - CGRectGetMaxX(self.headIcon.frame), htmlheight);
    
    self.imagesArray = [NSMutableArray array];
    self.thumbArray = [NSMutableArray array];
    
    if (model.imglist.count > 0 && [JudgeImageModel graphFreeModel] == NO) { // 有附件图片的，接口没有返回，这里假数据占位
        CGFloat picWidth = (WIDTH - 30 - 20) / 3;
        
        self.imageBgV.frame = CGRectMake(0, CGRectGetMaxY(self.attributedTextContextView.frame), WIDTH, 90);
        
        NSInteger count = 0;
        if (model.imglist.count > 0) {
            count = (model.imglist.count > 3)?3:model.imglist.count;
        }
        
        for (int i = 0; i < model.imglist.count; i ++) {
            
            NSString *imageSrc = @"";
            NSString *thumbSrc = @"";
            
            if ([DataCheck isValidDictionary:model.imglist[i]]) {
                NSDictionary *imgDic = model.imglist[i];
                imageSrc = [imgDic objectForKey:@"src"];
                imageSrc = [imageSrc makeDomain];
                
                thumbSrc = [imgDic objectForKey:@"srcthumb"];
                thumbSrc = [thumbSrc makeDomain];
            }
            
            if([model.imglist[i] isKindOfClass:[UIImage class]]) {
                [self.imagesArray addObject:model.imglist[i]];
                [self.thumbArray addObject:model.imglist[i]];
            } else {
                
                [self.imagesArray addObject:imageSrc];
                [self.thumbArray addObject:thumbSrc];
            }
            
            if (i < count) {
                UIImageView *imageV = [[UIImageView alloc] init];
                imageV.backgroundColor = [UIColor groupTableViewBackgroundColor];
                [self.imageBgV addSubview:imageV];
                
                if([model.imglist[i] isKindOfClass:[UIImage class]]) {
                    imageV.image = model.imglist[i];
                    
                } else {
                    [imageV sd_setImageWithURL:[NSURL URLWithString:thumbSrc] placeholderImage:[UIImage imageNamed:@"wutu"] options:SDWebImageRetryFailed];
                    
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
