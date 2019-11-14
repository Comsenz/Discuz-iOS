//
//  DZTreeViewNode.h
//  DiscuzMobile
//
//  Created by HB on 16/12/21.
//  Copyright © 2016年 comsenz-service.com.  All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DZForumInfoModel.h"

@interface DZTreeViewNode : NSObject

@property (nonatomic) NSUInteger nodeLevel; // 级别
@property (nonatomic) BOOL isExpanded;  // 展开状态 NO 开始的时候全部收起， YES 开始的时候全部展开；
@property (nonatomic, strong) NSString * nodeName;
@property (nonatomic, strong) NSMutableArray *fids;
@property (nonatomic, strong) DZForumInfoModel *infoModel;

@property (nonatomic, strong) NSMutableArray<DZTreeViewNode *> *nodeChildren;

@property (nonatomic, strong) NSMutableArray *forumListArr;

- (void)setTreeNode:(NSDictionary *)dic;

+ (NSArray *)setAllforumData:(id)responseObject;

+ (NSArray *)setHotData:(id)responseObject;

@end
