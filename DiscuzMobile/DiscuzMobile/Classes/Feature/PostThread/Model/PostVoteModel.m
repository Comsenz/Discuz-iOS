//
//  PostVoteModel.m
//  DiscuzMobile
//
//  Created by HB on 2017/6/26.
//  Copyright © 2017年 comsenz-service.com.  All rights reserved.
//

#import "PostVoteModel.h"

@implementation PostVoteModel

- (NSMutableArray *)polloptionArr {
    if (!_polloptionArr) {
        _polloptionArr = [NSMutableArray array];
    }
    return _polloptionArr;
}

- (NSMutableArray *)aidArray {
    if (!_aidArray) {
        _aidArray = [NSMutableArray array];
    }
    return _aidArray;
}

- (NSMutableArray *)checkArr {
    if (!_checkArr) {
        _checkArr = [NSMutableArray array];
    }
    return _checkArr;
}

@end
