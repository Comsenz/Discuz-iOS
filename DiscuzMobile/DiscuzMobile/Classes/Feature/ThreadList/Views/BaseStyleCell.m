//
//  BaseStyleCell.m
//  DiscuzMobile
//
//  Created by piter on 2018/1/25.
//  Copyright © 2018年 comsenz-service.com.  All rights reserved.
//

#import "BaseStyleCell.h"
#import "HomeIconTextView.h"
#import "LoginModule.h"
#import "UIView+WebCache.h"
#import "PraiseHelper.h"
#import "LoginController.h"
#import "JudgeImageModel.h"

@interface BaseStyleCell()

@property (nonatomic, strong) UIView *lineV;
@property (nonatomic, strong) UIView *imageBgV;
@property (nonatomic, strong) UIView *sepLine;

@end

@implementation BaseStyleCell
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
    
    [self.contentView addSubview:self.lineV];
    [self.contentView addSubview:self.viewsLab];
    [self.contentView addSubview:self.repliesLab];
    [self.contentView addSubview:self.priceLab];
    [self.contentView addSubview:self.sepLine];
    
    [self.headV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(15);
        make.top.equalTo(self).offset(11);
        make.size.mas_equalTo(CGSizeMake(30,30));
    }];
    
    // 名字
    self.nameLab.preferredMaxLayoutWidth = 120;
    [self.nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headV.mas_right).offset(10);
        make.centerY.equalTo(self.headV);
        make.height.mas_equalTo(30);
        
    }];
    
    // 等级
    self.grade.preferredMaxLayoutWidth = 100;
    self.grade.numberOfLines = 1;
    [self.grade mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLab.mas_right).offset(10);
        make.centerY.equalTo(self.nameLab);
    }];
    
    [self.tipIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-10);
        make.centerY.equalTo(self.headV);
        make.size.mas_equalTo(CGSizeMake(34, 17));
    }];
    
    
    
    [self.sepLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.width.equalTo(self);
        make.top.equalTo(self.headV.mas_bottom).offset(10);
        make.height.equalTo(@1);
    }];
    
    // 标题
    self.desLab.preferredMaxLayoutWidth = WIDTH - 30;
    self.desLab.numberOfLines = 2;
    [self.desLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headV);
        make.top.equalTo(self.sepLine.mas_bottom).offset(10);
    }];
    
    
    // 内容
    self.messageLab.preferredMaxLayoutWidth = WIDTH - 30;
     self.messageLab.numberOfLines = 2;
    [self.messageLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.desLab);
        make.top.equalTo(self.desLab.mas_bottom).offset(8);
    }];
    
    // 时间
    [self.datelineLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.desLab);
        make.top.equalTo(self.desLab.mas_bottom).offset(10);
        make.size.mas_equalTo(CGSizeMake(150, 15));
    }];
    // 显示板块名
    [self.tipLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-10);
        make.top.equalTo(self.datelineLab);
        make.size.mas_equalTo(CGSizeMake(120, 15));
    }];
    
    
    [self.imageBgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.width.mas_equalTo(WIDTH);
        make.top.equalTo(self.datelineLab.mas_bottom);
        make.height.equalTo(@90);
    }];
    
    [self.lineV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.width.equalTo(self);
        make.height.equalTo(@1);
        make.top.equalTo(self.imageBgV.mas_bottom).offset(10);
    }];
    
    [self.viewsLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.width.equalTo(@(WIDTH/3));
        make.top.equalTo(self.lineV.mas_bottom);
        make.height.equalTo(@40);
    }];
    
    [self.repliesLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(self.viewsLab);
        make.left.equalTo(self.viewsLab.mas_right);
        make.top.equalTo(self.viewsLab);
    }];
    
    [self.priceLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(self.viewsLab);
        make.left.equalTo(self.repliesLab.mas_right);
        make.top.equalTo(self.viewsLab);
    }];
}

- (void)setInfo:(ThreadListModel *)info {
    
    _info = info;
    
    self.tipIcon.hidden = NO;
    NSString *gradestr = @"";
    
    if ([DataCheck isValidString:info.grouptitle]) {
        gradestr = [NSString stringWithFormat:@" %@ ",info.grouptitle];
        if ([info.grouptitle integerValue] > 0) {
            gradestr = [NSString stringWithFormat:@" Lv%@ ",info.grouptitle];
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
    
    UITapGestureRecognizer *recommendGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(recommendAction:)];
    [self.priceLab addGestureRecognizer:recommendGes];
    if ([JudgeImageModel graphFreeModel] == NO) {
        [self.headV sd_setImageWithURL:[NSURL URLWithString:info.avatar] placeholderImage:[UIImage imageNamed:@"noavatar_small"] options:SDWebImageRetryFailed];
    }
    
    if ([DataCheck isValidString:self.messageLab.text]) {
        [self.datelineLab mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.desLab);
            make.top.equalTo(self.messageLab.mas_bottom).offset(8);
            make.size.mas_equalTo(CGSizeMake(150, 15));
        }];
        
    } else {
        [self.datelineLab mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.desLab);
            make.top.equalTo(self.desLab.mas_bottom).offset(10);
            make.size.mas_equalTo(CGSizeMake(150, 15));
        }];
    }
    
    for (UIView *iv in self.imageBgV.subviews) {
        [iv removeFromSuperview];
    }
    
    NSInteger count = (info.imglist.count > 3)?3:info.imglist.count;
    
    if (count > 0 && [JudgeImageModel graphFreeModel] == NO) { // 有附件图片的, 有图模式的
        CGFloat picWidth = (WIDTH - 30 - 20) / 3;
        
        [self.imageBgV mas_updateConstraints:^(MASConstraintMaker *make) {
             make.height.equalTo(@90);
        }];
        
        UIView *lastView = self;
        for (int i = 0; i < count; i ++) {
            UIImageView *imageV = [[UIImageView alloc] init];
            imageV.backgroundColor = [UIColor groupTableViewBackgroundColor];
            //            [imageV sd_setShowActivityIndicatorView:YES];
            //            [imageV sd_setIndicatorStyle:UIActivityIndicatorViewStyleGray];
            [self.imageBgV addSubview:imageV];
            
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
            
            [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
                if (![lastView isKindOfClass:[UIImageView class]]) {
                    make.left.equalTo(lastView).offset(15);
                } else {
                    make.left.equalTo(lastView.mas_right).offset(10);
                }
                
                make.top.equalTo(self.imageBgV.mas_top).offset(10);
                make.width.mas_equalTo(picWidth);
                make.bottom.equalTo(self.imageBgV);
            }];
            lastView = imageV;
        }
    } else {
        
        [self.imageBgV mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@0);
        }];
    }
    
    [self layoutIfNeeded];
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.headV.layer.masksToBounds = YES;
    self.headV.layer.cornerRadius = CGRectGetWidth(self.headV.frame) / 2;
    self.grade.layer.masksToBounds = YES;
    self.grade.layer.cornerRadius = 2;
}

- (void)setPriceSelected {
    self.priceLab.iconV.image = [UIImage imageTintColorWithName:@"list_zans" andImageSuperView:self.priceLab.iconV];
}


- (void)recommendAction:(UIGestureRecognizer *)sender {
    
    if (![LoginModule isLogged]) {
        UIViewController *controller = [self jtGetViewController];
        LoginController *loginVc = [[LoginController alloc] init];
        loginVc.isKeepTabbarSelected = YES;
        UINavigationController *navVc = [[UINavigationController alloc] initWithRootViewController:loginVc];
        [controller presentViewController:navVc animated:YES completion:nil];
        return;
    }
    
    if ([self.info.recommend isEqualToString:@"1"]) {
        [MBProgressHUD showInfo:@"您已赞过该主题"];
        
    } else {
        sender.enabled = NO;
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
        } failureBlock:^(NSError *error){
            [self resetPraise];
        }];
    }
}

- (void)resetPraise {
    self.info.recommend = @"0";
    self.info.recommend_add = [NSString stringWithFormat:@"%ld",[self.info.recommend_add integerValue] - 1];
    self.priceLab.iconV.image = [UIImage imageNamed:@"list_zan"];
    self.priceLab.textLab.text = self.info.recommend_add;
}

- (CGFloat)cellHeight {
    // 立即产生frame， 这里不需要，上面代码已经产生了;
//    [self layoutIfNeeded];
    return CGRectGetMaxY(self.priceLab.frame) + 5;
}

- (CGFloat)caculateCellHeight:(ThreadListModel *)info {
    self.info = info;
    return [self cellHeight];
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

- (UIView *)lineV {
    if (_lineV == nil) {
        _lineV = [[UIView alloc] init];
        _lineV.backgroundColor = LINE_COLOR;
    }
    return _lineV;
}

- (UIView *)imageBgV {
    if (_imageBgV == nil) {
        _imageBgV = [[UIView alloc] init];
    }
    return _imageBgV;
}

- (UIView *)sepLine {
    if (_sepLine == nil) {
        _sepLine = [[UIView alloc] init];
        _sepLine.backgroundColor = LINE_COLOR;
    }
    return _sepLine;
}

@end
