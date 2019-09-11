//
//  ActiveExtendCell.m
//  DiscuzMobile
//
//  Created by HB on 2017/7/27.
//  Copyright © 2017年 comsenz-service.com.  All rights reserved.
//

#import "ActiveExtendCell.h"
#import "UUDatePicker.h"

@implementation ActiveExtendCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupViews];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setupViews {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    UILabel *placeLable = [[UILabel alloc] initWithFrame:CGRectMake(15, 20, 70, 15)];
    placeLable.text = @"消耗积分：";
    placeLable.font = [FontSize forumtimeFontSize14];
    [self.contentView addSubview:placeLable];
    
    UILabel * lineLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(15, 52, WIDTH-25, 1)];
    lineLabel1.backgroundColor = LINE_COLOR;
    [self.contentView addSubview:lineLabel1];
    
    
    self.integralTextfield =[[UITextField alloc] initWithFrame:CGRectMake(placeLable.frame.size.width +placeLable.frame.origin.x +10, 5, WIDTH - 95, 45)];
    self.integralTextfield.placeholder = @"活动参与需要消耗的积分";
    self.integralTextfield.font = [FontSize forumtimeFontSize14];
    [self.contentView addSubview:self.integralTextfield];
    
    
    UILabel *cityLable = [[UILabel alloc] initWithFrame:CGRectMake(15, lineLabel1.frame.origin.y + 20, 70, 15)];
    cityLable.text = @"每人花销：";
    cityLable.font = [FontSize forumtimeFontSize14];
    [self.contentView addSubview:cityLable];
    self.costTextfield =[[UITextField alloc] initWithFrame:CGRectMake(placeLable.frame.size.width +placeLable.frame.origin.x +10,lineLabel1.frame.origin.y + lineLabel1.frame.size.height + 5, WIDTH - 95, 45)];
    self.costTextfield.font = [FontSize forumtimeFontSize14];
    self.costTextfield.placeholder = @"元";
    [self.contentView addSubview:self.costTextfield];
    UILabel *lineLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(15, 52*2, WIDTH-25, 1)];
    lineLabel2.backgroundColor = LINE_COLOR;
    [self.contentView addSubview:lineLabel2];
    
    
    
    UILabel * placeLable3 = [[UILabel alloc] initWithFrame:CGRectMake(15, lineLabel2.frame.origin.y + 20, 70, 15)];
    placeLable3.text = @"报名截止：";
    placeLable3.font = [FontSize forumtimeFontSize14];
    [self.contentView addSubview:placeLable3];
    
    self.signupEndTextfield =[[UITextField alloc] initWithFrame:CGRectMake(cityLable.frame.size.width +cityLable.frame.origin.x +10,lineLabel2.frame.origin.y + lineLabel2.frame.size.height + 5, WIDTH-100-120, 45)];
    //    self.classTextField.backgroundColor = [UIColor redColor];
    self.signupEndTextfield.placeholder = @"报名截止时间";
    self.signupEndTextfield.font = [FontSize forumtimeFontSize14];
    [self.contentView addSubview:self.signupEndTextfield];
    
    UILabel * lineLabel3 = [[UILabel alloc] initWithFrame:CGRectMake(15, 52*3, WIDTH-25, 1)];
    lineLabel3.backgroundColor = LINE_COLOR;
    [self.contentView addSubview:lineLabel3];
    
    [self createUUDataPicler];
}

// 创建时间表
-(void)createUUDataPicler {
    
    //block
    NSArray *txfAry=[[NSArray alloc]initWithObjects:self.signupEndTextfield, nil];
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
        
        datePicker.minLimitDate = [NSDate date];
        
        field.inputView = datePicker;
    }
}


@end
