//
//  FootRootController.m
//  DiscuzMobile
//
//  Created by HB on 2017/6/12.
//  Copyright © 2017年 comsenz-service.com.  All rights reserved.
//

#import "FootRootController.h"
#import "JTContainerController.h"
#import "FootForumController.h"
#import "FootmarkController.h"


@interface FootRootController ()

@end

@implementation FootRootController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"最近";
    
    FootForumController *forumVC = [[FootForumController alloc] init];
    forumVC.title =@"版块";
    
    FootmarkController *threadVC = [[FootmarkController alloc] init];
    threadVC.title = @"帖子";
    
    NSArray *ctArr = @[forumVC,threadVC];
    
    CGRect segmentRect = CGRectMake(0, 0, WIDTH, 44);
    
    JTContainerController *containerVC = [[JTContainerController alloc] init];
    [containerVC setSubControllers:ctArr parentController:self andSegmentRect:segmentRect];
}

@end
