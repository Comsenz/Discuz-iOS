//
//  ActivityApplyCell.m
//  DiscuzMobile
//
//  Created by HB on 2017/7/28.
//  Copyright © 2017年 comsenz-service.com.  All rights reserved.
//

#import "ActivityApplyCell.h"
#import "ApplyStatusView.h"

@interface ActivityApplyCell()

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) UIView *line1;
@property (nonatomic, strong) UIView *line2;

@end

@implementation ActivityApplyCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self commitInit];
    }
    
    return self;
}

- (void)commitInit {
    self.contentView.backgroundColor = mRGBColor(249, 251, 253);
    
    self.bgView = [[UIView alloc] initWithFrame:CGRectMake(15, 10, WIDTH - 30, CGRectGetHeight(self.frame)- 10)];
    self.bgView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.bgView];
    
    self.applyLab = [[ApplyItemView alloc] initWithFrame:CGRectMake(0, 0, (CGRectGetWidth(self.bgView.frame) - 2) / 3, CGRectGetHeight(self.bgView.frame))];
    self.applyLab.tipLab.text = @"申请者";
    [self.bgView addSubview:self.applyLab];
    
    self.line1 = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.applyLab.frame), 8, 1, CGRectGetHeight(self.bgView.frame) - 16)];
    self.line1.backgroundColor = LINE_COLOR;
    [self.bgView addSubview:self.line1];
    
    self.timeLab = [[ApplyItemView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.line1.frame), 0, CGRectGetWidth(self.applyLab.frame), CGRectGetHeight(self.bgView.frame))];
    self.timeLab.tipLab.text = @"申请时间";
    [self.bgView addSubview:self.timeLab];
    
    self.line2 = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.timeLab.frame), 8, 1, CGRectGetHeight(self.bgView.frame) - 16)];
    self.line2.backgroundColor = LINE_COLOR;
    [self.bgView addSubview:self.line2];
    
    self.statusView = [[ApplyItemView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.line2.frame), 0, CGRectGetWidth(self.applyLab.frame), CGRectGetHeight(self.bgView.frame))];
    self.statusView.tipLab.text = @"状态";
    [self.bgView addSubview:self.statusView];
}

- (void)setInfo:(ApplyActiver *)model {
    self.applyLab.infoLab.statusLab.text = model.username;
    self.timeLab.infoLab.statusLab.text = model.dateline;
    
    NSString *status = @"尚未审核";
    if ([model.verified isEqualToString:@"1"]) {
        status = @"允许参加";
    } else if ([model.verified isEqualToString:@"2"]) {
        status = @"等待完善";
    }
    
    [self.statusView.infoLab setStatusText:status];
    
//    self.statusView.infoLab.statusLab.text = status;
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    self.bgView.frame = CGRectMake(15, 10, WIDTH - 30, CGRectGetHeight(self.frame)- 10);
    self.bgView.layer.borderColor = LINE_COLOR.CGColor;
    self.bgView.layer.borderWidth = 1;
    self.bgView.layer.masksToBounds = YES;
    self.bgView.layer.cornerRadius = 4;
    
    self.applyLab.frame = CGRectMake(0, 0, (CGRectGetWidth(self.bgView.frame) - 2) / 3, CGRectGetHeight(self.bgView.frame));
    self.line1.frame = CGRectMake(CGRectGetMaxX(self.applyLab.frame), 10, 1, CGRectGetHeight(self.bgView.frame) - 20);
    self.timeLab.frame = CGRectMake(CGRectGetMaxX(self.line1.frame), 0, CGRectGetWidth(self.applyLab.frame), CGRectGetHeight(self.bgView.frame));
    self.line2.frame = CGRectMake(CGRectGetMaxX(self.timeLab.frame), 10, 1, CGRectGetHeight(self.bgView.frame) - 20);
    self.statusView.frame = CGRectMake(CGRectGetMaxX(self.line2.frame), 0, CGRectGetWidth(self.applyLab.frame), CGRectGetHeight(self.bgView.frame));
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
