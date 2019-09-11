//
//  HotLivelistModel.h
//  DiscuzMobile
//
//  Created by HB on 2017/5/17.
//  Copyright © 2017年 comsenz-service.com.  All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HotLivelistModel : NSObject

@property (nonatomic, strong) NSString *tid;
@property (nonatomic, strong) NSString *pid;
@property (nonatomic, strong) NSString *avatar;
@property (nonatomic, strong) NSString *author;
@property (nonatomic, strong) NSString *authorid;
@property (nonatomic, strong) NSString *dateline;
@property (nonatomic, strong) NSString *subject;
@property (nonatomic, strong) NSString *replies;
@property (nonatomic, strong) NSString *views;
@property (nonatomic, strong) NSString *price;
@property (nonatomic, strong) NSString *fid;
@property (nonatomic, strong) NSString *attachment;
@property (nonatomic, strong) NSString *grouptitle;
@property (nonatomic, strong) NSString *liveIcon;

@property (nonatomic, strong) NSDictionary *forumnames;

+ (NSArray *)setHotLiveData:(id)responseObject;
+ (NSArray *)setRecommonLiveData:(id)responseObject;


@end
