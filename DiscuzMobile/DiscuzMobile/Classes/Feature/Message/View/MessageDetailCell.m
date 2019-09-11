//
//  MessageDetailCell.m
//  DiscuzMobile
//
//  Created by gensinimac1 on 15/7/6.
//  Copyright (c) 2015年 Cjk. All rights reserved.
//

#import "MessageDetailCell.h"
#import "CellFrameModel.h"
#import "MessageModel.h"
#import "UIImage+DrawCricleImage.h"

@interface MessageDetailCell()
{
    UILabel *_timeLabel;
    UIImageView *_iconView;
    UIButton *_textView;
}
@end

@implementation MessageDetailCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        self.backgroundView = nil;
        self.backgroundColor = [UIColor clearColor];
//        self.backgroundColor = [UIColor redColor];
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.textAlignment = NSTextAlignmentCenter;
        _timeLabel.textColor = [UIColor grayColor];
        _timeLabel.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:_timeLabel];
        
        _iconView = [[UIImageView alloc] init];
        [self.contentView addSubview:_iconView];
        
        _textView = [UIButton buttonWithType:UIButtonTypeCustom];
        _textView.titleLabel.numberOfLines = 0;
        _textView.titleLabel.font = [UIFont systemFontOfSize:13];
//        _textView.backgroundColor = [UIColor greenColor];
        _textView.contentEdgeInsets = UIEdgeInsetsMake(textPadding, textPadding, textPadding, textPadding);
        [self.contentView addSubview:_textView];
    }
    return self;
}

- (void)setCellFrame:(CellFrameModel *)cellFrame
{
    _cellFrame = cellFrame;
    MessageModel * message = cellFrame.message;
    
    _timeLabel.frame = cellFrame.timeFrame;
    _timeLabel.text = message.time;
    
    _iconView.frame = cellFrame.iconFrame;
//    NSString *iconStr = message.type ? @"other" : @"me";
//     NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"%@avatar.php?uid=%@&size=small",BASEURL,message.authorid]];
//    _iconView.image = [UIImage imageNamed:iconStr];
    _iconView.layer.masksToBounds = YES;
    _iconView.layer.cornerRadius = _iconView.frame.size.width/2;
//    [_iconView sd_setImageWithURL:url ];
    _iconView.image =[UIImage imageNamed:@"消息"];
    _textView.frame = cellFrame.textFrame;
    NSString * textBg = message.type ? @"chat_recive_nor" : @"chat_send_nor";
    UIColor * textColor = message.type ? [UIColor blackColor] : [UIColor whiteColor];
    [_textView setTitleColor:textColor forState:UIControlStateNormal];
    [_textView setBackgroundImage:[UIImage resizeImage:textBg] forState:UIControlStateNormal];
    [_textView setTitle:message.text forState:UIControlStateNormal];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



@end
