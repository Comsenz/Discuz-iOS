//
//  SubForumCell.h
//  DiscuzMobile
//
//  Created by HB on 2017/5/22.
//  Copyright © 2017年 comsenz-service.com.  All rights reserved.
//

#import <UIKit/UIKit.h>
@class ForumInfoModel;

@interface SubForumCell : UITableViewCell

@property (nonatomic, strong) UIImageView *iconV;
@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UILabel *numLab;
@property (nonatomic, strong) UILabel *postsLab;


/**
 * 设置直接显示的cell数据
 */
- (void)setInfo:(ForumInfoModel *)node;

@end
