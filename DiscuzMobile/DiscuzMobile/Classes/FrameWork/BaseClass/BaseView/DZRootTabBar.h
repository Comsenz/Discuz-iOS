//
//  DZRootTabBar.h
//  PandaReader
//
//  Created by WebersonGao on 2019/3/7.
//  Copyright © 2019 comsenz-service.com.  All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    TabItemShelf,
    TabItemExplore,
    TabItemMe,
} TabItemIndex;

NS_ASSUME_NONNULL_BEGIN

@interface DZRootTabBar : UITabBar

/// WBS 显示小红点 （不能显示数字）
- (void)showBadgeOnItemIndex:(TabItemIndex)index;

/// WBS 隐藏小红点
- (void)hideBadgeOnItemIndex:(TabItemIndex)index;


- (void)setHidden:(BOOL)hidden animated:(BOOL)animated;

@end

NS_ASSUME_NONNULL_END
