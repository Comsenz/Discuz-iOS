//
//  ForumRightCell.h
//  DiscuzMobile
//
//  Created by piter on 2018/1/30.
//  Copyright © 2018年 comsenz-service.com.  All rights reserved.
//

#import <UIKit/UIKit.h>
@class DZForumInfoModel, LightGrayButton;

typedef void(^CollectionForumBlock)(LightGrayButton *sender, DZForumInfoModel *infoModel);

@interface ForumRightCell : UITableViewCell

@property (nonatomic, strong) UIImageView *iconV;
@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UILabel *numLab;
@property (nonatomic, strong) UILabel *postsLab;
@property (nonatomic, strong) LightGrayButton *collectionBtn;

/**
 * 设置直接显示的cell数据
 */
- (void)setInfo:(DZForumInfoModel *)node;

@property (nonatomic, copy) CollectionForumBlock collectionBlock;

@end
