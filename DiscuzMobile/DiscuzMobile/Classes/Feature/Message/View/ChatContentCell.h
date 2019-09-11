//
//  ChatContentCell.h
//  DiscuzMobile
//
//  Created by ZhangJitao on 2018/7/2.
//  Copyright © 2018年 comsenz-service.com.  All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChatYYLabel.h"
#import "MessageModel.h"

@interface ChatContentCell : UITableViewCell
@property (nonatomic, strong) UIImageView *headView;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) ChatYYLabel *messageLabel;

@property (nonatomic, strong) MessageModel *messageModel;

- (CGFloat)cellHeight;
@end
