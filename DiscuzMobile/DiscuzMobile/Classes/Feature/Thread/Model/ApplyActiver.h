//
//  ApplyActiver.h
//  DiscuzMobile
//
//  Created by HB on 2017/7/28.
//  Copyright © 2017年 comsenz-service.com.  All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ApplyActiver : NSObject

@property (nonatomic, strong) NSString *applyid;
@property (nonatomic, strong) NSString *dateline;
@property (nonatomic, strong) NSString *message;
@property (nonatomic, strong) NSString *uid;
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *verified;
@property (nonatomic, strong) NSString *payment;
@property (nonatomic, strong) NSDictionary *dbufielddata;
@property (nonatomic, strong) NSMutableArray *userfield;

@end
