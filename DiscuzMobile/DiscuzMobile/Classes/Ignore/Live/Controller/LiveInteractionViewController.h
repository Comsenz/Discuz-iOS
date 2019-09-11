//
//  LiveInteractionViewController.h
//  DiscuzMobile
//
//  Created by HB on 2017/8/28.
//  Copyright © 2017年 comsenz-service.com.  All rights reserved.
//

#import "BaseTableViewController.h"
@class HotLivelistModel;

typedef void(^HideKeyboardBlock)(void);

@interface LiveInteractionViewController : BaseTableViewController
{
    
    NSCache *cellCache;
}
@property (nonatomic, copy) HideKeyboardBlock hideKeyboard;

@property (nonatomic, strong) HotLivelistModel *listModel;

@end
