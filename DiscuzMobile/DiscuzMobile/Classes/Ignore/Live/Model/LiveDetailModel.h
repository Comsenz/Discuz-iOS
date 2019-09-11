//
//  LiveDetailModel.h
//  DiscuzMobile
//
//  Created by HB on 2017/5/17.
//  Copyright © 2017年 comsenz-service.com.  All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LiveDetailModel : NSObject

@property (nonatomic, strong) NSString *authorid;
@property (nonatomic, strong) NSString *author;
@property (nonatomic, strong) NSString *message;
@property (nonatomic, strong) NSString *dateline;
@property (nonatomic, strong) NSString *dbdateline;
@property (nonatomic, strong) NSString *gdateline;
@property (nonatomic, strong) NSString *avatar;
@property (nonatomic, strong) NSString *sort;
@property (nonatomic, strong) NSMutableArray *imglist;
@property (nonatomic, strong) NSMutableArray *thumlist;
@property (nonatomic, strong) NSString *pid;

@end
