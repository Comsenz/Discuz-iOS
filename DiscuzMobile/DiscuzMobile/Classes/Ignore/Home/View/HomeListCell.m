//
//  HomeListCell.m
//  DiscuzMobile
//
//  Created by HB on 17/1/16.
//  Copyright © 2017年 comsenz-service.com.  All rights reserved.
//

#import "HomeListCell.h"
#import "HomeIconTextView.h"
#import "LoginModule.h"
#import "UIView+WebCache.h"
#import "PraiseHelper.h"
#import "JudgeImageModel.h"

@interface HomeListCell()

@property (nonatomic, strong) CALayer *lineV;
@property (nonatomic, strong) CALayer *sepLine;
@property (nonatomic, strong) UIView *imageBgV;

@end

@implementation HomeListCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initCommit];
    }
    return  self;
}

- (void)setFrame:(CGRect)frame
{
    frame.size.height -= 5;
    [super setFrame:frame];
}

- (void)initCommit {
    
    self.backgroundColor = [UIColor whiteColor];
    
    self.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    [self.contentView addSubview:self.headV];
    [self.contentView addSubview:self.nameLab];
    [self.contentView addSubview:self.grade];
    [self.contentView addSubview:self.tipIcon];
    [self.contentView addSubview:self.desLab];
    [self.contentView addSubview:self.messageLab];
    [self.contentView addSubview:self.datelineLab];
    [self.contentView addSubview:self.tipLab];
    [self.contentView addSubview:self.imageBgV];
    
    [self.contentView.layer addSublayer:self.lineV];
    [self.contentView addSubview:self.viewsLab];
    [self.contentView addSubview:self.repliesLab];
    [self.contentView addSubview:self.priceLab];
    [self.contentView.layer addSublayer:self.sepLine];
    
}

- (void)setInfo:(ThreadListModel *)info {
    
    _info = info;
    
    for (UIView *iv in self.imageBgV.subviews) {
        [iv removeFromSuperview];
    }
    
    self.tipIcon.hidden = NO;
    NSString *gradestr = @"";
    
    if ([DataCheck isValidString:info.grouptitle]) {
        gradestr = info.grouptitle;
        if ([info.grouptitle integerValue] > 0) {
            gradestr = [NSString stringWithFormat:@"Lv%@",info.grouptitle];
        }
    }
    
    if ([info.digest isEqualToString:@"1"] || [info.digest isEqualToString:@"2"] || [info.digest isEqualToString:@"3"]) {
        self.tipIcon.image = [UIImage imageNamed:@"精华"];
    } else if ([info.digest isEqualToString:@"0"]) {
        self.tipIcon.hidden = YES;
    }
    
    if ([DataCheck isValidDictionary:info.forumnames]) {
        self.tipLab.text = [NSString stringWithFormat:@"#%@",[info.forumnames objectForKey:@"name"]];
    }
    
    self.nameLab.text = info.author;
    self.grade.text = gradestr;
    
    NSString *subjectStr = info.useSubject;
    if ([info isSpecialThread]) {
        NSString *spaceCharater = @"    ";
        
        if ([DataCheck isValidString:info.typeName]) {
            NSMutableAttributedString *describe = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",subjectStr]];
            NSRange typeRange = NSMakeRange(0, info.typeName.length + 2);
            if ([subjectStr hasPrefix:spaceCharater]) {
                typeRange = NSMakeRange(spaceCharater.length, info.typeName.length + 2);
            }
            [describe addAttribute:NSForegroundColorAttributeName value:MAIN_COLLOR range:typeRange];
            self.desLab.attributedText = describe;
        } else {
            self.desLab.text = info.useSubject;
        }
    } else if ([DataCheck isValidString:info.typeName]) {
        
        NSMutableAttributedString *describe = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",subjectStr]];
        NSRange typeRange = NSMakeRange(0, info.typeName.length + 2);
        [describe addAttribute:NSForegroundColorAttributeName value:MAIN_COLLOR range:typeRange];
        self.desLab.attributedText = describe;
        
    } else {
        self.desLab.text = info.useSubject;
    }
    
    self.messageLab.text = info.message;
    self.datelineLab.text = info.dateline;
    self.viewsLab.textLab.text = info.views;
    self.viewsLab.iconV.image = [UIImage imageNamed:@"list_see"];
    self.repliesLab.textLab.text = info.replies;
    self.repliesLab.iconV.image = [UIImage imageNamed:@"list_message"];
    
    self.priceLab.textLab.text = info.recommend_add;
    
    self.priceLab.iconV.image = [UIImage imageNamed:@"list_zan"];
    if ([info.recommend isEqualToString:@"1"]) {
        [self setPriceSelected];
    }
    
    UITapGestureRecognizer *recommendGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(recommendAction)];
    [self.priceLab addGestureRecognizer:recommendGes];
    if ([JudgeImageModel graphFreeModel] == NO) {
        [self.headV sd_setImageWithURL:[NSURL URLWithString:info.avatar] placeholderImage:[UIImage imageNamed:@"noavatar_small"] options:SDWebImageRetryFailed];
    }
    
    self.headV.frame = CGRectMake(15, 11, 30, 30);
    self.headV.layer.masksToBounds = YES;
    self.headV.layer.cornerRadius = CGRectGetWidth(self.headV.frame) / 2;
    
    // 名字
    CGSize maxSize = CGSizeMake(120, 30);
    CGSize textSize = [self.nameLab.text sizeWithFont:[FontSize HomecellNameFontSize16] maxSize:maxSize];
    self.nameLab.frame = CGRectMake(CGRectGetMaxX(self.headV.frame) + 10, CGRectGetMidY(self.headV.frame) - 15, textSize.width, 30);
    
    // 等级
    maxSize = CGSizeMake(100, 20);
    textSize = [self.grade.text sizeWithFont:[FontSize gradeFontSize9] maxSize:maxSize];
    if ([DataCheck isValidString:self.grade.text]) {
        self.grade.frame = CGRectMake(CGRectGetMaxX(self.nameLab.frame) + 10, CGRectGetMidY(self.nameLab.frame) - textSize.height / 2, textSize.width + 4, textSize.height);
        self.grade.layer.masksToBounds = YES;
        self.grade.layer.cornerRadius = 2;
    }
    
    self.tipIcon.frame = CGRectMake(WIDTH - 34 - 10, CGRectGetMidY(self.headV.frame) - 7, 34, 17);
    
    // 标题
    maxSize = CGSizeMake(WIDTH - 30, 45);
    textSize = [self.desLab.text sizeWithFont:[FontSize HomecellTitleFontSize15] maxSize:maxSize];
    self.sepLine.frame = CGRectMake(0, CGRectGetMaxY(self.headV.frame) + 8, WIDTH, 1);
    self.desLab.frame = CGRectMake(CGRectGetMinX(self.headV.frame), CGRectGetMaxY(self.sepLine.frame) + 10, WIDTH - 30, textSize.height);
    
    // 内容
    maxSize = CGSizeMake(WIDTH - 30, 40);
    textSize = [self.messageLab.text sizeWithFont:[FontSize messageFontSize14] maxSize:maxSize];
    self.messageLab.frame = CGRectMake(CGRectGetMinX(self.desLab.frame), CGRectGetMaxY(self.desLab.frame) + 8, WIDTH - 30, textSize.height);
    
    if ([DataCheck isValidString:self.messageLab.text]) {
        // 时间
        self.datelineLab.frame = CGRectMake(CGRectGetMinX(self.desLab.frame), CGRectGetMaxY(self.messageLab.frame) + 8, 150, 15);
    } else {
        // 时间
        self.datelineLab.frame = CGRectMake(CGRectGetMinX(self.desLab.frame), CGRectGetMaxY(self.desLab.frame) + 10, 150, 15);
    }
    
    
    self.tipLab.frame = CGRectMake(WIDTH - 130, CGRectGetMinY(self.datelineLab.frame), 120, 15);
    
    NSInteger count = (info.imglist.count > 3)?3:info.imglist.count;
    
    if (count > 0 && [JudgeImageModel graphFreeModel] == NO) { // 有附件图片的, 有图模式的
        CGFloat picWidth = (WIDTH - 30 - 20) / 3;
        self.imageBgV.frame = CGRectMake(0, CGRectGetMaxY(self.datelineLab.frame), WIDTH, 90);
        
        for (int i = 0; i < count; i ++) {
            UIImageView *imageV = [[UIImageView alloc] init];
            imageV.backgroundColor = [UIColor groupTableViewBackgroundColor];
//            [imageV sd_setShowActivityIndicatorView:YES];
//            [imageV sd_setIndicatorStyle:UIActivityIndicatorViewStyleGray];
            [self.imageBgV addSubview:imageV];
//            imageV.image = [UIImage imageNamed:[NSString stringWithFormat:@"phod_%d",i + 1]];
            
            if ([DataCheck isValidString:info.imglist[i]]) {
                NSString *imageSrc = info.imglist[i];
                imageSrc = [imageSrc makeDomain];
                [imageV sd_setImageWithURL:[NSURL URLWithString:imageSrc]placeholderImage:[UIImage imageNamed:@"wutu"] options:SDWebImageRetryFailed];
            } else if ([DataCheck isValidDictionary:info.imglist[i]]) {
                NSDictionary *imgDic = info.imglist[i];
                NSString *imageSrc = [imgDic objectForKey:@"src"];
                imageSrc = [imageSrc makeDomain];
                [imageV sd_setImageWithURL:[NSURL URLWithString:imageSrc] placeholderImage:[UIImage imageNamed:@"wutu"] options:SDWebImageRetryFailed];
            }
            imageV.clipsToBounds = YES;
            imageV.contentMode = UIViewContentModeScaleAspectFill;
            
            imageV.frame = CGRectMake(15 + (picWidth + 10) * i, 10, picWidth, CGRectGetHeight(self.imageBgV.frame) - 10);
        }
    } else {
        self.imageBgV.frame = CGRectMake(0, CGRectGetMaxY(self.datelineLab.frame), WIDTH, 0);
    }
    
    self.lineV.frame = CGRectMake(0, CGRectGetMaxY(self.imageBgV.frame) + 10, WIDTH, 1);
    self.viewsLab.frame = CGRectMake(0, CGRectGetMaxY(self.lineV.frame), WIDTH / 3, 40);
    self.repliesLab.frame = CGRectMake(CGRectGetMaxX(self.viewsLab.frame), CGRectGetMinY(self.viewsLab.frame), CGRectGetWidth(self.viewsLab.frame), CGRectGetHeight(self.viewsLab.frame));
    self.priceLab.frame = CGRectMake(CGRectGetMaxX(self.repliesLab.frame), CGRectGetMinY(self.repliesLab.frame), CGRectGetWidth(self.repliesLab.frame), CGRectGetHeight(self.viewsLab.frame));
    
}

- (void)setPriceSelected {
    self.priceLab.iconV.image = [UIImage imageTintColorWithName:@"list_zans" andImageSuperView:self.priceLab.iconV];
}


- (void)recommendAction {
    
    if ([self.info.recommend isEqualToString:@"1"]) {
        [MBProgressHUD showInfo:@"您已赞过该主题"];
    } else {
        
        if ([LoginModule isLogged]) {
            
            self.info.recommend = @"1";
            self.info.recommend_add = [NSString stringWithFormat:@"%ld",[self.info.recommend_add integerValue] + 1];
            [self setPriceSelected];
            self.priceLab.iconV.tintColor = MAIN_COLLOR;
            self.priceLab.textLab.text = self.info.recommend_add;
            [PraiseHelper praiseRequestTid:self.info.tid successBlock:^{
                if (self.info.isRecently) {
                    BACK(^{
                        if ([DataCheck isValidString:self.info.tid]) {
                            [[DatabaseHandle defaultDataHelper] footThread:self.info];
                        }
                    });
                }
            } failureBlock:^(NSError *error) {
                [self resetPraise];
            }];
        }
        
    }
}

- (void)resetPraise {
    self.info.recommend = @"0";
    self.info.recommend_add = [NSString stringWithFormat:@"%ld",[self.info.recommend_add integerValue] - 1];
    self.priceLab.iconV.image = [UIImage imageNamed:@"list_zan"];
    self.priceLab.textLab.text = self.info.recommend_add;
}

- (CGFloat)cellHeight {
    
    return CGRectGetMaxY(self.priceLab.frame) + 5;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

// MARK: - 懒加载

- (UIImageView *)headV {
    if (_headV == nil) {
        _headV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"noavatar_small"]];
        _headV.userInteractionEnabled = YES;
    }
    return _headV;
}

- (UILabel *)nameLab {
    if (_nameLab == nil) {
        _nameLab = [[UILabel alloc] init];
        _nameLab.font = [FontSize HomecellNameFontSize16];
        _nameLab.textColor = LIGHT_TEXT_COLOR;
    }
    return _nameLab;
}

- (UILabel *)grade {
    if (_grade == nil) {
        _grade = [[UILabel alloc] init];
        _grade.font = [FontSize gradeFontSize9];
        _grade.textAlignment = NSTextAlignmentCenter;
        _grade.textColor = NAVI_BAR_COLOR;
        _grade.backgroundColor = MAIN_COLLOR;
    }
    return _grade;
}

- (UIImageView *)tipIcon {
    if (_tipIcon == nil) {
        _tipIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"热门"]];
    }
    return _tipIcon;
}

- (UILabel *)desLab {
    if (_desLab == nil) {
        _desLab = [[UILabel alloc] init];
        _desLab.font = [FontSize HomecellTitleFontSize15];
        _desLab.textColor = MAIN_TITLE_COLOR;
        _desLab.textAlignment = NSTextAlignmentLeft;
        _desLab.numberOfLines = 0;
    }
    return _desLab;
}

- (UILabel *)messageLab {
    if (_messageLab == nil) {
        _messageLab = [[UILabel alloc] init];
        _messageLab.font = [FontSize messageFontSize14];
        _messageLab.textColor = MESSAGE_COLOR;
        _messageLab.textAlignment = NSTextAlignmentLeft;
        _messageLab.numberOfLines = 0;
    }
    return _messageLab;
}

- (UILabel *)datelineLab {
    if (_datelineLab == nil) {
        _datelineLab = [[UILabel alloc] init];
        _datelineLab.font = [FontSize HomecellTimeFontSize14];
        _datelineLab.textColor = LIGHT_TEXT_COLOR;
    }
    return _datelineLab;
}

- (UILabel *)tipLab {
    if (_tipLab == nil) {
        _tipLab = [[UILabel alloc] init];
        _tipLab.font = [FontSize HomecellTimeFontSize14];
        _tipLab.textColor = LIGHT_TEXT_COLOR;
        _tipLab.textAlignment = NSTextAlignmentRight;
    }
    return _tipLab;
}

- (HomeIconTextView *)viewsLab {
    if (_viewsLab == nil) {
        _viewsLab = [[HomeIconTextView alloc] init];;
        _viewsLab.backgroundColor = [UIColor whiteColor];
    }
    return _viewsLab;
}

- (HomeIconTextView *)repliesLab {
    if (_repliesLab == nil) {
        _repliesLab = [[HomeIconTextView alloc] init];
        _repliesLab.backgroundColor = [UIColor whiteColor];
    }
    return _repliesLab;
}

- (HomeIconTextView *)priceLab {
    if (_priceLab == nil) {
        _priceLab = [[HomeIconTextView alloc] init];
        _priceLab.backgroundColor = [UIColor whiteColor];
    }
    return _priceLab;
}

- (CALayer *)lineV {
    if (_lineV == nil) {
        _lineV = [[CALayer alloc] init];
        _lineV.backgroundColor = LINE_COLOR.CGColor;
    }
    return _lineV;
}

- (UIView *)imageBgV {
    if (_imageBgV == nil) {
        _imageBgV = [[UIView alloc] init];
    }
    return _imageBgV;
}

- (CALayer *)sepLine {
    if (_sepLine == nil) {
        _sepLine = [[CALayer alloc] init];
        _sepLine.backgroundColor = LINE_COLOR.CGColor;
    }
    return _sepLine;
}


@end
