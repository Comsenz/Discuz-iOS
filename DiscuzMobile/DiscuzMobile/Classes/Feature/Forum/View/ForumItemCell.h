//
//  ForumItemCell.h
//  DiscuzMobile
//
//  Created by HB on 17/5/2.
//  Copyright © 2017年 comsenz-service.com.  All rights reserved.
//

#import <UIKit/UIKit.h>
@class ForumInfoModel;

@interface ForumItemCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *iconV;
@property (nonatomic, strong) UILabel *titleLab;

@property (nonatomic, strong) UILabel *numLab;
@property (nonatomic, strong) UILabel *postsLab;

/**
 * 设置直接显示的cell数据
 */
- (void)setInfo:(ForumInfoModel *)node;

@end
