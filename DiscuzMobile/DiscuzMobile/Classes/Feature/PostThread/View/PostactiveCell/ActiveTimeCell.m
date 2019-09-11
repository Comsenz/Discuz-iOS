//
//  ActiveTimeCell.m
//  DiscuzMobile
//
//  Created by HB on 16/11/30.
//  Copyright © 2016年 comsenz-service.com.  All rights reserved.
//

#import "ActiveTimeCell.h"

@interface ActiveTimeCell()

@property (nonatomic,strong) UILabel *startLabel;
@property (nonatomic,strong) UIView *lineView;
@property (nonatomic,strong) UILabel *endLabel;


@end

@implementation ActiveTimeCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self p_setupViews];
    }
    return self;
}

- (void)p_setupViews {
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.postImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 76, CGRectGetHeight(self.frame) - 30)];
//    self.postImageView.clipsToBounds = YES;
//    self.postImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.postImageView.image = [UIImage imageNamed:@"postImage"];
    self.postImageView.userInteractionEnabled = YES;
    [self.contentView addSubview:self.postImageView];
    
    _startLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.postImageView.frame) + 10, CGRectGetMinY(self.postImageView.frame) + 10, 80, 15)];
    _startLabel.attributedText = [@"开始时间:" getAttributeStr];
    
    _startLabel.font = [FontSize forumtimeFontSize14];
    [self.contentView addSubview:_startLabel];
    
    self.beginTimeField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_startLabel.frame), CGRectGetMinY(_startLabel.frame), CGRectGetWidth(self.frame) - 180, 45)];
    self.beginTimeField.placeholder = @"请输入开始时间";
    self.beginTimeField.font = [FontSize forumtimeFontSize14];
    [self.contentView addSubview:self.beginTimeField];
    
    _lineView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.postImageView.frame) + 10, CGRectGetMaxY(self.beginTimeField.frame), CGRectGetWidth(self.frame) - 150, 1)];
    _lineView.backgroundColor = LINE_COLOR;
    [self.contentView addSubview:_lineView];
    
    _endLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(_startLabel.frame), CGRectGetMaxY(_lineView.frame) + 10, 80, CGRectGetHeight(_startLabel.frame))];
    _endLabel.attributedText = [@"结束时间:" getAttributeStr];
    _endLabel.font = [FontSize forumtimeFontSize14];
    
    [self.contentView addSubview:_endLabel];
    
    self.endTimeField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.beginTimeField.frame), CGRectGetMinY(_endLabel.frame) - 15, CGRectGetWidth(self.beginTimeField.frame), CGRectGetHeight(self.beginTimeField.frame))];
    self.endTimeField.font = [FontSize forumtimeFontSize14];
    self.endTimeField.placeholder = @"请输入结束时间";
    self.endTimeField.tag = 801;
    [self.contentView addSubview:self.endTimeField];
    [self createUUDataPicler];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.postImageView.frame = CGRectMake(15, 15, 76, CGRectGetHeight(self.frame) - 30);
    self.startLabel.frame = CGRectMake(CGRectGetMaxX(self.postImageView.frame) + 10, CGRectGetMinY(self.postImageView.frame) + 10, 80, 15);
    self.beginTimeField.frame = CGRectMake(CGRectGetMaxX(_startLabel.frame), CGRectGetMinY(_startLabel.frame) - 15, CGRectGetWidth(self.frame) - 180, 45);
    self.lineView.frame = CGRectMake(CGRectGetMaxX(self.postImageView.frame) + 10, CGRectGetMaxY(self.beginTimeField.frame), CGRectGetWidth(self.frame) - 80, 1);
    self.endLabel.frame = CGRectMake(CGRectGetMinX(_startLabel.frame), CGRectGetMaxY(_lineView.frame) + 10, 80, CGRectGetHeight(_startLabel.frame));
    self.endTimeField.frame = CGRectMake(CGRectGetMinX(self.beginTimeField.frame), CGRectGetMinY(_endLabel.frame) - 15, CGRectGetWidth(self.beginTimeField.frame), CGRectGetHeight(self.beginTimeField.frame));
    
}

// 创建时间表
-(void)createUUDataPicler {
    
    //block
    NSArray *txfAry=[[NSArray alloc]initWithObjects:self.beginTimeField, self.endTimeField,nil];
    int a[2] = {0,0};
    for (int i=0; i<txfAry.count; i++) {
        
        UITextField * field = txfAry[i];
        UUDatePicker *dpicket = [[UUDatePicker alloc] init];
        dpicket.datePickerStyle = a[i];
//        dpicket.
        
        UUDatePicker * datePicker = [[UUDatePicker alloc]initWithframe:CGRectMake(0, 0, 400, 216) PickerStyle:a[i] didSelected:^(NSString *year,
                                               NSString *month,
                                               NSString *day,
                                               NSString *hour,
                                               NSString *minute,
                                               NSString *weekDay) {
                                     switch (i) {
                                         case 0:
                                             field.text = [NSString stringWithFormat:@"%@-%@-%@ %@:%@",year,month,day,hour,minute];
                                             break;
                                         case 1:
                                             field.text = [NSString stringWithFormat:@"%@-%@-%@ %@:%@",year,month,day,hour,minute];
                                             //                                             field.text = [NSString stringWithFormat:@"%@-%@-%@",year,month,day];
                                             break;
                                         case 2:
                                             field.text = [NSString stringWithFormat:@"%@-%@ %@:%@",month,day,hour,minute];
                                             break;
                                         case 3:
                                             field.text = [NSString stringWithFormat:@"%@:%@",hour,minute];
                                             break;
                                         case 4:
                                             field.text = [NSString stringWithFormat:@"%@-%@-%@ %@:%@",year,month,day,hour,minute];
                                             break;
                                         case 5:
                                             field.text = [NSString stringWithFormat:@"%@-%@-%@ %@:%@",year,month,day,hour,minute];
                                             break;
                                         default:
                                             break;
                                     }
                                 }];
        
        if (i == 1) {
            datePicker.minLimitDate = [NSDate date];
        }
        
        field.inputView = datePicker;
    }
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
