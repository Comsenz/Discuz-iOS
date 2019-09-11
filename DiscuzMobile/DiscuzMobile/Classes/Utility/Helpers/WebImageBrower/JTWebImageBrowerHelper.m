//
//  JTWebImageBrowerHelper.m
//  DiscuzMobile
//
//  Created by ZhangJitao on 2018/4/13.
//  Copyright © 2018年 comsenz-service.com.  All rights reserved.
//

#import "JTWebImageBrowerHelper.h"
#import "SDPhotoBrowser.h"

@interface JTWebImageBrowerHelper()<SDPhotoBrowserDelegate>
@property (nonatomic, strong) NSMutableArray *imagesArray;
@property (nonatomic, strong) NSMutableArray *thumbArray;
@end

@implementation JTWebImageBrowerHelper
+ (instancetype)shareInstance {
    static JTWebImageBrowerHelper *helper = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        helper = [[JTWebImageBrowerHelper alloc] init];
    });
    return helper;
}

- (void)showPhotoImageSources:(NSArray *)imagesArray thumImages:(NSArray *)thumArray currentIndex:(NSInteger)index imageContainView:(UIView *)imageBgV {
    SDPhotoBrowser *photoBrowser = [SDPhotoBrowser new];
    photoBrowser.delegate = self;
    self.imagesArray = imagesArray.mutableCopy;
    self.thumbArray = thumArray.mutableCopy;
    photoBrowser.currentImageIndex = index;
    photoBrowser.imageCount = self.imagesArray.count;
    photoBrowser.sourceImagesContainerView = imageBgV;
    [photoBrowser show];
}

#pragma mark - 图片查看器delegate
// 返回临时占位图片（即原来的小图）
- (UIImage *)photoBrowser:(SDPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index {
    UIImageView *imageView = [[UIImageView alloc] init];
    if ([self.thumbArray[index] isKindOfClass:[UIImage class]]) {
        imageView.image = self.thumbArray[index];
    } else {
        NSString *urlStr = self.thumbArray[index];
        [imageView sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:[UIImage imageNamed:@"wutu"] options:SDWebImageRetryFailed];
    }
    return imageView.image;
}

// 返回高质量图片的url
- (NSURL *)photoBrowser:(SDPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index {
    if ([self.imagesArray[index] isKindOfClass:[UIImage class]]) {
        return nil;
    }
    NSString *urlStr = self.imagesArray[index];
    return [NSURL URLWithString:urlStr];
}

#pragma mark - getting setting
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
