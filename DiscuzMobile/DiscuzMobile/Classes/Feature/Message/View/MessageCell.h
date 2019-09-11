//
//  MessageCell.h
//  DiscuzMobile
//
//  Created by gensinimac1 on 15/5/4.
//  Copyright (c) 2015年 Cjk. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MessageListModel;

@interface MessageCell : UITableViewCell

@property (nonatomic, strong) UIImageView *headImageView;
@property (nonatomic, strong) UILabel * nameLabel;
@property (nonatomic, strong) UILabel * contenLabel;
@property (nonatomic, strong) UILabel * timeLabel;

-(void)setData:(MessageListModel *)message;

- (CGFloat)cellHeight;

@end
