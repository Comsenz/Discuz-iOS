//
//  DZNoticeModel.h
//  DiscuzMobile
//
//  Created by ZhangJitao on 2019/7/22.
//  Copyright © 2019 comsenz-service.com.  All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface DZNoticeModel : BaseModel
@property (nonatomic, strong) NSString *newpush;
@property (nonatomic, strong) NSString *newpm;
@property (nonatomic, strong) NSString *newprompt;
@property (nonatomic, strong) NSString *newmypost;
@end

NS_ASSUME_NONNULL_END
