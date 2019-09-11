//
//  SubjectCell.m
//  DiscuzMobile
//
//  Created by gensinimac1 on 15/5/5.
//  Copyright (c) 2015年 Cjk. All rights reserved.
//

#import "SubjectCell.h"
#import "FontSize.h"
@implementation SubjectCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createUI];
    }
    return self;
}

- (void)createUI {
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, WIDTH-25, 50)];
    self.titleLabel.font = [FontSize HomecellNameFontSize16];
    self.titleLabel.textColor = MAIN_TITLE_COLOR;
    self.titleLabel.numberOfLines = 0;
    [self addSubview:self.titleLabel];
    
    self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.titleLabel.frame), self.titleLabel.frame.size.height, 100, 15)];
    self.nameLabel.font = [FontSize forumInfoFontSize12];//12
    self.nameLabel.textColor = MAIN_COLLOR;
    [self addSubview:self.nameLabel];
    
    self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.nameLabel.frame) + 5, self.titleLabel.frame.size.height, 120, 15)];
    self.timeLabel.font = [FontSize forumInfoFontSize12];//12
    self.timeLabel.textColor = mRGBColor(180, 180, 180);
    [self addSubview:self.timeLabel];
}

-(void)setData:(NSDictionary*)dic{
    
    NSString *subject = [dic objectForKey:@"subject"];
     self.titleLabel.text = subject;
    
    if ([DataCheck isValidString:[dic objectForKey:@"displayorder"]]) {
        NSString *displayorder = [dic objectForKey:@"displayorder"];
        if ([displayorder isEqualToString:@"-2"]) {
            subject = [subject stringByAppendingString:[NSString stringWithFormat:@"(审核中)"]];
            
        } else if ([displayorder isEqualToString:@"-1"]) {
            subject = [subject stringByAppendingString:[NSString stringWithFormat:@"(回收站)"]];
        }
        if ([displayorder isEqualToString:@"-2"] || [displayorder isEqualToString:@"-1"]) {
            NSMutableAttributedString *subjectStr = [[NSMutableAttributedString alloc] initWithString:subject];
            NSDictionary *attDic = @{NSForegroundColorAttributeName:LIGHT_TEXT_COLOR,
                                     NSFontAttributeName:[FontSize forumInfoFontSize12]
                                     };
            [subjectStr addAttributes:attDic range:NSMakeRange(subject.length - 5, 5)];
            self.titleLabel.attributedText = subjectStr;
        }
        
    }
    
    self.nameLabel.text = [dic objectForKey:@"author"];
    self.timeLabel.text = [[dic objectForKey:@"dateline"] transformationStr];
}

@end
