//
//  PostActivityModel.h
//  DiscuzMobile
//
//  Created by HB on 2017/7/4.
//  Copyright © 2017年 comsenz-service.com.  All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PostNormalModel.h"

@interface PostActivityModel : PostNormalModel

@property (nonatomic ,strong) NSString *activityClass; // 分类
@property (nonatomic ,strong) NSString *startTime; // 开始时间
@property (nonatomic ,strong) NSString *endTime;  // 结束时间
@property (nonatomic ,strong) NSString *place;   // 地点
@property (nonatomic ,strong) NSString *peopleNum; // 人数
@property (nonatomic ,strong) NSMutableArray * userArray ; // 用户自定 选项

@property (nonatomic, strong) NSString *activitycity; // 城市
@property (nonatomic, strong) NSString *gender;  // 性别
@property (nonatomic, strong) NSString *activitycredit;  // 积分
@property (nonatomic, strong) NSString *cost;   // 花销
@property (nonatomic, strong) NSString *activityexpiration;  // 截止时间

@end
