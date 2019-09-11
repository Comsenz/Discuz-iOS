//
//  UploadTool.h
//  DiscuzMobile
//
//  Created by HB on 2017/6/16.
//  Copyright © 2017年 comsenz-service.com.  All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, JTAttacheType) {
    JTAttacheImage,
    JTAttacheVote,
    JTAttacheAudio,
    JTAttacheCustom,
};

@interface UploadTool : NSObject

+ (instancetype)shareInstance;
@property (nonatomic, strong) NSDictionary *uploadErrorDic;

/**
 上传附件，图片、录音
 
 @param attachArr 附件数组
 @param attacheType 附件类型
 @param getDic get参数
 @param postDic post参数
 @param complete 完成回调
 @param success 成功回调
 @param failure 失败回调
 */
- (void)upLoadAttachmentArr:(NSArray *)attachArr attacheType:(JTAttacheType)attacheType getDic:(NSDictionary *)getDic postDic:(NSDictionary *)postDic complete:(void(^)(void))complete success:(void(^)(id response))success failure:(void(^)(NSError *error))failure;

@end
