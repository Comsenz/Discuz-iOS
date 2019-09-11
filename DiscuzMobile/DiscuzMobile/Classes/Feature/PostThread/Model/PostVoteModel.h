//
//  PostVoteModel.h
//  DiscuzMobile
//
//  Created by HB on 2017/6/26.
//  Copyright © 2017年 comsenz-service.com.  All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PostVoteModel : NSObject

@property (nonatomic, strong) NSString *subject;     // 标题
@property (nonatomic, strong) NSString *message;     // 详细
@property (nonatomic, strong) NSMutableArray *polloptionArr;// 投票选项
@property (nonatomic, strong) NSMutableArray *aidArray;     // 图片aid 数组
@property (nonatomic ,strong) NSMutableArray *checkArr;    // 投票后结果可见    公开投票参与人
@property (nonatomic ,assign) BOOL isVisibleResult;        // 是否公开投票结果
@property (nonatomic ,assign) BOOL isVisibleParticipants;  //是否公开投票参与人
@property (nonatomic ,strong) NSString *radioValue;     // 单选  OR  多选
@property (nonatomic, strong) NSString *dayNum;         // 天数
@property (nonatomic, strong) NSString *selectNum;     // 最多可选项数

@property (nonatomic, strong) NSString *typeId; // 要选择主题类型typeid

@end
