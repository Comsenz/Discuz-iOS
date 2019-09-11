//
//  ThreadModel.h
//  DiscuzMobile
//
//  Created by HB on 17/3/7.
//  Copyright © 2017年 comsenz-service.com.  All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ThreadModel : NSObject

@property (nonatomic, strong) NSString *tid;
@property (nonatomic, strong) NSString *subject;
@property (nonatomic, strong) NSString *dateline;
@property (nonatomic, strong) NSString *author;
@property (nonatomic, strong) NSDictionary *threadDic; // set方法处理全部数据
@property (nonatomic, assign) NSInteger currentPage;

@property (nonatomic, strong) NSURL *baseUrl;

@property (nonatomic, strong) NSString *specialString;
@property (nonatomic, strong) NSData *jsonData; // 注入 html JSON

@property (nonatomic, strong) NSString *favorited;
@property (nonatomic, strong) NSString *recommend;
@property (nonatomic, strong) NSString *shareUrl;
@property (nonatomic, strong) NSString *shareImageUrl;
@property (nonatomic, strong) NSString *isnoimage;
@property (nonatomic, strong) NSString *fid;
@property (nonatomic, strong) NSString *pid;
@property (nonatomic, assign) NSInteger ppp;
@property (nonatomic, assign) NSInteger replies;
@property (nonatomic, assign) BOOL isActivity;  // yes参加或者 no 取消活动
@property (nonatomic, assign) BOOL isRequest;

@property (nonatomic, strong) NSString *allowpost;             // 发帖权限
@property (nonatomic, strong) NSString *allowreply;            // 回复权限
@property (nonatomic, strong) NSString *uploadhash;


@end
