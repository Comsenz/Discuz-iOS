//
//  DZAttachment.h
//  DiscuzMobile
//
//  Created by ZhangJitao on 2019/7/22.
//  Copyright © 2019 comsenz-service.com.  All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface DZAttachment : BaseModel
@property (nonatomic, strong) NSString *aid;
@property (nonatomic, strong) NSString *tid;
@property (nonatomic, strong) NSString *pid;
@property (nonatomic, strong) NSString *uid;
@property (nonatomic, strong) NSString *dateline;
@property (nonatomic, strong) NSString *attachment;
@property (nonatomic, strong) NSString *thumb;
@property (nonatomic, strong) NSString *readperm;
@property (nonatomic, strong) NSString *type;
@end

NS_ASSUME_NONNULL_END
