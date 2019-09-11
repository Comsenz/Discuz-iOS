//
//  UploadAttachModel.m
//  DiscuzMobile
//
//  Created by ZhangJitao on 2018/3/26.
//  Copyright © 2018年 comsenz-service.com.  All rights reserved.
//

#import "UploadAttachModel.h"

@implementation UploadAttachModel

- (NSMutableArray<NSString *> *)aidArray {
    if (!_aidArray) {
        _aidArray = [NSMutableArray array];
    }
    return _aidArray;
}

- (NSMutableArray<WSImageModel *> *)imageModelArray {
    if (!_imageModelArray) {
        _imageModelArray = [NSMutableArray array];
    }
    return _imageModelArray;
}

- (NSMutableArray *)photosArray {
    if (!_photosArray) {
        _photosArray = [NSMutableArray array];
    }
    return _photosArray;
}

@end
