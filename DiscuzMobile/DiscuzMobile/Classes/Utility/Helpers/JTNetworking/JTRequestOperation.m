//
//  JTRequestOperation.m
//  DiscuzMobile
//
//  Created by ZhangJitao on 2018/2/2.
//  Copyright © 2018年 comsenz-service.com.  All rights reserved.
//

#import "JTRequestOperation.h"
#import "JTCacheManager.h"

@interface JTRequestOperation()

@property (nonatomic, assign) BOOL networkError;
@property (nonatomic, strong) NSError *serializationError;

@end

@implementation JTRequestOperation

+ (JTRequestOperation *)shareInstance {
    static JTRequestOperation *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[JTRequestOperation alloc] init];
    });
    return instance;
}

- (instancetype)init
{
    self = [super initWithSessionConfiguration:NSURLSessionConfiguration.defaultSessionConfiguration];
    if (self) {
        //无条件地信任服务器端返回的证书。
        self.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        self.securityPolicy = [AFSecurityPolicy defaultPolicy];
        self.securityPolicy.allowInvalidCertificates = YES;
        self.securityPolicy.validatesDomainName = NO;
//        /*因为与缓存互通 服务器返回的数据 必须是二进制*/
        self.responseSerializer = [AFHTTPResponseSerializer serializer];
        self.operationQueue.maxConcurrentOperationCount = 5;
        self.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/plain",@"text/xml",nil];
    }
    return self;
}

- (void)dealloc {
    [self invalidateSessionCancelingTasks:YES];
}

- (void)sendRequest:(JTURLRequest *)request progress:(JTProgressBlock)progress success:(JTRequestSuccess)success failed:(JTRequestFailed)failed {
    
    if (request.methodType==JTMethodTypePOST) {
        
        [self postRequest:request progress:progress success:success failed:failed];
    }else if (request.methodType==JTMethodTypeUpload){
        
        [self uploadWithRequest:request progress:progress success:success failed:failed];
    }else if (request.methodType==JTMethodTypeDownLoad){
        
        [self downloadWithRequest:request progress:progress success:success failed:failed];
    }else{
        
        [self getRequest:request progress:progress success:success failed:failed];
    }
}

#pragma mark - GET
- (void)getRequest:(JTURLRequest *)request progress:(JTProgressBlock)progress success:(JTRequestSuccess)success failed:(JTRequestFailed)failed{
    NSString * key = [self keyWithParameters:request];
    if ([[JTCacheManager sharedInstance] diskCacheExistsWithKey:key] && request.loadType!= JTRequestTypeRefresh && request.loadType!= JTRequestTypeRefreshMore){
        
        [[JTCacheManager sharedInstance] getCacheDataForKey:key value:^(NSData *data,NSString *filePath) {
            
            id responseObject = [self responseObjectForResponseData:data];
            success ? success(responseObject ,request.loadType) : nil;
        }];
        
    }else{
        [self dataTaskWithGetRequest:request progress:progress success:success failed:failed];
    }
}

- (NSURLSessionDataTask *)dataTaskWithGetRequest:(JTURLRequest *)request progress:(JTProgressBlock)progress success:(JTRequestSuccess)success failed:(JTRequestFailed)failed{
    
    if ([JTRequestOperation shareInstance].networkError == YES) {
        [MBProgressHUD showInfo:@"网络连接断开,请检查网络!"];
        failed ? failed(nil) : nil;
        return nil;
    }
//    [self requestSerializerConfig:request];
    [self headersAndTimeConfig:request];
    
    return  [self dataTaskWithGetURL:request.urlString parameters:request.parameters  progress:progress success:^(id responseObject, JTLoadType type) {
        if (request.isCache) {
            [self storeObject:responseObject request:request];
        }
        
        responseObject = [self responseObjectForResponseData:responseObject];
        if (self.serializationError == nil) {
            success ? success(responseObject,request.loadType) : nil;
        } else {
            failed ? failed(self.serializationError) : nil;
        }
    } failed:failed];
}

- (NSURLSessionDataTask *)dataTaskWithGetURL:(NSString *)urlString parameters:(id)parameters  progress:(JTProgressBlock)progress success:(JTRequestSuccess)success failed:(JTRequestFailed)failed{
    
    if([urlString isEqualToString:@""]||urlString==nil)return nil;
    
    NSURLSessionDataTask *dataTask = nil;
    return dataTask= [self GET:[NSString jt_stringUTF8Encoding:urlString] parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
        progress ? progress(downloadProgress) : nil;
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        JTRLog(@"%@",task.currentRequest);
        success ? success(responseObject,0) : nil;
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        JTRLog(@"%@",task.currentRequest);
        failed ? failed(error) : nil;
    }];
}

// 判断是否已经有缓存了
- (BOOL)isCache:(JTURLRequest *)request {
    
    NSString *key = [self keyWithParameters:request];
    return [[JTCacheManager sharedInstance] diskCacheExistsWithKey:key];
}

#pragma mark - POST
- (void)postRequest:(JTURLRequest *)request  progress:(JTProgressBlock)progress success:(JTRequestSuccess)success failed:(JTRequestFailed)failed {
    NSString * key = [self keyWithParameters:request];
    if ([[JTCacheManager sharedInstance] diskCacheExistsWithKey:key] && request.loadType!= JTRequestTypeRefresh && request.loadType!= JTRequestTypeRefreshMore){
        
        [[JTCacheManager sharedInstance] getCacheDataForKey:key value:^(NSData *data,NSString *filePath) {
            
            id responseObject = [self responseObjectForResponseData:data];
            success ? success(responseObject ,request.loadType) : nil;
        }];
        
    }else{
        [self dataTaskWithPostRequest:request loadType:request.loadType progress:progress success:success failed:failed];
    }
}

- (NSURLSessionDataTask *)dataTaskWithPostRequest:(JTURLRequest *)request loadType:(JTLoadType)type progress:(JTProgressBlock)progress success:(JTRequestSuccess)success failed:(JTRequestFailed)failed {
    if ([JTRequestOperation shareInstance].networkError == YES) {
        [MBProgressHUD showInfo:@"网络连接断开,请检查网络!"];
        failed ? failed(nil) : nil;
        return nil;
    }
    [self headersAndTimeConfig:request];
    if (request.getParam != nil && [request.getParam count] > 0) {
        request.urlString = [NSString jt_urlString:request.urlString appendingParameters:request.getParam];
    }
    
    return  [self dataTaskWithPostURL:request.urlString parameters:request.parameters  progress:progress success:^(id responseObject, JTLoadType type) {
        if (request.isCache) {
            [self storeObject:responseObject request:request];
        }
        responseObject = [self responseObjectForResponseData:responseObject];
        
        if (self.serializationError == nil) {
            success ? success(responseObject,request.loadType) : nil;
        } else {
            failed ? failed(self.serializationError) : nil;
        }
        
    } failed:failed];
}

- (NSURLSessionDataTask *)dataTaskWithPostURL:(NSString *)urlString parameters:(id)parameters  progress:(JTProgressBlock)progress success:(JTRequestSuccess)success failed:(JTRequestFailed)failed{
    
    if([urlString isEqualToString:@""]||urlString==nil)return nil;
    
    NSURLSessionDataTask *dataTask = nil;
    NSString *urlstr = [NSString jt_stringUTF8Encoding:urlString];
    return dataTask=[self POST:urlstr parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
        progress ? progress(uploadProgress) : nil;
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
         JTRLog(@"%@",task.currentRequest);
        success ? success(responseObject,0) : nil;
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         JTRLog(@"%@",task.currentRequest);
        failed ? failed(error) : nil;
    }];
}

#pragma mark - upload
- (NSURLSessionTask *)uploadWithRequest:(JTURLRequest *)request
                               progress:(JTProgressBlock)progress
                                success:(JTRequestSuccess)success
                                 failed:(JTRequestFailed)failed{
    if (request.getParam != nil && [request.getParam count] > 0) {
        request.urlString = [NSString jt_urlString:request.urlString appendingParameters:request.getParam];
    }
    return [self POST:[NSString jt_stringUTF8Encoding:request.urlString] parameters:request.parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        [request.uploadDatas enumerateObjectsUsingBlock:^(JTUploadData *obj, NSUInteger idx, BOOL *stop) {
            if (obj.fileData) {
                if (obj.fileName != nil && obj.mimeType != nil) {
                    [formData appendPartWithFileData:obj.fileData name:obj.name fileName:obj.fileName mimeType:obj.mimeType];
                } else {
                    [formData appendPartWithFormData:obj.fileData name:obj.name];
                }
            } else if (obj.fileURL) {
                
                if (obj.fileName && obj.mimeType) {
                    [formData appendPartWithFileURL:obj.fileURL name:obj.name fileName:obj.fileName mimeType:obj.mimeType error:nil];
                } else {
                    [formData appendPartWithFileURL:obj.fileURL name:obj.name error:nil];
                }
                
            }
        }];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        dispatch_sync(dispatch_get_main_queue(), ^{
            progress ? progress(uploadProgress) : nil;
        });
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
         JTRLog(@"%@",task.currentRequest);
        success ? success(responseObject,0) : nil;
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error){
         JTRLog(@"%@",task.currentRequest);
        failed ? failed(error) : nil;
        
    }];
}

#pragma mark - DownLoad
- (NSURLSessionTask *)downloadWithRequest:(JTURLRequest *)request progress:(JTProgressBlock)progress success:(JTRequestSuccess)success failed:(JTRequestFailed)failed{
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString jt_stringUTF8Encoding:request.urlString]]];
    
    [self headersAndTimeConfig:request];
    
    NSURL *downloadFileSavePath;
    BOOL isDirectory;
    if(![[NSFileManager defaultManager] fileExistsAtPath:request.downloadSavePath isDirectory:&isDirectory]) {
        isDirectory = NO;
    }
    if (isDirectory) {
        NSString *fileName = [urlRequest.URL lastPathComponent];
        downloadFileSavePath = [NSURL fileURLWithPath:[NSString pathWithComponents:@[request.downloadSavePath, fileName]] isDirectory:NO];
    } else {
        downloadFileSavePath = [NSURL fileURLWithPath:request.downloadSavePath isDirectory:NO];
    }
    NSURLSessionDownloadTask *dataTask = [self downloadTaskWithRequest:urlRequest progress:^(NSProgress * _Nonnull downloadProgress) {
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            progress ? progress(downloadProgress) : nil;
        });
        
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        return downloadFileSavePath;
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        failed ? failed(error) : nil;
        success ? success([filePath path],request.loadType) : nil;
    }];
    
    [dataTask resume];
    return dataTask;
}

#pragma mark - 其他配置
- (NSString *)keyWithParameters:(JTURLRequest *)request{
    return [NSString jt_stringUTF8Encoding:[NSString jt_urlString:request.urlString appendingParameters:request.parameters]];
}

- (void)storeObject:(NSObject *)object request:(JTURLRequest *)request{
    NSString * key = [self keyWithParameters:request];
    [[JTCacheManager sharedInstance] storeContent:object forKey:key isSuccess:nil];
}

- (void)requestSerializerConfig:(JTURLRequest *)request{
    self.requestSerializer = request.requestSerializerType==JTHTTPRequestSerializer ? [AFHTTPRequestSerializer serializer] : [AFJSONRequestSerializer serializer];
}

- (void)headersAndTimeConfig:(JTURLRequest *)request{
    self.requestSerializer.timeoutInterval=request.timeoutInterval?request.timeoutInterval:30;
    if ([[request mutableHTTPRequestHeaders] allKeys].count>0) {
        [[request mutableHTTPRequestHeaders] enumerateKeysAndObjectsUsingBlock:^(id field, id value, BOOL * __unused stop) {
            [self.requestSerializer setValue:value forHTTPHeaderField:field];
        }];
    }
}

- (id)responseObjectForResponseData:(id)responseObject {
    NSError *error = nil;
    id res = nil;
    if ([responseObject length] > 0) {
        res = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&error];
    }
#if DEBUG
    if (error != nil) {
        NSString *dataStr;
        dataStr = [[NSMutableString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        if (dataStr == nil) {
            NSStringEncoding gbkEncoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
            dataStr = [[NSMutableString alloc] initWithData:responseObject encoding:gbkEncoding];
        }
        JTRLog(@"%@",dataStr);
    }
#endif
    self.serializationError = error;
    return res;
}

+ (void)startMonitoring
{
    // 1.获得网络监控的管理者
    AFNetworkReachabilityManager *mgr = [AFNetworkReachabilityManager sharedManager];
    // 2.设置网络状态改变后的处理
    [mgr setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        // 当网络状态改变了, 就会调用这个block
        switch (status)
        {
            case AFNetworkReachabilityStatusUnknown: // 未知网络
                JTRLog(@"未知网络");
                
                [JTRequestOperation shareInstance].networkError = NO;
                break;
            case AFNetworkReachabilityStatusNotReachable: // 没有网络(断网)
                [JTRequestOperation shareInstance].networkError = YES;
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN: // 手机自带网络
                JTRLog(@"手机自带网络");
                [JTRequestOperation shareInstance].networkError = NO;
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi: // WIFI
                JTRLog(@"WIFI");
                [JTRequestOperation shareInstance].networkError = NO;
                break;
        }
    }];
    [mgr startMonitoring];
}

- (NSString *)cancelRequest:(NSString *)urlString getParameter:(NSDictionary *)getParam {
    if (self.tasks.count <= 0) {
        return nil;
    }
    NSString *appUrlString = urlString;
    if (getParam != nil) {
        appUrlString = [NSString jt_urlString:urlString appendingParameters:getParam];
    }
    __block NSString *currentUrlString=nil;
    @synchronized (self.tasks) {
        [self.tasks enumerateObjectsUsingBlock:^(NSURLSessionTask *task, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([[[task.currentRequest URL] absoluteString] isEqualToString:[NSString jt_stringUTF8Encoding:appUrlString]] || [[[task.currentRequest URL] absoluteString] containsString:[NSString jt_stringUTF8Encoding:urlString]]) {
                currentUrlString = [[task.currentRequest URL] absoluteString];
                [task cancel];
                *stop = YES;
            }
        }];
    }
    return currentUrlString;
}

@end
