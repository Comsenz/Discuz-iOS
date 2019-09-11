//
//  DZBaseVarModel.h
//  DiscuzMobile
//
//  Created by ZhangJitao on 2019/7/22.
//  Copyright © 2019 comsenz-service.com.  All rights reserved.
//

#import "BaseModel.h"
@class DZNoticeModel;

NS_ASSUME_NONNULL_BEGIN

@interface DZBaseVarModel : BaseModel
@property (nonatomic, strong) NSString *cookiepre;
@property (nonatomic, strong) NSString *auth;
@property (nonatomic, strong) NSString *saltkey;
@property (nonatomic, strong) NSString *member_uid;
@property (nonatomic, strong) NSString *member_username;
@property (nonatomic, strong) NSString *member_avatar;
@property (nonatomic, strong) NSString *groupid;
@property (nonatomic, strong) NSString *formhash;
@property (nonatomic, strong) NSString *ismoderator;
@property (nonatomic, strong) NSString *readaccess;
@property (nonatomic, strong) DZNoticeModel *notice;
@end

NS_ASSUME_NONNULL_END
