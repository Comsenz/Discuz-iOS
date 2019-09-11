//
//  ForumInfoModel.h
//  DiscuzMobile
//
//  Created by HB on 16/12/21.
//  Copyright © 2016年 comsenz-service.com.  All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ForumInfoModel : NSObject

// 版块中用
@property (nonatomic, strong) NSDictionary *infoDic;
@property (nonatomic, strong) NSString *fid;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *icon;
@property (nonatomic, strong) NSString *todayposts; // 今日
@property (nonatomic, strong) NSString *posts;      // 帖子数
@property (nonatomic, strong) NSString *threads;    // 主题数
@property (nonatomic, strong) NSString *descrip;
@property (nonatomic, strong) NSString *allowpostspecial;
@property (nonatomic, strong) NSString *allowspecialonly;
@property (nonatomic, strong) NSString *lastpost;
@property (nonatomic, strong) NSString *rank;
@property (nonatomic, strong) NSString *favorited;
@property (nonatomic, copy) NSString *threadmodcount;

// 首页中用
@property (nonatomic, strong) NSString *title;


@end
