//
//  ChatContentCell.m
//  DiscuzMobile
//
//  Created by ZhangJitao on 2018/7/2.
//  Copyright © 2018年 comsenz-service.com.  All rights reserved.
//

#import "ChatContentCell.h"


@interface ChatContentCell()

@property (nonatomic, strong) UIImageView *bgImageView;

@property (nonatomic, strong) UIImageView *mcontainView;

@end

@implementation ChatContentCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initViews];
    }
    return self;
}

- (void)initViews {
    
    self.backgroundColor = [UIColor clearColor];
    self.bgImageView = [[UIImageView alloc] init];
    [self.contentView addSubview:_bgImageView];
    
    self.timeLabel = [[UILabel alloc] init];
    self.timeLabel.textColor = [UIColor lightGrayColor];
    self.timeLabel.backgroundColor = [UIColor clearColor];
    self.timeLabel.textAlignment = NSTextAlignmentCenter;
    self.timeLabel.font = [UIFont systemFontOfSize:12.0f];
    [self.contentView addSubview:self.timeLabel];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.width.equalTo(@300);
        make.height.equalTo(@15);
    }];
    
    self.headView = [[UIImageView alloc] init];
    self.headView.userInteractionEnabled = YES;
    [self.contentView addSubview:self.headView];
    [self.headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@35);
        make.top.equalTo(@25);
        make.left.equalTo(@5);
    }];
    
    
    self.mcontainView = [[UIImageView alloc] init];
    self.mcontainView.userInteractionEnabled = YES;
    [self.contentView addSubview:self.mcontainView];
    
    [self.mcontainView addSubview:self.messageLabel];
    self.messageLabel.userInteractionEnabled = YES;
    self.messageLabel.textColor = MAIN_TITLE_COLOR;
    
}

- (void)setMessageModel:(MessageModel *)messageModel {
    _messageModel = messageModel;
    
    CGFloat msgWidth = messageModel.textLayout.textBoundingSize.width;
    
    [self.headView sd_setImageWithURL:[NSURL URLWithString:self.messageModel.fromavatar] placeholderImage:[UIImage imageNamed:@"noavatar_small"] options:SDWebImageRetryFailed];
    
    self.messageLabel.attributedText = messageModel.commentAttributeText;
    self.messageLabel.textLayout= messageModel.textLayout;
    
    NSString *datelineStr = [self.messageModel.time transformationStr];
    self.timeLabel.text = datelineStr;
    
    UIImage *image;//气泡图片
    if ([self.messageModel.type isEqualToString:@"1"]) { // 收到消息
        self.headView.frame = CGRectMake(5, 25, 35, 35);
        [self.headView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@5);
        }];
        
        [self.mcontainView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.headView.mas_right);
            make.top.equalTo(@23);
            make.width.mas_equalTo(msgWidth + 30);
            make.height.mas_equalTo(messageModel.textHeight + 30);
        }];

        [self.messageLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.top.equalTo(@15);
            make.width.mas_equalTo(msgWidth);
            make.height.mas_equalTo(messageModel.textHeight);
        }];
        image = [UIImage imageNamed:@"chat_o.png"];
        
    } else {
        [self.headView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(WIDTH-10-35);
        }];
        [self.mcontainView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.headView.mas_left);
            make.top.equalTo(@23);
            make.width.mas_equalTo(msgWidth + 30);
            make.height.mas_equalTo(messageModel.textHeight + 30);
        }];
        [self.messageLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.top.equalTo(@15);
            make.width.mas_equalTo(msgWidth);
            make.height.mas_equalTo(messageModel.textHeight);
        }];
        image = [UIImage imageNamed:@"chat_m.png"];
    }
    
    self.mcontainView.image = image;
    
    [self layoutIfNeeded];
    
}


- (void)layoutSubviews {
    [super layoutSubviews];
    self.headView.layer.cornerRadius = self.headView.frame.size.width / 2;
    self.headView.layer.masksToBounds = YES;
}

- (CGFloat)cellHeight {
    CGFloat h = CGRectGetMaxY(self.mcontainView.frame) + 20;
    return h;
}

- (ChatYYLabel *)messageLabel {
    if (_messageLabel == nil) {
        _messageLabel = [[ChatYYLabel alloc] init];
        _messageLabel.userInteractionEnabled = YES;
        _messageLabel.numberOfLines = 0;
        _messageLabel.font = [FontSize HomecellNameFontSize16];
        _messageLabel.textVerticalAlignment = YYTextVerticalAlignmentCenter;
        _messageLabel.displaysAsynchronously = YES;
        _messageLabel.ignoreCommonProperties = YES;
        _messageLabel.fadeOnHighlight = NO;
        _messageLabel.fadeOnAsynchronouslyDisplay = NO;
    }
    return _messageLabel;
}

@end
