//
//  FListController.h
//  DiscuzMobile
//
//  Created by HB on 2017/5/19.
//  Copyright © 2017年 comsenz-service.com.  All rights reserved.
//

#import "LianBaseTableController.h"

typedef void(^SendValueBlock)(NSDictionary *dic);
typedef void(^EndRefreshBlock)(void);

@interface FListController : LianBaseTableController

@property (nonatomic, strong) NSString *fid;
@property (nonatomic, assign) NSInteger order;

@property (nonatomic, copy) SendValueBlock sendBlock;
@property (nonatomic, copy) EndRefreshBlock endRefreshBlock;

- (void)refreshData;

@end
