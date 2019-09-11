//
//  ThreadListModel.h
//  DiscuzMobile
//
//  Created by HB on 17/1/18.
//  Copyright © 2017年 comsenz-service.com.  All rights reserved.
//

#import <Foundation/Foundation.h>
@class DZAttachment;

@interface ThreadListModel : NSObject

@property (nonatomic, strong) NSString *tid;
@property (nonatomic, strong) NSString *avatar;
@property (nonatomic, strong) NSString *author;
@property (nonatomic, strong) NSString *authorid;
@property (nonatomic, strong) NSString *dateline;
@property (nonatomic, strong) NSString *subject; // 标题
@property (nonatomic, strong) NSString *message; // 内容
@property (nonatomic, strong) NSString *replies; // 回复数
@property (nonatomic, strong) NSString *views;   // 查看数
@property (nonatomic, strong) NSString *price;
@property (nonatomic, strong) NSString *recommend;  // 1 点赞过了
@property (nonatomic, strong) NSString *recommend_add; // 点赞数
@property (nonatomic, strong) NSString *fid;
@property (nonatomic, strong) NSString *digest;
@property (nonatomic, strong) NSString *attachment;
@property (nonatomic, strong) NSMutableArray<DZAttachment*> *attachlist;
@property (nonatomic, strong) NSString *special; //判断帖子类型 0普通 1投票 2商品  3悬赏 4活动 5辩论
@property (nonatomic, assign) BOOL isRecently;
@property (nonatomic, strong) NSString *typeId;
@property (nonatomic, strong) NSDictionary *forumnames;
@property (nonatomic, strong) NSString *displayorder; // 判断是不是置顶帖子  displayorder  3，2，1 置顶 全局置顶3  分类置顶2  本版置顶1  0 正常  -1 回收站  -2 审核中  -3 审核忽略  -4草稿

// 我自己处理过的标题，接口里面没有
@property (nonatomic, strong) NSMutableArray *imglist;
@property (nonatomic, strong) NSString *useSubject;
@property (nonatomic, strong) NSString *grouptitle;
@property (nonatomic, strong) NSString *typeName;

// 展示形式是否要依照特殊帖子的判断。
- (BOOL)isSpecialThread;
// 置顶帖判断
- (BOOL)isTopThread;

// 分类
+ (NSDictionary *)getTypeDic:(id)responseObject;
// 用户组
+ (NSDictionary *)getGroupDic:(id)responseObject;

@end
