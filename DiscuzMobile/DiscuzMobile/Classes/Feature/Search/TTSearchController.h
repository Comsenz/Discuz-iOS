//
//  TTSearchController.h
//  DiscuzMobile
//
//  Created by HB on 16/4/15.
//  Copyright © 2016年 Cjk. All rights reserved.
//

#import "BaseTableViewController.h"

typedef NS_ENUM(NSUInteger, searchPostionType) {
    searchPostionTypeTabbar,
    searchPostionTypeNext,
};

@interface TTSearchController : BaseTableViewController
@property (nonatomic, assign) searchPostionType type;
@end
