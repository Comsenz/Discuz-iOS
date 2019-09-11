//
//  URLStrings.h
//  DiscuzMobile
//
//  Created by ZhangJitao on 2018/2/2.
//  Copyright © 2018年 comsenz-service.com.  All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const url_Check;
#pragma mark - 发现
// 推荐 banner
extern NSString * const url_RecommendBanner;
// 推荐 列表
extern NSString * const url_RecommendList;
// 精华
extern NSString * const url_DigestAll;
// 所有热帖
extern NSString * const url_HotAll;
// 所有最新
extern NSString * const url_newAll;
// 删除帖子 GET传tid 和pid messageval = delete_success 删除成功
extern NSString * const url_deleteThread;

#pragma mark - 版块

// 全部
extern NSString * const url_Forumindex;
// 热门
extern NSString * const url_Hotforum;

// 板块下级，帖子列表
extern NSString * const url_ForumTlist;

#pragma mark - 帖子详情
// 帖子详情
extern NSString * const url_ThreadDetail;
// 帖子回帖
extern NSString * const url_Sendreply;
// 点赞
extern NSString * const url_Praise;

// 引用回复内容
extern NSString * const url_ReplyContent;
// 举报
extern NSString * const url_Report;

#pragma mark - 个人
// 个人资料
extern NSString * const url_UserInfo;
// 收藏的帖子
extern NSString * const url_FavoriteThread;
// 收藏的板块
extern NSString * const url_FavoriteForum;
// 我的帖子
extern NSString * const url_Mythread;
// 他人的帖子
extern NSString * const url_OtherThread;
// 用户回复，根据参数，可以是我的，也可以是他人的
extern NSString * const url_UserPost;
// 好友列表
extern NSString * const url_FriendList;
// 添加好友
extern NSString * const url_AddFriend;
// 传头像
extern NSString * const url_UploadHead;

#pragma mark - 登录相关
// 普通登录
extern NSString * const url_Login;
// 获取授权绑定信息
extern NSString * const url_oauths;
// 解绑
extern NSString * const url_unBindThird;
// 修改密码
extern NSString * const url_resetPwd;

#pragma mark - 注册相关
// 注册 + 第三方登录去注册绑定方法
extern NSString * const url_Register;

#pragma mark - 消息
// 回复短消息 post
extern NSString * const url_Sendpm;
// 查看某个短消息(mypm : subop=view) 详情页
extern NSString * const url_MessageDetail;
// 删除详情页里的一条消息
extern NSString * const url_DeleteOneMessage;
// 删除与一个人的私信
extern NSString * const url_DeleteMessage;
// 我的消息 私人消息 filter=privatepm  公共消息 filter=announcepm
extern NSString * const url_MsgList;
// 我的帖子 帖子  点评 活动 悬赏 商品 提到我的 type不同
extern NSString * const url_ThreadMsgList;
// 坛友互动 打招呼  好友 留言 评论 挺你 分享 type不同
extern NSString * const url_InteractiveMsgList;
// 系统提醒 管理工作 view不同
extern NSString * const url_SystemMsgList;

#pragma mark - 收藏
// 板块收藏
extern NSString * const url_CollectionForum;
// 帖子收藏
extern NSString * const url_CollectionThread;
// 取消收藏
extern NSString * const url_unCollection;

#pragma mark - 发帖相关
// 检查发帖权限
extern NSString * const url_CheckPostAuth;
// 发帖 普通帖
extern NSString * const url_PostCommonThread;
// 发投票帖
extern NSString * const url_PostVoteThread;
// 发活动帖
extern NSString * const url_PostActivityThread;
// 上传图片 / 附件
extern NSString * const url_upload;

#pragma mark - 活动帖相关
// 字段不同，分为 管理活动的列表 审核活动报名
extern NSString * const url_ManageActivity;
// 参加活动或取消
extern NSString * const url_ActivityApplies;

#pragma mark - 投票帖相关
// 查看参与投票人 每项几个人  （是哪几个人type=poll）
extern NSString * const url_VoteOptionDetail;
// 参与投票
extern NSString * const url_Pollvote;

#pragma mark - 验证码
// 验证码图片地址 三种类型  注册 登录 发帖回帖
extern NSString * const url_secureCode;

// 搜索 subject=%@
extern NSString * const url_Search;
