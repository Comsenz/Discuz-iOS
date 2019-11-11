//
//  BoundInfoModel.h
//  DiscuzMobile
//
//  Created by HB on 2017/7/13.
//  Copyright © 2017年 comsenz-service.com.  All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BoundInfoModel : NSObject
@property (nonatomic, strong) NSString *uid;
@property (nonatomic, strong) NSString *openid;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *session_key;
@property (nonatomic, strong) NSString *type;

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *icon;
@end
