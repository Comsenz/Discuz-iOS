//
//  DiscoverModel.h
//  DiscuzMobile
//
//  Created by ZhangJitao on 2019/7/22.
//  Copyright © 2019 comsenz-service.com.  All rights reserved.
//

#import "DZBaseVarModel.h"
@class ThreadListModel;

NS_ASSUME_NONNULL_BEGIN

@interface DiscoverModel : DZBaseVarModel

@property (nonatomic, strong) NSArray<ThreadListModel *> *data;
@property (nonatomic, copy) NSString *total;

@end

NS_ASSUME_NONNULL_END
