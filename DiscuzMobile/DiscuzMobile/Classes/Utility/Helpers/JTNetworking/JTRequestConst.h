//
//  JTRequestConst.h
//  DiscuzMobile
//
//  Created by ZhangJitao on 2018/2/2.
//  Copyright © 2018年 comsenz-service.com.  All rights reserved.
//

#ifndef JTRequestConst_h
#define JTRequestConst_h


#ifdef DEBUG
#define JTRLog( s, ... ) NSLog( @"<%p %@:(%d)> %@", self, [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__] )
#else
#define JTRLog( s, ... )
#endif

@class JTURLRequest,JTBatchRequest;

/**
 用于标识不同类型的请求
 */
typedef NS_ENUM(NSInteger, JTLoadType) {
    /** 重新请求,   不读取缓存，重新请求*/
    JTRequestTypeRefresh,
    /** 读取缓存,   有缓存,读取缓存--无缓存，重新请求*/
    JTRequestTypeCache,
    /** 加载更多,   不读取缓存，重新请求*/
    JTRequestTypeRefreshMore,
    /** 加载更多,   有缓存,读取缓存--无缓存，重新请求*/
    JTRequestTypeCacheMore,
    /** 详情页面,   有缓存,读取缓存--无缓存，重新请求*/
    JTRequestTypeDetailCache,
    /** 自定义项,   有缓存,读取缓存--无缓存，重新请求*/
    JTRequestTypeCustomCache
};

/**
 HTTP 请求类型.
 */
typedef NS_ENUM(NSInteger,JTMethodType) {
    /**GET请求*/
    JTMethodTypeGET,
    /**POST请求*/
    JTMethodTypePOST,
    /**Upload请求*/
    JTMethodTypeUpload,
    /**DownLoad请求*/
    JTMethodTypeDownLoad
};

/**
 请求参数的格式.
 */
typedef NS_ENUM(NSUInteger, JTRequestSerializerType) {
    /** 设置请求参数为JSON格式*/
    JTJSONRequestSerializer,
    /** 设置请求参数为二进制格式*/
    JTHTTPRequestSerializer
};

/** 批量请求配置的Block */
typedef void (^batchRequestConfig)(JTBatchRequest * batchRequest);
/** 请求配置的Block */
typedef void (^JTRequestConfig)(JTURLRequest * request);
/** 请求成功的Block */
typedef void (^JTRequestSuccess)(id responseObject,JTLoadType type);
/** 请求失败的Block */
typedef void (^JTRequestFailed)(NSError * error);
/** 请求进度的Block */
typedef void (^JTProgressBlock)(NSProgress * progress);
/** 请求取消的Block */
typedef void (^JTCancelCompletedBlock)(NSString * urlString);

#endif /* JTRequestConst_h */
