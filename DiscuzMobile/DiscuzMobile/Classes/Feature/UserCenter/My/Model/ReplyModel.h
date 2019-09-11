//
//  ReplyModel.h
//  DiscuzMobile
//
//  Created by HB on 2017/6/12.
//  Copyright © 2017年 comsenz-service.com.  All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ReplyModel : NSObject

@property (nonatomic, strong) NSString *tid;
@property (nonatomic, strong) NSString *message;
@property (nonatomic, strong) NSString *subject;
@property (nonatomic, strong) NSString *auther;
@property (nonatomic, strong) NSString *positions;
@property (nonatomic, strong) NSString *dateline;

@end
