//
//  CenterToolView.h
//  DiscuzMobile
//
//  Created by HB on 17/1/19.
//  Copyright © 2017年 comsenz-service.com.  All rights reserved.
//

#import <UIKit/UIKit.h>
@class VerticalImageTextView,TextIconModel;

typedef void(^ToolItemClickBlock)(VerticalImageTextView *sender, NSInteger index, NSString *name);

@interface CenterToolView : UIView

@property (nonatomic, strong) NSMutableArray<TextIconModel *> *iconTextArr;

@property (nonatomic, copy) ToolItemClickBlock toolItemClickBlock;

@end
