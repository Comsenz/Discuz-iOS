//
//  URLStrings.m
//  DiscuzMobile
//
//  Created by ZhangJitao on 2018/2/2.
//  Copyright © 2018年 comsenz-service.com.  All rights reserved.
//

#import "URLStrings.h"

NSString * const url_Check =  @"?version=5&module=check";

#pragma mark - 发现
// 推荐 banner
NSString * const url_RecommendBanner = @"?module=iwechat&data=json&version=5";
// 推荐 列表
NSString * const url_RecommendList = @"?module=recommon_thread&version=5&mapifrom=ios";
// 所有热帖
NSString * const url_HotAll = @"?module=digestthread&version=5";

// 精华
NSString * const url_DigestAll = @"?module=forumguide&view=digest&version=5";
// 最新
NSString * const url_newAll = @"?module=forumguide&view=newthread&version=5";

#pragma mark - 版块
// 全部
NSString * const url_Forumindex = @"?module=forumindex&version=5";
// 热门
NSString * const url_Hotforum = @"?module=hotforum&version=5";
// 板块下级，帖子列表  threadmodcount = 2 有2条待审核帖子  description:描述
NSString * const url_ForumTlist = @"?version=5&module=forumdisplay&submodule=checkpost";

#pragma mark - 帖子详情
// 帖子详情
NSString * const url_ThreadDetail = @"?module=viewthread&submodule=checkpost&version=5&ppp=10";
// 帖子回帖
NSString * const url_Sendreply = @"?version=5&module=sendreply&replysubmit=yes&mapifrom=ios";
// 点赞
NSString * const url_Praise =  @"?version=4&module=recommend";
// 引用回复内容
NSString * const url_ReplyContent = @"?module=sendreply&version=3";
// 举报
NSString * const url_Report = @"?module=report&version=5";
// 删除帖子 GET传tid 和pid messageval = delete_success 删除成功
NSString * const url_deleteThread =  @"?module=viewthread&delete=1&version=5";

#pragma mark - 个人中心
// 个人资料  post （自己的，啥参数不传）  get（他人的，传参）
NSString * const url_UserInfo = @"?module=profile&version=5&loginsubmit=yes";
// 收藏的帖子
NSString * const url_FavoriteThread = @"?module=myfavthread&version=5";
// 收藏的板块
NSString * const url_FavoriteForum = @"?module=myfavforum&version=5";
// 我的帖子
NSString * const url_Mythread = @"?module=mythread&version=4";
// 他人的帖子
NSString * const url_OtherThread =@"?module=userthread&version=5";
// 用户回复，根据参数，可以是我的，也可以是他人的
NSString * const url_UserPost = @"?module=userpost&version=5";
// 好友列表
NSString * const url_FriendList = @"?module=friend&version=5";
// 添加好友
NSString * const url_AddFriend = @"?version=5&module=addfriend";
// 传头像
NSString * const url_UploadHead =@"?module=uploadavatar&version=2";

#pragma mark - 登录相关
// 普通登录 post
NSString * const url_Login = @"?module=login&version=5";
// 获取授权绑定信息
NSString * const url_oauths = @"?module=oauths&version=5";
// 解绑
NSString * const url_unBindThird =  @"?module=oauths&op=unbind&version=5";

NSString * const url_resetPwd = @"?module=edit_password&version=5";


#pragma mark - 注册相关
// 注册
NSString * const url_Register =  @"?module=register&version=5";

#pragma mark - 消息
// 回复短消息 post
NSString * const url_Sendpm = @"?module=sendpm&pmsubmit=yes&version=5&mapifrom=ios";
// 查看某个短消息(mypm : subop=view) 详情页
NSString * const url_MessageDetail = @"?module=mypm&subop=view&version=5&checkavatar=1&mapifrom=ios&smiley=no&convimg=1";
// 删除详情页里的一条消息
NSString * const url_DeleteOneMessage = @"?version=5&module=delpmview&deletesubmit=1";
// 删除与一个人的私信
NSString * const url_DeleteMessage = @"?module=delpm&version=5&deletesubmit=1&mapifrom=ios";
// 我的消息 私人消息 filter=privatepm  公共消息 filter=announcepm
NSString * const url_MsgList = @"?module=mypm&version=5&mapifrom=ios";
// 我的帖子 帖子  点评 活动 悬赏 商品 提到我的 type不同
NSString * const url_ThreadMsgList = @"?module=mynotelist&view=mypost&version=3&mapifrom=ios";
// 坛友互动 打招呼  好友 留言 评论 挺你 分享 type不同
NSString * const url_InteractiveMsgList = @"?module=mynotelist&view=interactive&version=3&mapifrom=ios";
// 系统提醒 管理工作 view不同
NSString * const url_SystemMsgList = @"?module=mynotelist&version=3&mapifrom=ios";

#pragma mark - 收藏
// 板块收藏
NSString * const url_CollectionForum = @"?module=favforum&version=4";
// 帖子收藏
NSString * const url_CollectionThread = @"?module=favthread&favoritesubmit=true&version=4";
// 取消收藏
NSString * const url_unCollection = @"?module=favorite&version=5&op=delete";

#pragma mark - 发帖相关
// 检查发帖权限  新接口version=5 可判断能发的帖子类型
NSString * const url_CheckPostAuth = @"?module=newthread&submodule=checkpost&version=5";
// 发帖
NSString * const url_PostCommonThread = @"?version=5&module=newthread&topicsubmit=yes&mapifrom=ios";
// 发投票帖
NSString * const url_PostVoteThread = @"?version=5&module=newpoll&topicsubmit=yes";
// 发活动帖
NSString * const url_PostActivityThread = @"?version=5&module=newactivity&topicsubmit=yes";
// 上传图片 / 附件
NSString * const url_upload = @"?version=5&module=forumupload&simple=1";

#pragma mark - 活动帖相关
// 字段不同，分为 管理活动的列表 审核活动报名
NSString * const url_ManageActivity = @"?module=forummisc&action=activityapplylist&version=5";
// 参加活动或取消
NSString * const url_ActivityApplies = @"?version=5&module=activityapplies";

#pragma mark - 投票帖相关
// 查看参与投票人 每项几个人  （是哪几个人type=poll）
//NSString * const url_VoteOptionDetail = @"?version=5&module=viewpollpotion";
NSString * const url_VoteOptionDetail = @"?module=forummisc&action=viewvote&version=5";
// 参与投票
NSString * const url_Pollvote = @"?module=pollvote&version=1&pollsubmit=yes";

#pragma mark - 验证码
// 验证码图片地址 三种类型  注册 登录 发帖回帖
NSString * const url_secureCode = @"?module=secure&version=5";

// 搜索 subject=%@
NSString * const url_Search = @"?module=search&version=5";
