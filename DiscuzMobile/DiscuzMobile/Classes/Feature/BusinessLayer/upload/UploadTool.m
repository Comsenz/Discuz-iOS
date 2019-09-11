//
//  UploadTool.m
//  DiscuzMobile
//
//  Created by HB on 2017/6/16.
//  Copyright © 2017年 comsenz-service.com.  All rights reserved.
//

#import "UploadTool.h"
#import "UIImage+Limit.h"

@implementation UploadTool

+ (instancetype)shareInstance {
    static UploadTool *upTool = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        upTool = [[UploadTool alloc] init];
    });
    return upTool;
}

- (void)upLoadAttachmentArr:(NSArray *)attachArr attacheType:(JTAttacheType)attacheType getDic:(NSDictionary *)getDic postDic:(NSDictionary *)postDic complete:(void(^)(void))complete success:(void(^)(id response))success failure:(void(^)(NSError *error))failure {
    
    NSMutableDictionary *getParam = getDic.mutableCopy;
    [DZApiRequest requestWithConfig:^(JTURLRequest *request) {
        
        if (attacheType == JTAttacheImage || attacheType == JTAttacheVote) {
//            type=image&
            if (attacheType == JTAttacheImage) {
                [getParam setValue:@"image" forKey:@"type"];
            }
            
            for (UIImage *image in attachArr) {
                NSData *data = [image limitImageSize];
                NSString *nowTime = [[NSDate date] stringFromDateFormat:@"yyyyMMddHHmmss"];
                NSString *fileName = [NSString stringWithFormat:@"%@.png", nowTime];
                [request addFormDataWithName:@"Filedata" fileName:fileName mimeType:@"image/png" fileData:data];
            }
        } else if (attacheType == JTAttacheAudio) {
            for (NSString *soundPath in attachArr) {
                NSData *audioData = [NSData dataWithContentsOfFile:soundPath];
                NSString *nowTime = [[NSDate date] stringFromDateFormat:@"yyyyMMddHHmmss"];
                NSString * fileName = [NSString stringWithFormat:@"%@.mp3", nowTime];
                [request addFormDataWithName:@"Filedata" fileName:fileName mimeType:@"audio/mp3" fileData:audioData];
            }
        }
        request.urlString = url_upload;
        request.getParam = getParam;
        request.parameters = postDic;
        request.methodType = JTMethodTypeUpload;
    } progress:^(NSProgress *progress) {
        if (100.f * progress.completedUnitCount/progress.totalUnitCount == 100) {
//            complete?complete():nil;
        }
        DLog(@"onProgress: %.2f", 100.f * progress.completedUnitCount/progress.totalUnitCount);
    } success:^(id responseObject, JTLoadType type) {
        complete?complete():nil;
        if (attacheType == JTAttacheVote) {
            id resDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            success?success(resDic):nil;
        } else {
            NSString * str =[[NSMutableString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            DLog(@"二进制转化的字符串%@",str);
            if ([DataCheck isValidString:str]) {
                NSArray *responseArr = [str componentsSeparatedByString:@"|"];
                if (responseArr.count == 5) {
                    NSString *messageStatus = responseArr[1];
                    if ([messageStatus isEqualToString:@"0"]) {
                        NSString *aidStr = responseArr[2];
                        if (success) {
                            success(aidStr);
                        }
                    } else {
                        [MBProgressHUD showInfo:[self.uploadErrorDic objectForKey:messageStatus]];
                    }
                    return;
                }
            }
            [MBProgressHUD showInfo:@"上传失败"];
        }
        
    } failed:^(NSError *error) {
        complete?complete():nil;
        failure?failure(error):nil;
    }];
}

- (void)newUpload:(NSArray *)attachArr {
    
   
    
}


- (NSDictionary *)uploadErrorDic {
    if (!_uploadErrorDic) {
        _uploadErrorDic = @{@"-1":@"内部服务器错误",
                            @"0":@"上传成功",
                            @"1":@"不支持此类扩展名",
                            @"2":@"服务器限制无法上传那么大的附件",
                            @"3":@"用户组限制无法上传那么大的附件",
                            @"4":@"不支持此类扩展名",
                            @"5":@"文件类型限制无法上传那么大的附件",
                            @"6":@"今日您已无法上传更多的附件",
                            @"7":@"请选择图片文件",
                            @"8":@"附件文件无法保存",
                            @"9":@"没有合法的文件被上传",
                            @"10":@"非法操作",
                            @"11":@"今日您已无法上传那么大的附件"};
    }
    return _uploadErrorDic;
}

@end
