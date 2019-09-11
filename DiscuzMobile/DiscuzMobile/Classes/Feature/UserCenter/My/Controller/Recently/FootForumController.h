//
//  ForumCollectionController.h
//  DiscuzMobile
//
//  Created by HB on 17/5/2.
//  Copyright © 2017年 comsenz-service.com.  All rights reserved.
//

#import "BaseViewController.h"

//typedef void(^sendPublicBlock)(NSDictionary *dic);

typedef NS_ENUM(NSInteger, ForumType) {
    Forum_index = 0,
    Forum_hot,
};

@interface FootForumController : BaseViewController

@end
