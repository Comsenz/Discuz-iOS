//
//  MessageCell.m
//  DiscuzMobile
//
//  Created by gensinimac1 on 15/5/4.
//  Copyright (c) 2015年 Cjk. All rights reserved.
//

#import "MessageCell.h"
#import "MessageListModel.h"

@implementation MessageCell


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
    self.headImageView.backgroundColor = [UIColor redColor];
    [self addSubview:self.headImageView];
    
    CGRect frame = self.headImageView.frame;
    self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(frame.size.width+20, 8, 190, 19)];
    self.nameLabel.font = [FontSize HomecellTimeFontSize16];
    [self addSubview:self.nameLabel];
    
    self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(WIDTH-128, 10,120, 15)];
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

-(void)setData:(MessageListModel *)message {
    
    //不是系统消息
    NSString * content= [NSString stringWithFormat:@"%@",message.vdateline];
    
    self.timeLabel.text = [content transformationStr];
    self.contenLabel.text = message.message;
    //         self.contenLabel.text = [dic objectForKey:@"message"];
    NSLog(@"%@",message.vdateline);
    NSLog(@"%@",message.message);
    if ([DataCheck isValidString:message.tousername]) {
        self.nameLabel.text = message.tousername;
    } else {
        self.nameLabel.text = message.author;
    }
    
    CGRect frame = self.headImageView.frame;
    CGFloat width = WIDTH-(frame.size.width+20+10);
    
    CGSize maxSize = CGSizeMake(width, CGFLOAT_MAX);
    CGSize textSize = [self.contenLabel.text sizeWithFont:[FontSize forumtimeFontSize14] maxSize:maxSize];
    if (textSize.height < 20) {
        self.contenLabel.frame = CGRectMake(frame.size.width+20, 25, width, 40);
    } else {
        self.contenLabel.frame = CGRectMake(frame.size.width+20, 25, width, textSize.height);
    }
    
    NSURL *url = [NSURL URLWithString:message.toavatar];
    [self.headImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"noavatar_small"]];
    
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
