//
//  ThreadViewController.h
//  DiscuzMobile
//
//  Created by gensinimac1 on 15/5/14.
//  Copyright (c) 2015年 Cjk. All rights reserved.
//

#import "BaseViewController.h"

@interface ThreadViewController : BaseViewController

@property (nonatomic, strong) NSString * tid;
@property (nonatomic, strong) NSString * forumtitle;
@property (nonatomic, strong) NSString * threadtitle;
@property (nonatomic)         int currentPageId;
@property (nonatomic, assign) BOOL isOnePage;

@property (nonatomic, strong) NSString * allowPostSpecial; // 发帖 数帖子的标记
@property (nonatomic, strong) NSDictionary * dataForumTherad;

-(void)postReplay;
@end
