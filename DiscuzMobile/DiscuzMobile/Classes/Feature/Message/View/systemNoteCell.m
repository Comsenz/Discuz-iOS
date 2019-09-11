//
//  systemNoteCell.m
//  DiscuzMobile
//
//  Created by HB on 17/4/13.
//  Copyright © 2017年 comsenz-service.com.  All rights reserved.
//

#import "systemNoteCell.h"
#import "MessageListModel.h"

@implementation systemNoteCell

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
    
    CGRect frame = self.headImageView.frame;
    self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(frame.size.width+20, 10, 190, 15)];
    self.nameLabel.font = [FontSize HomecellTimeFontSize16];
    [self addSubview:self.nameLabel];
    
    self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(WIDTH-100, 10,90, 15)];
    self.timeLabel.font = [FontSize forumInfoFontSize12];
    self.timeLabel.textAlignment = NSTextAlignmentRight;
    self.timeLabel.textColor = MAIN_TITLE_COLOR;
    [self addSubview:self.timeLabel];
    
    self.contenLabel = [[UILabel alloc] initWithFrame:CGRectMake(frame.size.width+20, 25, WIDTH-(frame.size.width+20+10), 45)];
    self.contenLabel.font =  [FontSize forumtimeFontSize14];
    self.contenLabel.textColor = MAIN_TITLE_COLOR;
    self.contenLabel.numberOfLines = 0;
    [self addSubview:self.contenLabel];
    
}

-(void)setdata:(NSDictionary*)dic {
    
    if ([DataCheck isValidString:[dic objectForKey:@"id"]]) {// 是否是系统消息
        // 是系统消息
        NSString * timeStr = [NSDate timeStringFromTimestamp:[dic objectForKey:@"dateline"] format:@"yyyy-MM-dd"];
        
        self.timeLabel.text = [timeStr transformationStr];
        DLog(@"%@",[dic objectForKey:@"dateline"]);
        DLog(@"%@",[dic objectForKey:@"message"]);
        
        NSString *message = [[dic objectForKey:@"note"] transformationStr];
        
        self.contenLabel.text = message;
        //        self.contenLabel.text = [dic objectForKey:@"message"];
        self.nameLabel.text =@"系统消息";
    }else{
        
        //不是系统消息
        NSString * content= [NSString stringWithFormat:@"%@",[dic objectForKey:@"vdateline"]];
        
        self.timeLabel.text = [content transformationStr];
        self.contenLabel.text=[dic objectForKey:@"message"];
        //         self.contenLabel.text = [dic objectForKey:@"message"];
        DLog(@"%@",[dic objectForKey:@"vdateline"]);
        DLog(@"%@",[dic objectForKey:@"message"]);
        self.nameLabel.text = [dic objectForKey:@"tousername"];
        NSURL *url = [NSURL URLWithString:[dic objectForKey:@"toavatar"]];
        [self.headImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"noavatar_small"]];
    }
   
    
    
}

-(void)setData:(MessageListModel *)message {
    
    NSString * timeStr = [NSDate timeStringFromTimestamp:message.dateline format:@"yyyy-MM-dd"];
    self.timeLabel.text = [timeStr transformationStr];
    NSString *messagestr = [NSString stringWithFormat:@"<div style='font-size:14px;font-family:PingFang-SC-Light;'>%@<div>",message.note];
    
    self.nameLabel.text =@"系统消息";
    
    if ([message.type isEqualToString:@"post"]) {
        
        NSString *subject = [message.notevar objectForKey:@"subject"];
        self.contenLabel.text = [NSString stringWithFormat:@"回复了您的帖子  %@",subject];
        self.nameLabel.text = message.author;
    } else {
        self.contenLabel.text = messagestr;
    }
    
    
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
