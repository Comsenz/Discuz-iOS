//
//  MessageNoticeCenter.m
//  DiscuzMobile
//
//  Created by HB on 2017/8/7.
//  Copyright © 2017年 comsenz-service.com.  All rights reserved.
//

#import "MessageNoticeCenter.h"

@implementation MessageNoticeCenter

+ (instancetype)shareInstance {
    static MessageNoticeCenter *notiCenter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        notiCenter = [[MessageNoticeCenter alloc] init];
    });
    return notiCenter;
}

- (NSMutableDictionary *)noticeDic {
    if (!_noticeDic) {
        _noticeDic = [NSMutableDictionary dictionary];
    }
    return _noticeDic;
}

@end
