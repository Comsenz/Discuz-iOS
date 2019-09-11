//
//  PostDebateModel.h
//  DiscuzMobile
//
//  Created by HB on 2017/6/26.
//  Copyright © 2017年 comsenz-service.com.  All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PostDebateModel : NSObject

@property (nonatomic, strong) NSString *subject;     // 标题
@property (nonatomic, strong) NSString *message;     // 详细
@property (nonatomic, strong) NSString *special;     // 5 固定参数
@property (nonatomic, strong) NSString *affirmpoint; // 正方观点
@property (nonatomic, strong) NSString *negapoint;   // 反方观点
@property (nonatomic, strong) NSString *endtime;     // 结束时间
@property (nonatomic, strong) NSString *umpire;      // 裁判

@property (nonatomic, strong) NSString *typeId;     // 选择类型

@end
