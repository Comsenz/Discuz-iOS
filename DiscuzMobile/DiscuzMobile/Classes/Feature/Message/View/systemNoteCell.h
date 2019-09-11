//
//  systemNoteCell.h
//  DiscuzMobile
//
//  Created by HB on 17/4/13.
//  Copyright © 2017年 comsenz-service.com.  All rights reserved.
//

#import <UIKit/UIKit.h>
@class CustomMLLabel,MessageListModel;

@interface systemNoteCell : UITableViewCell
@property (nonatomic, strong) UIImageView *headImageView;
@property (nonatomic, strong) UILabel * nameLabel;
@property (nonatomic, strong) UILabel * contenLabel;
@property (nonatomic, strong) UILabel * timeLabel;

-(void)setdata:(NSDictionary*)dic;

-(void)setData:(MessageListModel *)message;
@end
