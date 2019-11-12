//
//  DZBaseTableView.m
//  PandaReader
//
//  Created by 孙震 on 2019/5/13.
//  Copyright © 2019 ZHWenXue. All rights reserved.
//

#import "DZBaseTableView.h"

@implementation DZBaseTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    self = [super initWithFrame:frame style:style];
    if (self) {
        [self loadSetting];
    }
    return self;
}

- (void)loadSetting {
    self.estimatedRowHeight = 0;
    self.estimatedSectionHeaderHeight = 0;
    self.estimatedSectionFooterHeight = 0;
    self.separatorColor = KColor(KECECEC_Color, 1);
    if (@available(iOS 11.0, *)) {
        self.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
}

@end
