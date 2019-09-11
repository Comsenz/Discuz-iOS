//
//  SearchListCell.h
//  DiscuzMobile
//
//  Created by ZhangJitao on 2018/7/11.
//  Copyright © 2018年 Cjk. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TTSearchModel;

@interface SearchListCell : UITableViewCell

@property (strong, nonatomic)  UILabel *contentLabel;
@property (strong, nonatomic)  UILabel *timeLabel;
@property (strong, nonatomic)  UILabel *evaluateLabel;

@property (nonatomic, strong) TTSearchModel *info;

- (CGFloat)caculateCellHeight:(TTSearchModel *)info;

@end
