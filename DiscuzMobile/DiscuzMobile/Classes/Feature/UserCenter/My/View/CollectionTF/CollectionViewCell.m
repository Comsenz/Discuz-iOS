//
//  CollectionViewCell.m
//  DiscuzMobile
//
//  Created by gensinimac1 on 15/10/21.
//  Copyright © 2015年 Cjk. All rights reserved.
//

#import "CollectionViewCell.h"

@implementation CollectionViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createUI];
    }
    return self;
}

-(void)createUI {
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, WIDTH-25, 50)];
    self.titleLabel.font = [FontSize HomecellNameFontSize16];//14
    self.titleLabel.textColor = MAIN_TITLE_COLOR;
    self.titleLabel.numberOfLines = 0;
    [self addSubview:self.titleLabel];
    
    
    self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.titleLabel.frame), CGRectGetMaxY(self.titleLabel.frame), 100, 15)];
    self.nameLabel.font = [FontSize forumInfoFontSize12];//12
    self.nameLabel.textColor = MAIN_COLLOR;
    [self addSubview:self.nameLabel];
    
    self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.nameLabel.frame) + 5, self.titleLabel.frame.size.height, 120, 15)];
    self.timeLabel.font = [FontSize forumInfoFontSize12];//12
    self.timeLabel.textColor = mRGBColor(180, 180, 180);
    [self addSubview:self.timeLabel];
    
}

- (void)setData:(NSDictionary*)dic {
    
    self.titleLabel.text = [dic objectForKey:@"title"];
    
    NSLog(@"%@",[dic objectForKey:@"fname"]);
    if ([DataCheck isValidString:[dic objectForKey:@"author"]])
    {
        self.nameLabel.text = [dic objectForKey:@"author"];
    }
    self.timeLabel.text = [NSDate timeStringFromTimestamp:[dic objectForKey:@"dateline"] format:@"yyyy-MM-dd"];
}

@end
