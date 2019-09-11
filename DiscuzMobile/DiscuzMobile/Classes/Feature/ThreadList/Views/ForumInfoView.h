//
//  ForumInfoView.h
//  DiscuzMobile
//
//  Created by HB on 17/1/17.
//  Copyright © 2017年 comsenz-service.com.  All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^CollectionForumBlock)(UIButton *sender);

@interface ForumInfoView : UIView

@property (nonatomic, strong) UIImageView *IconV;
@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UILabel *todayPostLab;
@property (nonatomic, strong) UILabel *threadsLab;
@property (nonatomic, strong) UILabel *bankLab;
@property (nonatomic, strong) UILabel *describLab;

@property (nonatomic, strong) UIButton *collectionBtn;

@property (nonatomic, copy) CollectionForumBlock collectionBlock;

@end
