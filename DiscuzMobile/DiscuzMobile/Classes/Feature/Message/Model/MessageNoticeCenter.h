//
//  MessageNoticeCenter.h
//  DiscuzMobile
//
//  Created by HB on 2017/8/7.
//  Copyright © 2017年 comsenz-service.com.  All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MessageNoticeCenter : NSObject

+ (instancetype)shareInstance;

@property (nonatomic, strong) NSMutableDictionary* noticeDic;

@end
