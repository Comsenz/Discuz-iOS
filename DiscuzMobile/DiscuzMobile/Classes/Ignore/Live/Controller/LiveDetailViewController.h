//
//  LiveDetailViewController.h
//  DiscuzMobile
//
//  Created by HB on 2017/5/10.
//  Copyright © 2017年 comsenz-service.com.  All rights reserved.
//

#import "BaseTableViewController.h"

@class HotLivelistModel;

typedef void(^HideKeyboardBlock)(void);
typedef void(^SendParameterBlock)(id responseObject);

@interface LiveDetailViewController : BaseTableViewController {
	
	NSCache *cellCache;
}

@property (nonatomic, copy) HideKeyboardBlock hideKeyboard;
@property (nonatomic, strong) NSMutableArray *oldArray;

@property (nonatomic, strong)  NSMutableDictionary *dateTimeDic;

@property (nonatomic, strong) NSMutableArray *detaiArr;

@property (nonatomic, strong) HotLivelistModel *listModel;

@property (nonatomic, copy) SendParameterBlock sendParameterBlock;

- (void)sortLiveDetail;

- (void)refreshData;

@end
