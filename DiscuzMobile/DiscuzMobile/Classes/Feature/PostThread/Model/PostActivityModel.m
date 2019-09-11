//
//  PostActivityModel.m
//  DiscuzMobile
//
//  Created by HB on 2017/7/4.
//  Copyright © 2017年 comsenz-service.com.  All rights reserved.
//

#import "PostActivityModel.h"

@implementation PostActivityModel

- (NSMutableArray *)userArray {
    if (!_userArray) {
        _userArray = [NSMutableArray array];
    }
    return _userArray;
}

@end
