//
//  MessageListModel.h
//  DiscuzMobile
//
//  Created by HB on 2017/5/9.
//  Copyright © 2017年 comsenz-service.com.  All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MessageListModel : NSObject

@property (nonatomic, strong) NSString *author;
@property (nonatomic, strong) NSString *authorid;
@property (nonatomic, strong) NSString *category;
@property (nonatomic, strong) NSString *dateline;
@property (nonatomic, strong) NSString *vdateline;
@property (nonatomic, strong) NSString *tousername;
@property (nonatomic, strong) NSString *toavatar;
@property (nonatomic, strong) NSString *message;
@property (nonatomic, strong) NSString *from_id;
@property (nonatomic, strong) NSString *from_idtype;
@property (nonatomic, strong) NSString *from_num;
@property (nonatomic, strong) NSString *msgid;
@property (nonatomic, strong) NSString *uid;
@property (nonatomic, strong) NSString *mnew;
@property (nonatomic, strong) NSString *note;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *touid;
@property (nonatomic, strong) NSMutableDictionary *notevar;

@end
