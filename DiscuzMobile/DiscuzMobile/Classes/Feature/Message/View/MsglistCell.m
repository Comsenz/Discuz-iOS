//
//  MsglistCell.m
//  DiscuzMobile
//
//  Created by HB on 2017/7/17.
//  Copyright © 2017年 comsenz-service.com.  All rights reserved.
//

#import "MsglistCell.h"
#import "MessageListModel.h"

@implementation MsglistCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self createUI];
    }
    return self;
}

-(void)createUI {
    self.headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 49, 49)];
    self.headImageView.layer.masksToBounds = YES;
    self.headImageView.layer.cornerRadius = self.headImageView.frame.size.width / 2;
    self.headImageView.image = [UIImage imageNamed:@"消息"];
    [self addSubview:self.headImageView];
    
//    CGRect frame = self.headImageView.frame;
//    self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(frame.size.width+20, 10, 190, 15)];
//    self.nameLabel.font = [FontSize HomecellTimeFontSize16];
//    [self addSubview:self.nameLabel];
    CGRect frame = self.headImageView.frame;
    self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(frame.size.width+20, 8, 200, 16)];
    self.timeLabel.font = [FontSize forumInfoFontSize12];
    self.timeLabel.textAlignment = NSTextAlignmentLeft;
    self.timeLabel.textColor = MAIN_TITLE_COLOR;
    [self addSubview:self.timeLabel];
    
    self.contenLabel = [[UILabel alloc] initWithFrame:CGRectMake(frame.size.width+20, 25, WIDTH-(frame.size.width+20+10), 45)];
    self.contenLabel.font =  [FontSize forumtimeFontSize14];
    self.contenLabel.textColor = MAIN_TITLE_COLOR;
    self.contenLabel.numberOfLines = 0;
    [self addSubview:self.contenLabel];
    
}

-(void)setData:(MessageListModel *)message {
    
    NSString * timeStr = [NSDate timeStringFromTimestamp:message.dateline format:@"yyyy-MM-dd"];
    self.timeLabel.text = [timeStr transformationStr];
    //    [self.contenLabel setMLText:[Utils transformationStr:message.note]];
//    NSString *messagestr = [NSString stringWithFormat:@"<div style='font-size:14px;font-family:PingFang-SC-Light;'>%@<div>",message.note];
    
//    [self.contenLabel setHtmlText:messagestr];
    NSString *mesg =  [message.note flattenHTMLTrimWhiteSpace:NO];
    self.contenLabel.text = [mesg transformationStr];
    CGRect frame = self.headImageView.frame;
    CGFloat width = WIDTH-(frame.size.width+20+10);
    
    CGSize maxSize = CGSizeMake(width, CGFLOAT_MAX);
    CGSize textSize = [self.contenLabel.text sizeWithFont:[FontSize forumtimeFontSize14] maxSize:maxSize];
    if (textSize.height < 20) {
        self.contenLabel.frame = CGRectMake(frame.size.width+20, 25, width, 40);
    } else {
        self.contenLabel.frame = CGRectMake(frame.size.width+20, 25, width, textSize.height);
    }
    
    
//    [self.contenLabel setDidClickLinkBlock:^(MLLink *link, NSString *linkText, MLLinkLabel *label) {
//        NSString *tips = [NSString stringWithFormat:@"Click\nlinkType:%ld\nlinkText:%@\nlinkValue:%@",link.linkType,linkText,link.linkValue];
//        
//    }];
    
//    if ([message.type isEqualToString:@"post"]) {
//        
//        NSString *subject = [message.notevar objectForKey:@"subject"];
//        [self.contenLabel setMLText:[NSString stringWithFormat:@"回复了您的帖子  %@",subject]];
//        self.nameLabel.text = message.author;
//    } else {
//        [self.contenLabel setHtmlText:messagestr];
//    }
    
    
}

- (CGFloat)cellHeight {
    
    if (CGRectGetMaxY(self.headImageView.frame) > CGRectGetMaxY(self.contenLabel.frame)) {
        return CGRectGetMaxY(self.headImageView.frame) + 10;
    }
    
    return CGRectGetMaxY(self.contenLabel.frame) + 5;
}

+ (NSString *)getDateStringWithDate:(NSString *)dateStr
                         DateFormat:(NSString *)formatString
{
    
    double unixTimeStamp = [dateStr doubleValue];
    NSTimeInterval _interval=unixTimeStamp;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:_interval];
    NSDateFormatter *_formatter=[[NSDateFormatter alloc]init];
    [_formatter setLocale:[NSLocale currentLocale]];
    [_formatter setDateFormat:formatString];
    NSString *_date=[_formatter stringFromDate:date];
    
    return _date;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
