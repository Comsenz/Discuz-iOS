//
//  TreeViewNode.m
//  DiscuzMobile
//
//  Created by HB on 16/12/21.
//  Copyright © 2016年 comsenz-service.com.  All rights reserved.
//

#import "TreeViewNode.h"
#import "ForumInfoModel.h"

@interface TreeViewNode()

@end

@implementation TreeViewNode

#pragma mark - 设置单一节点section
- (void)setTreeNode:(NSDictionary *)dic {
    
    self.nodeName = [dic objectForKey:@"name"];
    self.infoModel.name = [dic objectForKey:@"name"];
    if ([dic objectForKey:@"isExpanded"]) {
        self.isExpanded = NO;
    } else {
        self.isExpanded = YES;
    }
    if ([DataCheck isValidString:[dic objectForKey:@"level"]]) { // 全部版块
        if ([[dic objectForKey:@"level"] isEqualToString:@"0"]) {
            self.nodeLevel = 0;
        } else {
            self.nodeLevel = [[dic objectForKey:@"level"] integerValue];
        }
    } else { // 热门版块
        [self.infoModel setValuesForKeysWithDictionary:dic];
        self.nodeLevel = 1;
    }

    self.fids = [dic objectForKey:@"forums"];
    self.forumListArr = [dic objectForKey:@"forumlist"];
    NSMutableArray *childArr = [NSMutableArray array];
    for (NSString *fid in self.fids) {
        NSDictionary *fourmInfo = [self getForumInfoWithFid:fid];
        TreeViewNode *treeNode1 = [[TreeViewNode alloc] init];
        treeNode1.nodeLevel = 1;
        treeNode1.isExpanded = NO;
        treeNode1.nodeName = [fourmInfo objectForKey:@"name"];
        [treeNode1.infoModel setValuesForKeysWithDictionary:fourmInfo];
        
        [treeNode1 sublistNode:fourmInfo];
        
        [childArr addObject:treeNode1];
    }
    self.nodeChildren = childArr;
}


#pragma mark - 递归获取某版块下的所有子版块row
- (void)sublistNode:(NSDictionary *)fourmInfo {
    if ([DataCheck isValidDictionary:fourmInfo]) {
        if ([DataCheck isValidArray:[fourmInfo objectForKey:@"sublist"]]) {
            NSArray *subArr = [fourmInfo objectForKey:@"sublist"];
            
            for (NSDictionary *info in subArr) {
                TreeViewNode *treeNode = [[TreeViewNode alloc] init];
                treeNode.nodeLevel = self.nodeLevel + 1;
                treeNode.isExpanded = NO;
                treeNode.nodeName = [info objectForKey:@"name"];
                [treeNode.infoModel setValuesForKeysWithDictionary:info];
                [self.nodeChildren addObject:treeNode];
                if ([DataCheck isValidArray:[info objectForKey:@"sublist"]]) { // 递归判断
                    [treeNode sublistNode:info];
                }
            }
        }
        
        
    }
}

- (NSDictionary *)getForumInfoWithFid:(NSString *)fid {
    
    for (NSDictionary *info in self.forumListArr) {
        if ([fid isEqualToString:[info objectForKey:@"fid"]]) {
            return info;
        }
    }
    return nil;
}

+ (NSArray *)setAllforumData:(id)responseObject { // 设置全部版块  有主导航
    NSMutableArray *forumArray = [NSMutableArray array];
    NSArray *catlist = [[responseObject objectForKey:@"Variables"] objectForKey:@"catlist"];
    NSArray *forumlist = [[responseObject objectForKey:@"Variables"] objectForKey:@"forumlist"];
    if ([DataCheck isValidArray:forumlist]) {
        for (int i = 0; i < catlist.count; i++) {
            TreeViewNode * treeNode = [[TreeViewNode alloc] init];
            NSMutableDictionary *nodeDic = [NSMutableDictionary dictionary];
            nodeDic = [catlist[i] mutableCopy];
            [nodeDic setValue:forumlist forKey:@"forumlist"];
            [nodeDic setValue:@"0" forKey:@"level"];
            if (catlist.count >= 10) {
                [nodeDic setValue:@"NO" forKey:@"isExpanded"];
            }
            [treeNode setTreeNode:nodeDic];
            [forumArray addObject:treeNode];
        } 
    }
    return forumArray;
    
}

#pragma mark - hot
+ (NSArray *)setHotData:(id)responseObject { // 热门全部版块  无主导航
    NSMutableArray *hotArr = [NSMutableArray array];
    NSArray *dataArr = [[responseObject objectForKey:@"Variables"] objectForKey:@"data"];
    if ([DataCheck isValidArray:dataArr]) {
        for (int i = 0; i < dataArr.count; i++)  {
            TreeViewNode * treeNode = [[TreeViewNode alloc] init];
            NSMutableDictionary *nodeDic = [NSMutableDictionary dictionary];
            nodeDic = [dataArr[i] mutableCopy];
            [treeNode setTreeNode:nodeDic];
            [hotArr addObject:treeNode];
        }
    }
    return hotArr;
}

#pragma mark - setter、getter
- (void)setNodeName:(NSString *)nodeName {
    if ([DataCheck isValidString:nodeName]) {
        nodeName = [[nodeName transformationStr] flattenHTMLTrimWhiteSpace:YES];
    }
    _nodeName = nodeName;
}

- (NSMutableArray *)fids {
    if (!_fids) {
        _fids = [NSMutableArray array];
    }
    return _fids;
}
- (NSMutableArray *)nodeChildren {
    if (!_nodeChildren) {
        _nodeChildren = [NSMutableArray array];
    }
    return _nodeChildren;
}

- (NSMutableArray *)forumListArr {
    if (!_forumListArr) {
        _forumListArr = [NSMutableArray array];
    }
    return _forumListArr;
}

- (ForumInfoModel *)infoModel {
    if (!_infoModel) {
        self.infoModel = [[ForumInfoModel alloc] init];
    }
    return _infoModel;
}

@end
