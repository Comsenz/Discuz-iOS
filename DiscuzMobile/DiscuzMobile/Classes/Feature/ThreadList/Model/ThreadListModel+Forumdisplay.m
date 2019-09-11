//
//  ThreadListModel+Forumdisplay.m
//  DiscuzMobile
//
//  Created by ZhangJitao on 2019/7/31.
//  Copyright © 2019 comsenz-service.com.  All rights reserved.
//

#import "ThreadListModel+Forumdisplay.h"

@implementation ThreadListModel (Forumdisplay)
/**
 处理接口传进来的responseObject
 
 @param responseObject 接口请求数据
 @param fid 本版fid
 @param page 页数
 @param handle block回调传参  topArr：置顶帖数组 commonArr：普通帖子数组 allArr：全部帖子  notFourmCount：非本版帖子数
 */
+ (void)setThreadData:(id)responseObject andFid:(NSString *)fid andPage:(NSInteger)page handle:(void (^)(NSArray *topArr, NSArray *commonArr, NSArray *allArr, NSInteger notFourmCount))handle {
    
    NSMutableArray *topArray = [NSMutableArray array];
    NSMutableArray *commonArray = [NSMutableArray array];
    NSMutableArray *allArray = [NSMutableArray array];
    
    NSDictionary *gropDic =  [self getGroupDic:responseObject];
    NSDictionary *typeDic = [self getTypeDic:responseObject];
    
    NSInteger notThisFidCount = 0;
    NSArray *data = [[responseObject objectForKey:@"Variables"] objectForKey:@"forum_threadlist"];
    if ([DataCheck isValidArray:data]) {
        for (NSDictionary * dic in data) {
            
            ThreadListModel *listModel = [ThreadListModel dealGetSingleModel:dic
                                                                     andPage:page
                                                                    andGroup:gropDic
                                                                     andType:typeDic];
            [allArray addObject:listModel];
            
            if (page == 1) {
                
                if ([@[@"3",@"2"] containsObject:listModel.displayorder] && ![listModel.fid isEqualToString:fid]) { // 非本版帖子
                    notThisFidCount ++;
                }
                
                if ([listModel isTopThread]) { // 全局置顶3  分类置顶2  本版置顶1
                    [topArray addObject:listModel];
                } else {
                    [commonArray addObject:listModel];
                }
            } else {
                
                [commonArray addObject:listModel];
            }
            
        }
    }
    handle?handle(topArray,commonArray,allArray,notThisFidCount):nil;
}


/**
 根据帖子类型设置描述
 
 @param dic 帖子dic
 @param page 页数
 @param groupDic 所在群组
 @param typeDic 帖子类型 投票、活动等
 @return 帖子model
 */
+ (ThreadListModel *)dealGetSingleModel:(NSDictionary *)dic andPage:(NSInteger)page andGroup:(NSDictionary *)groupDic andType:(NSDictionary *)typeDic {
    
//    ThreadListModel *listModel = [[ThreadListModel alloc] init];
//    [listModel setValuesForKeysWithDictionary:dic];
    ThreadListModel *listModel = [ThreadListModel mj_objectWithKeyValues:dic];
    if ([DataCheck isValidDictionary:groupDic]) {
        listModel.grouptitle = [groupDic objectForKey:listModel.authorid];
    }
    
    if ([DataCheck isValidDictionary:typeDic]) {
        if ([DataCheck isValidString:[typeDic objectForKey:listModel.typeId]]) {
            NSString *typeName = [typeDic objectForKey:listModel.typeId];
            listModel.typeName = typeName;
        }
    }
    
    if ([listModel isTopThread] && page == 1) {
        if ([DataCheck isValidString:listModel.typeName]) {
            listModel.useSubject = [NSString stringWithFormat:@"%@,%@",listModel.typeName,listModel.subject];
        }
    } else {
        listModel = [listModel dealSpecialThread];
    }
    
    return listModel;
}

- (ThreadListModel *)dealSpecialThread {
    NSString *spaceCharater = @"    ";
    if ([self isSpecialThread]) {
        if ([DataCheck isValidString:self.typeName]) {
            self.useSubject = [NSString stringWithFormat:@"%@[%@]%@",spaceCharater,self.typeName,self.subject];
        } else {
            self.useSubject = [NSString stringWithFormat:@"%@%@",spaceCharater,self.subject];
        }
    } else {
        if ([DataCheck isValidString:self.typeName]) {
            self.useSubject = [NSString stringWithFormat:@"[%@]%@",self.typeName,self.subject];
        }
    }
    return self;
}

@end
