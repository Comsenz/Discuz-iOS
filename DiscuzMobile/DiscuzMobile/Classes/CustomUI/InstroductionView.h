//
//  InstroductionView.h
//  DiscuzMobile
//
//  Created by HB on 16/12/19.
//  Copyright © 2016年 comsenz-service.com.  All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^DisMissBlock)(void);

@interface InstroductionView : UIScrollView

@property (nonatomic, copy) DisMissBlock dismissBlock;

- (void)setPerpage:(NSMutableArray<UIImage *> *)imageArr;

@end
