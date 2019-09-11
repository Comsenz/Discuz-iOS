//
//  UIImage+Limit.m
//  DiscuzMobile
//
//  Created by ZhangJitao on 2019/7/25.
//  Copyright © 2019 comsenz-service.com.  All rights reserved.
//

#import "UIImage+Limit.h"

@implementation UIImage (Limit)
- (NSData *)limitImageSize {
    UIImage *image = self;
    float imageViewWidth = 1040.0;
    float imageViewHeight = 720.0;
    UIImage * thumbImage;
    CGFloat compression = 0.9f;
    CGFloat maxCompression = 0.1f;
    CGFloat M = 1  * 1000 * 1000;
    
    NSData *imageData = UIImageJPEGRepresentation(image, 0.8);
    NSData *data;
    if ([imageData length] < M) {
        thumbImage = image;
    } else {
        thumbImage = [image transformWithLockedRatioWidth:imageViewWidth
                                                height:imageViewHeight
                                                rotate:YES];
    }
    if (UIImagePNGRepresentation(thumbImage) == nil) {
        data = UIImageJPEGRepresentation(thumbImage, 0.8);
    } else {
        data = UIImagePNGRepresentation(thumbImage);
    }
    
    while ([data length] > M && compression > maxCompression) {
        compression -= 0.1;
        data = UIImageJPEGRepresentation(thumbImage, compression);
    }
    
    return data;
}

- (UIImage*)transformWithLockedRatioWidth:(CGFloat)width
                              height:(CGFloat)height rotate:(BOOL)rotate
{
    UIImage *image = self;
    float sourceWidth = image.size.width;
    float sourceHeight = image.size.height;
    
    float widthRatio = width / sourceWidth;  // 与期望的宽度比例 如期望100 / 实际50  = 2
    float heightRatio = height / sourceHeight; // 与期望的高度比例 如期望200 / 实际400 = 0.5
    
    
    if (widthRatio <= 1 && heightRatio <= 0) {
        return image;
    }
    
    
    float destWidth, destHeight;
    if (widthRatio > heightRatio) { // 选取真正是缩小比例的方法
        destWidth = sourceWidth * heightRatio; // 为了保证原图的比例调整，之前的比例不对，期望高度改为 100 * 0.5 = 50
        destHeight = height; // 期望高度还是 200
    } else {
        destWidth = width;
        destHeight = sourceHeight * widthRatio;
    }
    
    return [image transformWidth:destWidth height:destHeight rotate:rotate];
}


- (UIImage*)transformWidth:(CGFloat)width
               height:(CGFloat)height rotate:(BOOL)rotate
{
    UIImage *image = self;
    CGFloat destW = roundf(width);
    CGFloat destH = roundf(height);
    CGFloat sourceW = roundf(width);
    CGFloat sourceH = roundf(height);
    
    if (rotate) {
        if (image.imageOrientation == UIImageOrientationRight
            || image.imageOrientation == UIImageOrientationLeft) {
            sourceW = height;
            sourceH = width;
        }
    }
    
    CGImageRef imageRef = image.CGImage;  // 转化为位图
    
    int bytesPerRow = destW * (CGImageGetBitsPerPixel(imageRef) >> 3); // 每行像素点大小(CGImageGetBitsPerPixel(imageRef) >> 3) = CGImageGetBitsPerPixel(imageRef) / 8
    
    CGContextRef bitmap = CGBitmapContextCreate(NULL,
                                                destW,
                                                destH,
                                                CGImageGetBitsPerComponent(imageRef),
                                                bytesPerRow,
                                                CGImageGetColorSpace(imageRef),
                                                CGImageGetBitmapInfo(imageRef));
    
    if (rotate) {
        if (image.imageOrientation == UIImageOrientationDown) {
            CGContextTranslateCTM(bitmap, sourceW, sourceH);
            CGContextRotateCTM(bitmap, 180 * (M_PI/180));
            
        } else if (image.imageOrientation == UIImageOrientationLeft) {
            CGContextTranslateCTM(bitmap, sourceH, 0);
            CGContextRotateCTM(bitmap, 90 * (M_PI/180));
            
        } else if (image.imageOrientation == UIImageOrientationRight) {
            CGContextTranslateCTM(bitmap, 0, sourceW);
            CGContextRotateCTM(bitmap, -90 * (M_PI/180));
        }
    }
    
    CGContextDrawImage(bitmap, CGRectMake(0, 0, sourceW, sourceH), imageRef);
    
    CGImageRef ref = CGBitmapContextCreateImage(bitmap);
    UIImage *result = [UIImage imageWithCGImage:ref];
    CGContextRelease(bitmap);
    CGImageRelease(ref);
    
    return result;
}
@end
