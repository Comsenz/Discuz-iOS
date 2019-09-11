//
//  ActiveUserFieldCell.h
//  DiscuzMobile
//
//  Created by HB on 2017/7/27.
//  Copyright © 2017年 comsenz-service.com.  All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SendUserArrayBlock)(NSArray *userArray);

@interface ActiveUserFieldCell : UITableViewCell

@property (nonatomic, strong) NSMutableArray *userArray;
@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) NSMutableDictionary *activityfield;

@property (nonatomic, copy) SendUserArrayBlock senduserBlock;

- (CGFloat)cellHeight;

@end
