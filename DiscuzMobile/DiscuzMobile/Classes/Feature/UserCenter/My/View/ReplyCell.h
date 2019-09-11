//
//  ReplyCell.h
//  DiscuzMobile
//
//  Created by HB on 2017/6/12.
//  Copyright © 2017年 comsenz-service.com.  All rights reserved.
//

#import <UIKit/UIKit.h>
@class ReplyModel;

@interface ReplyCell : UITableViewCell

@property (nonatomic, strong) UILabel *timeLab;
@property (nonatomic, strong) UILabel *floorLab;
@property (nonatomic, strong) UILabel *messageLab;
@property (nonatomic, strong) UILabel *subjectLab;

- (CGFloat)cellHeight;
- (void)setInfo:(ReplyModel *)info;

@end
