//
//  CollectionRootController.m
//  DiscuzMobile
//
//  Created by HB on 17/1/20.
//  Copyright © 2017年 comsenz-service.com.  All rights reserved.
//

#import "CollectionRootController.h"
#import "CollectionForumController.h"
#import "CollectionThreadController.h"
#import "LoginController.h"

#import "JTContainerController.h"

@interface CollectionRootController ()

@property (nonatomic, strong) JTContainerController *rootVC;
@property (nonatomic, strong) NSMutableArray *controllerArr;

@end

@implementation CollectionRootController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"收藏";
    
    CollectionForumController *forumVC = [[CollectionForumController alloc] init];
    forumVC.title =@"版块";
    
    CollectionThreadController *threadVC = [[CollectionThreadController alloc] init];
    threadVC.title = @"帖子";
    
    [self.controllerArr addObject:forumVC];
    [self.controllerArr addObject:threadVC];
    
    CGRect segmentRect = CGRectMake(0, 0, WIDTH, 44);
    self.rootVC = [[JTContainerController alloc] init];
    [self.rootVC setSubControllers:self.controllerArr parentController:self andSegmentRect:segmentRect];
}

- (NSMutableArray *)controllerArr {
    if (!_controllerArr) {
        _controllerArr = [NSMutableArray array];
    }
    return _controllerArr;
}

@end
