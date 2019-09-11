//
//  publicpmCell.m
//  DiscuzMobile
//
//  Created by gensinimac1 on 15/10/15.
//  Copyright © 2015年 Cjk. All rights reserved.
//

#import "publicpmCell.h"
#import "FontSize.h"
@implementation publicpmCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createUI];
    }
    return self;
}

-(void)createUI{
    self.headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 49, 49)];
//    self.headImageView.backgroundColor = [UIColor redColor];
    self.headImageView.image = [UIImage imageNamed:@"消息"];
    [self addSubview:self.headImageView];
    
    CGRect frame = self.headImageView.frame;
    self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(frame.size.width+20, 10, 190, 15)];
    self.nameLabel.font = [FontSize forumtimeFontSize14];//13-14
    self.nameLabel.textColor = MAIN_COLLOR;
    [self addSubview:self.nameLabel];
    
    self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(WIDTH-100, 10,90, 15)];
    self.timeLabel.font = [FontSize HomecellmessageNumLFontSize10];//10
    self.timeLabel.textColor = mRGBColor(180, 180, 180);
    [self addSubview:self.timeLabel];
    
    self.contenLabel = [[UILabel alloc] initWithFrame:CGRectMake(frame.size.width+20, 25, WIDTH-(frame.size.width+20+10), 45)];
    self.contenLabel.font =  [FontSize forumInfoFontSize12];//12
    self.contenLabel.numberOfLines = 0;
    [self addSubview:self.contenLabel];
    
}

- (void)setdata:(NSDictionary*)dic {
    if ([DataCheck isValidString:[dic objectForKey:@"id"]]) {// 是否是系统消息
        // 是系统消息
        NSString * timeStr = [NSDate timeStringFromTimestamp:[dic objectForKey:@"dateline"] format:@"yyyy-MM-dd"];
        self.timeLabel.text = [timeStr transformationStr];
        NSLog(@"%@",[dic objectForKey:@"dateline"]);
        NSLog(@"%@",[dic objectForKey:@"message"]);
        self.contenLabel.text = [dic objectForKey:@"message"];
        self.nameLabel.text =@"系统消息";
    }
}

@end
