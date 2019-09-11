//
//  FastLevelCell.h
//  DiscuzMobile
//
//  Created by ZhangJitao on 2018/7/18.
//  Copyright © 2018年 comsenz-service.com.  All rights reserved.
//

#import <UIKit/UIKit.h>
@class TreeViewNode;

@interface FastLevelCell : UITableViewCell

@property (nonatomic, strong) UIImageView *iconV;
@property (nonatomic, strong) UILabel *titleLab;

@property (strong, nonatomic) UIButton *statusBtn;

/**
 * 设置直接显示的cell数据
 */
- (void)setInfo:(TreeViewNode *)node;

@end
