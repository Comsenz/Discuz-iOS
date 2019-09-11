//
//  CollectionTool.h
//  DiscuzMobile
//
//  Created by HB on 2017/6/13.
//  Copyright © 2017年 comsenz-service.com.  All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CollectionTool : NSObject

+ (instancetype)shareInstance;
// 收藏板块
- (void)collectionForum:(id)getDic andPostdic:(id)postDic success:(void(^)(void))success failure:(void(^)(NSError *error))failure;
// 取消收藏（帖子、板块）
- (void)collectionThread:(id)getDic andPostdic:(id)postDic success:(void(^)(void))success failure:(void(^)(NSError *error))failure;
// 收藏帖子
- (void)deleCollection:(id)getDic andPostdic:(id)postDic success:(void(^)(void))success failure:(void(^)(NSError *error))failure;

@end
