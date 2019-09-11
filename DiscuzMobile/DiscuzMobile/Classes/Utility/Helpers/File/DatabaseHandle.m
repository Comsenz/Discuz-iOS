//
//  DatabaseHandle.m
//  DiscuzMobile
//
//  Created by HB on 2017/5/19.
//  Copyright © 2017年 comsenz-service.com.  All rights reserved.
//

#import "DatabaseHandle.h"
#import "MyPerson.h"
#import "ThreadListModel.h"

#define FootThread @"footThread"

static FMDatabase *_db;

@implementation DatabaseHandle

+ (instancetype)defaultDataHelper {
    
    static DatabaseHandle *helper = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        helper = [[DatabaseHandle alloc] init];
    });
    
    return helper;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        [self openDB];
        
    }
    return self;
}

// 打开数据库
- (void)openDB {
    
    // 拼接数据库存储地址
    NSString *dataPath = [[FileManager shareInstance] databaseFilePath:@"DiscuzMobile.sqlite"];
    _db = [FMDatabase databaseWithPath:dataPath];
    DLog(@"%@",dataPath);
    if ([_db open]) {
        // 创建用户表
        NSString *sqlStr = @"create table if not exists t_person (uid text, uname text)";
        // 创建足迹
        NSString *sqlStr1 = @"create table if not exists t_foot (tid text,uid text, aData blob)";

        [_db executeUpdate:sqlStr];
        [_db executeUpdate:sqlStr1];
        
    }
}

- (void)closeDB {
    [_db close];
}

// 获取数据库中的所有用户
- (NSArray *)getAllPerson {
    
    
    NSString *sqlStr = @"select * from t_person";
    
    FMResultSet *resultSet = [_db executeQuery:sqlStr];
    
    NSMutableArray *dataArray = [NSMutableArray array];
    
    while (resultSet.next) {
        
        MyPerson *person = [[MyPerson alloc] init];
        
        person.uid = [resultSet stringForColumn:@"uid"];
        person.uname = [resultSet stringForColumn:@"uname"];
        [dataArray addObject:person];
    }
    
    return dataArray;
}

// 查询用户单个
- (MyPerson *)searchPerson:(NSString *)uid {
    
    NSString *sqlStr = @"select * from t_person where uid = ?";
    
    FMResultSet *resultSet = [_db executeQuery:sqlStr,uid];
    
    MyPerson *person = [[MyPerson alloc] init];
    
    while (resultSet.next) {
        
        person.uid = [resultSet stringForColumn:@"uid"];
        person.uname = [resultSet stringForColumn:@"uname"];
        
    }
    
    return person;
    
}

// 删除用户
- (void)removePerson:(NSString *)uid {
    
    NSString *sqlStr = @"delete from t_person where uid = ?";
    
    [_db executeUpdate:sqlStr,uid];
    
}


/**
 * 存储足迹的帖子
 */
- (void)footThread:(ThreadListModel *)thread {
    
    if ([self isFoot:thread.tid]) { // 如果数据库中有记录，移除旧的记录
        [self removeFootThreadWithtid:thread.tid];
    }
    
    [self saveThread:thread];
}

// 存储帖子
- (void)saveThread:(ThreadListModel *)thread {
    NSData *data = [ArchieverTool Archiever:thread forKey:FootThread];
    NSString *sqlStr = @"insert into t_foot (tid,uid,aData) values (?,?,?)";
    [_db executeUpdate:sqlStr,thread.tid,[Environment sharedEnvironment].member_uid,data];
    NSLog(@"%@",_db.lastError);
}

/**
 * 查询足迹的一个帖子
 */
- (ThreadListModel *)searchFootThreadTid:(NSString *)tid {
    
    NSString *uid = [Environment sharedEnvironment].member_uid;
    NSString *sqlStr;
    FMResultSet *resultSet;
    
    if (uid == nil) {
        sqlStr = @"select aData from t_foot where tid = ?";
        resultSet = [_db executeQuery:sqlStr,tid];
    } else {
        sqlStr = @"select aData from t_foot where tid = ? and uid = ?";
        resultSet = [_db executeQuery:sqlStr,tid,uid];
    }
    
    ThreadListModel *listModel = [[ThreadListModel alloc] init];
    
    while (resultSet.next) {
        
        NSData *data = [resultSet dataForColumn:@"aData"];
        listModel = [ArchieverTool UnArchiever:data forKey:FootThread];
        
    }
    
    return listModel;
    
}

/**
 * 查询某用户所有足迹
 */
- (NSArray *)searchFootWithUid:(NSString *)uid {
//    select *from t_foot limit 1,5;
    NSString *sqlStr = @"select * from t_foot where uid = ?";
    FMResultSet *resultSet = [_db executeQuery:sqlStr,uid];;
//    if (uid == nil) {
//        sqlStr = @"select * from t_foot";
//        resultSet = [_db executeQuery:sqlStr];
//    } else {
//        sqlStr = @"select * from t_foot where uid = ?";
//        resultSet = [_db executeQuery:sqlStr,uid];
//    }
    NSMutableArray *dataArray = [NSMutableArray array];
    
    while (resultSet.next) {
        NSData *data = [resultSet dataForColumn:@"aData"];
        ThreadListModel *listModel = [ArchieverTool UnArchiever:data forKey:FootThread];
        listModel.isRecently = YES;
        [dataArray addObject:listModel];
    }
    dataArray = [dataArray reverseObjectEnumerator].allObjects.mutableCopy;
    return dataArray;
    
}


/**
 查询t_foot表中的数据数量

 @param uid 用户id
 @return 数据条数
 */
- (NSInteger)countForFootUid:(NSString *)uid {
    NSString *sqlStr = @"select count(1) from t_foot where uid = ?";
    return [_db intForQuery:sqlStr,uid];
}

/**
 * 按页数查询某用户足迹
 */
- (NSArray *)searchFootWithUid:(NSString *)uid andPage:(NSInteger)page andPerpage:(NSInteger)perPage {
    NSInteger start = (page-1) * perPage;
    NSInteger count = [self countForFootUid:uid];
    if (perPage >= count) {
        perPage = count;
    }
    NSString *sqlStr = [NSString stringWithFormat:@"select * from t_foot where uid = %@ order by rowid desc limit %ld,%ld",uid,start,perPage];
    
    FMResultSet *resultSet = [_db executeQuery:sqlStr];
    NSMutableArray *dataArray = [NSMutableArray array];
    while (resultSet.next) {
        NSData *data = [resultSet dataForColumn:@"aData"];
        ThreadListModel *listModel = [ArchieverTool UnArchiever:data forKey:FootThread];
        listModel.isRecently = YES;
        [dataArray addObject:listModel];
    }
    return dataArray;
    
}

/**
 * 删除某条足迹
 */
- (void)removeFootThreadWithtid:(NSString *)tid {
    NSString *sqlStr = @"delete from t_foot where tid = ? and uid = ?";
    
    [_db executeUpdate:sqlStr,tid,[Environment sharedEnvironment].member_uid];
}

/**
 * 删除该用户所有足迹
 */
- (void)removeAllFootThread:(NSString *)uid {
    
    NSString *sqlStr = @"delete from t_foot where uid = ?";
    [_db executeUpdate:sqlStr,uid];
}

/**
 * 判断是否足迹过
 */
- (BOOL)isFoot:(NSString *)tid {
    
    ThreadListModel *model = [self searchFootThreadTid:tid];
    
    if (model.tid == nil) {
        
        return NO;
    }
    
    return YES;
}

@end
