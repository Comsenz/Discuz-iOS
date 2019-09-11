//
//  FileManager.m
//  DiscuzMobile
//
//  Created by HB on 16/9/24.
//  Copyright © 2016年 Cjk. All rights reserved.
//

#import "FileManager.h"

@implementation FileManager

+ (instancetype)shareInstance {
    static FileManager *helper = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        helper = [[FileManager alloc] init];
    });
    return helper;
}

/**
 *  删除文件
 */
- (BOOL)DeleteSingleFile:(NSString *)filePath{
    NSError *err = nil;
    
    if (nil == filePath) {
        return NO;
    }
    
    NSFileManager *appFileManager = [NSFileManager defaultManager];
    
    if (![appFileManager fileExistsAtPath:filePath]) {
        return YES;
    }
    
    if (![appFileManager isDeletableFileAtPath:filePath]) {
        return NO;
    }
    
    return [appFileManager removeItemAtPath:filePath error:&err];
}


// 数据库存储路径
- (NSString *_Nonnull)databaseFilePath:(NSString *_Nonnull)databaseName {
    return [self cacheFilename:databaseName];
}

- (NSString *)getFilename:(NSString *)name andIndex:(NSString *)index {
    NSString *fileName = name;
    if (index != nil) {
        fileName = [fileName stringByAppendingString:index];
    }
    return fileName;
}

- (CGFloat)filePathSize {
    
    NSString *path = [JTCacheManager sharedInstance].JTKitPath;
    NSArray *chileFile = [[NSFileManager defaultManager] subpathsAtPath:path];
    float folderSize = 0;
    for (NSString *chile in chileFile) {
        NSString *chilePath = [path stringByAppendingPathComponent:chile];
        folderSize += [self fileSiezeAtPath:chilePath];
    }
    if (folderSize <= 0.013) {
        folderSize = 0.00;
    }
    return folderSize;
}

- (float)fileSiezeAtPath:(NSString *)filePath {
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        long long fileSize = [[[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil] fileSize];
        return fileSize / 1024.0 / 1024.0;
    }
    return 0;
}

- (void)manageCacheBackThread:(void(^)(void))backThread afterMainThread:(void(^)(void))mainThread {
    BACK(^{
        backThread();
        MAIN(^{
            mainThread();
        });
    });
}

/**
 * 写入plist 文件Cache
 @ dataDic NSDictionary  存储的数据
 @ fileName  NSString  文件名
 //文件存储
 */

- (void)writePlist:(id)dataDic fileName:(NSString*)fileName{
    
    
    NSString *plistPath = [self cacheFilename:[NSString stringWithFormat:@"%@.plist",fileName]];
    
    [self writeToFile:dataDic andPath:plistPath];
}
/**
 * 读取Cache plist 文件
 @ fileName  NSString  文件名
 *
 */

- (id)readPlist:(NSString*)fileName{
    
    NSString *filenamePath = [self cacheFilename:[NSString stringWithFormat:@"%@.plist",fileName]];
    NSData * data1=[NSData dataWithContentsOfFile:filenamePath];
    NSDictionary *data=[ NSKeyedUnarchiver unarchiveObjectWithData:data1];
    
    //    NSLog(@"%@data",data);
    return data;
}


/**
 * 写入plist 文件Document
 @ dataDic NSDictionary  存储的数据
 @ fileName  NSString  文件名
 //文件存储
 */
- (void)writeDocumentPlist:(id)dataDic fileName:(NSString *)fileName {
    NSString *plistPath = [self pathFilename:[NSString stringWithFormat:@"%@.plist",fileName]];
    [self writeToFile:dataDic andPath:plistPath];
    
}
/**
 * 读取Document plist 文件
 @ fileName  NSString  文件名
 *
 */
- (NSDictionary *)readDocumentPlist:(NSString *)fileName {
    NSString *plistPath = [self pathFilename:[NSString stringWithFormat:@"%@.plist",fileName]];
    NSData * data1=[NSData dataWithContentsOfFile:plistPath];
    NSDictionary *data=[NSKeyedUnarchiver unarchiveObjectWithData:data1];
    
    return data;
}

/**
 * 返回Cache 目录
 @fileName  NSString  文件名
 */
- (NSString *)cacheFilename:(NSString*)fileName{
    NSString *filename = [[JTCacheManager sharedInstance].JTKitPath stringByAppendingPathComponent:fileName];
    return filename;
}
/**
 * 返回Document 目录
 @fileName  NSString  文件名
 */
- (NSString *)pathFilename:(NSString*)fileName{
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *path=[paths objectAtIndex:0];
    NSString *filename=[path stringByAppendingPathComponent:fileName];
    return filename;
}

/**
 * 写入文件共有方法
 */
- (void)writeToFile:(id)dataObj andPath:(NSString *)path{
    NSFileManager *fm = [NSFileManager defaultManager];
    NSDictionary *contentDic = [NSDictionary dictionaryWithContentsOfFile:path];
    if (contentDic == nil) {
        [fm createFileAtPath:path contents:nil attributes:nil];
    }
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:dataObj];
    BOOL success = [data writeToFile:path atomically:YES];
    if (success) {
        NSLog(@"成功写入p");
    }
    if (![fm fileExistsAtPath:path]) {
        NSLog(@"不存在文件");
    }
}

/**
 * 移除文件共有方法
 */
- (void)removeFileWithPath:(NSString *)path {
    NSFileManager *fm = [NSFileManager defaultManager];
    if ([fm fileExistsAtPath:path]) {
        [fm removeItemAtPath:path error:nil];
    }
}

@end
