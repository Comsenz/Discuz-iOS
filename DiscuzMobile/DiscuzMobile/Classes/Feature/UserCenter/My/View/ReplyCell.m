//
//  ReplyCell.m
//  DiscuzMobile
//
//  Created by HB on 2017/6/12.
//  Copyright © 2017年 comsenz-service.com.  All rights reserved.
//

#import "ReplyCell.h"
#import "ReplyModel.h"

@implementation ReplyCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createUI];
    }
    return self;
}

- (void)createUI {
    self.timeLab = [[UILabel alloc] init];
    self.timeLab.backgroundColor = [UIColor whiteColor];
    self.timeLab.font = [FontSize HomecellTimeFontSize14];
    self.timeLab.textColor = LIGHT_TEXT_COLOR;
    [self.contentView addSubview:self.timeLab];
    
    self.floorLab = [[UILabel alloc] init];
    self.floorLab.font = [FontSize HomecellTimeFontSize14];
    self.floorLab.textAlignment = NSTextAlignmentRight;
    self.floorLab.textColor = LIGHT_TEXT_COLOR;
    [self.contentView addSubview:self.floorLab];
    
    self.messageLab = [[UILabel alloc] init];
    self.messageLab.font = [FontSize HomecellTitleFontSize15];
    self.messageLab.numberOfLines = 0;
    [self.contentView addSubview:self.messageLab];
    
    self.subjectLab = [[UILabel alloc] init];
    self.subjectLab.textColor = LIGHT_TEXT_COLOR;
    self.subjectLab.font = [FontSize HomecellTitleFontSize15];
    [self.contentView addSubview:self.subjectLab];
    
}

- (void)setInfo:(ReplyModel *)info {
    
    self.timeLab.text = info.dateline;
    
    NSArray *floorArr = @[@"楼主",@"沙发",@"板凳",@"地板"];
    NSString *floor = [NSString stringWithFormat:@"%ld楼",[info.positions integerValue]];
    if (floorArr.count >= [info.positions integerValue]) {
        floor = floorArr[[info.positions integerValue] - 1];
    }
    self.floorLab.text = floor;
    self.messageLab.text = [info.message transformationStr];
    self.subjectLab.text = info.subject;
    
    self.timeLab.frame = CGRectMake(15, 10, 200, 15);
    self.floorLab.frame = CGRectMake(WIDTH - 15 - 50, 10, 50, 15);
    
    CGSize maxSize = CGSizeMake(WIDTH - 30, 100);
    CGSize textSize = [self.messageLab.text sizeWithFont:[FontSize HomecellTitleFontSize15] maxSize:maxSize];
    
    self.messageLab.frame = CGRectMake(15, CGRectGetMaxY(self.timeLab.frame) + 10, WIDTH - 30, textSize.height);
    
    self.subjectLab.frame = CGRectMake(15, CGRectGetMaxY(self.messageLab.frame) + 10, WIDTH - 30, 25);
}

- (CGFloat)cellHeight {
    return CGRectGetMaxY(self.subjectLab.frame) + 10;
}

@end
