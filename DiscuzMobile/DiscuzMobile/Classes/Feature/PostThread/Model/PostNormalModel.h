//
//  PostNormalModel.h
//  DiscuzMobile
//
//  Created by HB on 2017/6/26.
//  Copyright © 2017年 comsenz-service.com.  All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PostNormalModel : NSObject

@property (nonatomic, strong) NSString *subject;     // 标题
@property (nonatomic, strong) NSString *message;     // 详细
@property (nonatomic, strong) NSMutableArray *aidArray;

@property (nonatomic, strong) NSString *typeId;     // 选择类型

@end
