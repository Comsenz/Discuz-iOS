//
//  CenterManageModel.h
//  DiscuzMobile
//
//  Created by HB on 2017/9/8.
//  Copyright © 2017年 comsenz-service.com.  All rights reserved.
//

#import <Foundation/Foundation.h>
@class TextIconModel;

typedef NS_ENUM(NSUInteger, JTCenterType) {
    JTCenterTypeMy = 0,
    JTCenterTypeOther,
};

@interface CenterManageModel : NSObject

@property (nonatomic, strong) NSMutableDictionary *myInfoDic;

@property (nonatomic, strong) NSMutableArray<TextIconModel *> *useArr;  // 他人中心用
@property (nonatomic, assign) BOOL isOther;

// 公用
@property (nonatomic, strong) NSMutableArray<TextIconModel *> *manageArr;

@property (nonatomic, strong) NSMutableArray<TextIconModel *> *infoArr;

- (instancetype)initWithType:(JTCenterType)type;

- (void)dealOtherData:(id)responseObject;
- (void)dealData:(id)responseObject;

@end
