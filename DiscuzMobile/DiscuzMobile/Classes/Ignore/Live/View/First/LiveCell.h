//
//  LiveCell.h
//  DiscuzMobile
//
//  Created by HB on 2017/5/5.
//  Copyright © 2017年 comsenz-service.com.  All rights reserved.
//

#import <UIKit/UIKit.h>
@class HotLivelistModel;

typedef void(^ClickRecommentBlock)(NSInteger index);

@interface LiveCell : UITableViewCell

@property (nonatomic, copy) ClickRecommentBlock clickRecommentBlock;

- (void)setImageArr:(NSMutableArray<HotLivelistModel *> *)imageArr;

@end
