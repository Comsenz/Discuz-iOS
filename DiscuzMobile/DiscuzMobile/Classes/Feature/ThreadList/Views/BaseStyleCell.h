//
//  BaseStyleCell.h
//  DiscuzMobile
//
//  Created by piter on 2018/1/25.
//  Copyright © 2018年 comsenz-service.com.  All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ThreadListModel.h"
#import "DZHomeIconTextView.h"

@interface BaseStyleCell : UITableViewCell

@property (nonatomic, strong) UIImageView *headV;  // 头像
@property (nonatomic, strong) UILabel *nameLab;    // 用户名
@property (nonatomic, strong) UILabel *grade;
@property (nonatomic, strong) UIImageView *tipIcon;
@property (nonatomic, strong) UILabel *tipLab;
@property (nonatomic, strong) UILabel *desLab;     // 标题
@property (nonatomic, strong) UILabel *messageLab; // 内容
@property (nonatomic, strong) UILabel *datelineLab; // 时间
@property (nonatomic, assign) BOOL hasPic;

@property (nonatomic, strong) DZHomeIconTextView *viewsLab;   // 浏览数
@property (nonatomic, strong) DZHomeIconTextView *repliesLab; // 回复数
@property (nonatomic, strong) DZHomeIconTextView *priceLab;   // 点赞数

@property (nonatomic, strong) ThreadListModel *info;

- (CGFloat)cellHeight;

- (CGFloat)caculateCellHeight:(ThreadListModel *)info;

@end
