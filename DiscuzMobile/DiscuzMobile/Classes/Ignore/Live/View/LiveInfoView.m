//
//  LiveInfoView.m
//  DiscuzMobile
//
//  Created by HB on 2017/5/10.
//  Copyright © 2017年 comsenz-service.com.  All rights reserved.
//

#import "LiveInfoView.h"
#import "HotLivelistModel.h"
#import "TopLabel.h"

@interface LiveInfoView()

@property (nonatomic, strong) UIView *sepView;

@end

@implementation LiveInfoView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commitInit];
    }
    return self;
}

- (void)commitInit {
    self.titleLab = [[TopLabel alloc] initWithFrame:CGRectMake(10, 10, WIDTH - 20, 45)];
    self.titleLab.font = [FontSize NavBackFontSize];
    self.titleLab.textColor = MAIN_TITLE_COLOR;
    self.titleLab.numberOfLines = 0;
    self.titleLab.text = @"第31届奥林匹克运动会";
    [self addSubview:self.titleLab];
    
    self.headIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"noavatar_small"]];
    self.headIcon.frame = CGRectMake(10, CGRectGetMaxY(self.titleLab.frame) + 5, 30, 30);
    self.headIcon.layer.masksToBounds = YES;
    self.headIcon.userInteractionEnabled = YES;
    self.headIcon.layer.cornerRadius = CGRectGetWidth(self.headIcon.frame) / 2;
    [self addSubview:self.headIcon];
    
    self.nameLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.headIcon.frame), CGRectGetMinY(self.headIcon.frame), 100, CGRectGetHeight(self.headIcon.frame))];
    self.nameLab.font = [FontSize HomecellNameFontSize16];
    self.nameLab.text = @"Jack";
    self.nameLab.textColor = LIGHT_TEXT_COLOR;
    [self addSubview:self.nameLab];
    
    CGSize maxSize = CGSizeMake(120, 30);
    CGSize textSize = [self.nameLab.text sizeWithFont:[FontSize HomecellNameFontSize16] maxSize:maxSize];
    self.nameLab.frame = CGRectMake(CGRectGetMaxX(self.headIcon.frame) + 10, CGRectGetMidY(self.headIcon.frame) - 15, textSize.width, 30);
    
    self.gradeLab = [[UILabel alloc] init];
    self.gradeLab.text =  @"Lv91";
    self.gradeLab.font = [FontSize gradeFontSize9];
    self.gradeLab.textAlignment = NSTextAlignmentCenter;
    self.gradeLab.textColor = NAVI_BAR_COLOR;
    self.gradeLab.backgroundColor = MAIN_COLLOR;
    [self addSubview:self.gradeLab];
    maxSize = CGSizeMake(100, 20);
    textSize = [self.gradeLab.text sizeWithFont:[FontSize gradeFontSize9] maxSize:maxSize];
    self.gradeLab.frame =  CGRectMake(CGRectGetMaxX(self.nameLab.frame) + 10, CGRectGetMidY(self.nameLab.frame) - textSize.height / 2, textSize.width + 4, textSize.height);
    self.gradeLab.layer.masksToBounds = YES;
    self.gradeLab.layer.cornerRadius = 2;
    
    //收藏按钮
    self.collectionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_collectionBtn setImage:[UIImage imageTintColorWithName:@"collection" andImageSuperView:_collectionBtn] forState:UIControlStateNormal];
    _collectionBtn.tag = 100001;
    _collectionBtn.cs_acceptEventInterval = 1;
    self.collectionBtn.frame = CGRectMake(WIDTH-58-10, CGRectGetMinY(self.headIcon.frame) + 2, 58, 26);
    [self addSubview:self.collectionBtn];
    
    self.sepView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.frame) - 5, WIDTH, 5)];
    self.sepView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self addSubview:self.sepView];
}

- (void)setInfo:(HotLivelistModel *)model {
    
//    self.titleLab.text = model.subject;
     CGSize maxSize = CGSizeMake(WIDTH - 20, 45);
    CGSize textSize = [[NSString stringWithFormat:@"%@直播",model.subject]  sizeWithFont:[FontSize NavBackFontSize] maxSize:maxSize];
    [self.titleLab setText:model.subject andImageName:@"直播" andSize:CGSizeMake(34 ,17) andPosition:P_after];
    self.titleLab.frame = CGRectMake(10, 10, WIDTH - 20, textSize.height);
    
    [self.headIcon sd_setImageWithURL:[NSURL URLWithString:model.avatar] placeholderImage:[UIImage imageNamed:@"noavatar_small"] options:SDWebImageRetryFailed];
    self.nameLab.text = model.author;
    NSString *gradestr = model.grouptitle;
    if ([model.grouptitle integerValue] > 0) {
        gradestr = [NSString stringWithFormat:@"Lv%@",model.grouptitle];
    }
    self.gradeLab.text = gradestr;
    
    maxSize = CGSizeMake(120, 30);
    textSize = [self.nameLab.text sizeWithFont:[FontSize HomecellNameFontSize16] maxSize:maxSize];
    self.nameLab.frame = CGRectMake(CGRectGetMaxX(self.headIcon.frame) + 10, CGRectGetMidY(self.headIcon.frame) - 15, textSize.width, 30);
    maxSize = CGSizeMake(100, 20);
    textSize = [self.gradeLab.text sizeWithFont:[FontSize gradeFontSize9] maxSize:maxSize];
    self.gradeLab.frame =  CGRectMake(CGRectGetMaxX(self.nameLab.frame) + 10, CGRectGetMidY(self.nameLab.frame) - textSize.height / 2, textSize.width + 4, textSize.height);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
