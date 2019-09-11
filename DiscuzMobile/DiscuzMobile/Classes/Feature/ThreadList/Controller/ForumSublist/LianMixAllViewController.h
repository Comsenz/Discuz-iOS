//
//  LianMixAllViewController.h
//  DiscuzMobile
//
//  Created by HB on 2017/5/19.
//  Copyright © 2017年 comsenz-service.com.  All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

typedef void(^CForumBlock)(BOOL isCollection);

@interface LianMixAllViewController : BaseViewController

@property (nonatomic, strong) UIView *contentView;

@property (nonatomic ,strong) NSString *forumFid;

@property (nonatomic, assign) NSInteger selectIndex;

@property (nonatomic, copy) CForumBlock cForumBlock;

// 设置tableview滚动属性
- (void)setScrollEnable:(BOOL)scrollable;

@end
