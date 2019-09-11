//
//  OtherUserPostReplyCell.m
//  DiscuzMobile
//
//  Created by gensinimac1 on 15/8/24.
//  Copyright (c) 2015年 Cjk. All rights reserved.
//

#import "OtherUserPostReplyCell.h"
#import "FontSize.h"
@implementation OtherUserPostReplyCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createUI];
    }
    return self;
}

- (void)createUI {
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, WIDTH-20, 50)];
    self.titleLabel.font = [FontSize  forumtimeFontSize14];//14
    self.titleLabel.numberOfLines = 1;
    [self addSubview:self.titleLabel];
    
    self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, self.titleLabel.frame.size.height+10, 100, 15)];
    self.nameLabel.font = [FontSize  forumInfoFontSize12];//12
    self.nameLabel.textColor = MAIN_COLLOR;
    [self addSubview:self.nameLabel];
    
    self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(110, self.titleLabel.frame.size.height+10, 120, 15)];
    self.timeLabel.font =  [FontSize  forumInfoFontSize12];//12
    self.timeLabel.textColor = mRGBColor(180, 180, 180);
    [self addSubview:self.timeLabel];
}

- (void)setData:(NSDictionary*)dic {
    self.titleLabel.text = [dic objectForKey:@"subject"];
    self.nameLabel.text = [dic objectForKey:@"author"];
    self.timeLabel.text =[dic objectForKey:@"dateline"];
}

@end
