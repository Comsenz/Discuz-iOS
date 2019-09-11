//
//  EndtimeCell.m
//  DiscuzMobile
//
//  Created by HB on 2017/6/23.
//  Copyright © 2017年 comsenz-service.com.  All rights reserved.
//

#import "EndtimeCell.h"
#import "UUDatePicker.h"

@implementation EndtimeCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self commitInit];
    }
    return self;
}

- (void)commitInit {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.contentView addSubview:self.titleLab];
    [self.contentView addSubview:self.selectBtn];
    [self.contentView addSubview:self.contentTextfield];
//    self.contentTextfield.rightView = self.selectBtn;
    
    [self createUUDataPicler];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.titleLab.frame = CGRectMake(10, 10, 60, 35);
    self.contentTextfield.frame = CGRectMake(CGRectGetMaxX(self.titleLab.frame) + 8, CGRectGetMinY(self.titleLab.frame), WIDTH - 20 - CGRectGetWidth(self.titleLab.frame) - 8 , CGRectGetHeight(self.titleLab.frame));
    self.selectBtn.frame = CGRectMake(CGRectGetMaxX(self.contentTextfield.frame) -  36, 6, 36, 36);
}

// 创建时间表
-(void)createUUDataPicler {
    
    //block
    NSArray *txfAry=[[NSArray alloc] initWithObjects:self.contentTextfield,nil];
    int a[2] = {0,0};
    for (int i=0; i<txfAry.count; i++) {
        
        UITextField * field = txfAry[i];
        UUDatePicker * datePicker = [[UUDatePicker alloc] initWithframe:CGRectMake(0, 0, 400, 216) PickerStyle:a[i] didSelected:^(NSString *year,
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
        
        field.inputView = datePicker;
    }
}

- (UILabel *)titleLab {
    if (_titleLab == nil) {
        _titleLab = [[UILabel alloc] init];
        _titleLab.text = @"结束时间";
        _titleLab.font = [FontSize forumtimeFontSize14];
        _titleLab.textAlignment = NSTextAlignmentLeft;
    }
    return _titleLab;
}

- (UITextField *)contentTextfield {
    if (_contentTextfield == nil) {
        _contentTextfield = [[UITextField alloc] init];
        _contentTextfield.placeholder = @"请选择时间";
        _contentTextfield.font = [FontSize HomecellTitleFontSize15];
    }
    return _contentTextfield;
}

- (UIButton *)selectBtn {
    if (_selectBtn == nil) {
        _selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_selectBtn setImage:[UIImage imageTintColorWithName:@"" andImageSuperView:_selectBtn] forState:UIControlStateNormal];
    }
    return _selectBtn;
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
