//
//  FileManager.h
//  DiscuzMobile
//
//  Created by HB on 16/9/24.
//  Copyright © 2016年 Cjk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileManager : NSObject
+ (nonnull instancetype)shareInstance;

/**
 *  删除文件
 */
- (BOOL)DeleteSingleFile:(NSString *)filePath;

// 数据库存储路径
- (NSString *_Nonnull)databaseFilePath:(NSString *_Nonnull)databaseName;

/** 计算cache文件大小 */
- (CGFloat)filePathSize;


/**
 * 写入Cache plist 文件
 * dataDic NSDictionary  存储的数据
 * fileName  NSString  文件名
 */

- (void)writePlist:(nonnull id)dataDic fileName:(nonnull NSString*)fileName;

/**
 * 读取Cache plist 文件
 @ fileName  NSString  文件名
 *
 */

- (nonnull NSDictionary*)readPlist:(nonnull NSString*)fileName;

/**
 * 写入Document plist 文件
 * dataDic NSDictionary  存储的数据
 * fileName  NSString  文件名
 */
- (void)writeDocumentPlist:(nonnull id)dataDic fileName:(nonnull NSString *)fileName;
/**
 * 读取Document plist 文件
 @ fileName  NSString  文件名
 *
 */
- (nonnull NSDictionary *)readDocumentPlist:(nonnull NSString *)fileName;

/**
 * 返回Document 目录
 * fileName  NSString  文件名
 */
- (nonnull NSString *)pathFilename:(nonnull NSString*)fileName;

- (void)manageCacheBackThread:(void(^_Nullable)(void))backThread afterMainThread:(void(^_Nullable)(void))mainThread;

/**
 * 移除文件共有方法
 */
- (void)removeFileWithPath:(NSString *_Nullable)path;

@end
