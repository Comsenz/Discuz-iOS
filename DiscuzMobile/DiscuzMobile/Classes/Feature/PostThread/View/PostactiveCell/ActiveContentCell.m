//
//  ActiveContentCell.m
//  DiscuzMobile
//
//  Created by HB on 16/11/30.
//  Copyright © 2016年 comsenz-service.com.  All rights reserved.
//

#import "ActiveContentCell.h"

@implementation ActiveContentCell
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

-(void)setupViews {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UILabel *placeLable = [[UILabel alloc] initWithFrame:CGRectMake(15, 20, 70, 15)];
//    placeLable.text = @"活动地点：";
    placeLable.attributedText = [@"活动地点:" getAttributeStr];
    placeLable.font = [FontSize forumtimeFontSize14];
    [self.contentView addSubview:placeLable];
    
    UILabel * lineLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(15, 52, WIDTH-25, 1)];
    lineLabel1.backgroundColor = LINE_COLOR;
    [self.contentView addSubview:lineLabel1];
    
    
    self.placeTextField =[[UITextField alloc] initWithFrame:CGRectMake(placeLable.frame.size.width +placeLable.frame.origin.x +10, 5, WIDTH - 95, 45)];
    self.placeTextField.placeholder = @"请输入活动地点";
    self.placeTextField.font = [FontSize forumtimeFontSize14];
    [self.contentView addSubview:self.placeTextField];
    
    
    UILabel *cityLable = [[UILabel alloc] initWithFrame:CGRectMake(15, lineLabel1.frame.origin.y + 20, 70, 15)];
    cityLable.text = @"所在城市:";
    cityLable.font = [FontSize forumtimeFontSize14];
    [self.contentView addSubview:cityLable];
    self.cityTextField =[[UITextField alloc] initWithFrame:CGRectMake(cityLable.frame.size.width +cityLable.frame.origin.x +10,lineLabel1.frame.origin.y + lineLabel1.frame.size.height + 5, WIDTH - 95, 45)];
    self.cityTextField.font = [FontSize forumtimeFontSize14];
    self.cityTextField.placeholder = @"请输入所在城市";
    [self.contentView addSubview:self.cityTextField];
    UILabel *lineLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(15, 52*2, WIDTH-25, 1)];
    lineLabel2.backgroundColor = LINE_COLOR;
    [self.contentView addSubview:lineLabel2];
    
    
    
    UILabel * placeLable3 = [[UILabel alloc] initWithFrame:CGRectMake(15, lineLabel2.frame.origin.y + 20, 780, 15)];
//    placeLable3.text = @"活动类型:";
    placeLable3.attributedText = [@"活动类型:" getAttributeStr];
    placeLable3.font = [FontSize forumtimeFontSize14];
    [self.contentView addSubview:placeLable3];
    
    self.classTextField =[[UITextField alloc] initWithFrame:CGRectMake(cityLable.frame.size.width +cityLable.frame.origin.x +10,lineLabel2.frame.origin.y + lineLabel2.frame.size.height + 5, WIDTH-100-120, 45)];
    //    self.classTextField.backgroundColor = [UIColor redColor];
    self.classTextField.placeholder = @"请输入活动类型";
    self.classTextField.font = [FontSize forumtimeFontSize14];
    [self.contentView addSubview:self.classTextField];
    
    UILabel * lineLabel3 = [[UILabel alloc] initWithFrame:CGRectMake(15, 52*3, WIDTH-25, 1)];
    lineLabel3.backgroundColor = LINE_COLOR;
    [self.contentView addSubview:lineLabel3];
    
    
    UILabel * peopleNumLable = [[UILabel alloc] initWithFrame:CGRectMake(15, lineLabel3.frame.origin.y + lineLabel3.frame.size.height +20, 70, 15)];
    peopleNumLable.text = @"需要人数:";
    peopleNumLable.font = [FontSize forumtimeFontSize14];
    [self.contentView addSubview:peopleNumLable];
    
//    self.peopleNumTextField =[[UITextField alloc] initWithFrame:CGRectMake(peopleNumLable.frame.size.width +peopleNumLable.frame.origin.x +10,lineLabel3.frame.origin.y + lineLabel3.frame.size.height + 5, WIDTH - 95, 45)];
    
    CGFloat numWidth = 100;
    CGFloat numspace = 20;
    if (WIDTH == 320) {
        numWidth = 80;
        numspace = 10;
    }
    
    self.peopleNumTextField =[[UITextField alloc] initWithFrame:CGRectMake(peopleNumLable.frame.size.width +peopleNumLable.frame.origin.x +10,lineLabel3.frame.origin.y + lineLabel3.frame.size.height + 5, numWidth, 45)];
    self.peopleNumTextField.keyboardType = UIKeyboardTypeNumberPad;
    self.peopleNumTextField.placeholder = @"请输入需要人数";
    self.peopleNumTextField.font = [FontSize forumtimeFontSize14];
    [self.contentView addSubview:self.peopleNumTextField];
    
    UILabel *lineLabel4 = [[UILabel alloc] initWithFrame:CGRectMake(15, 52*4, WIDTH-25, 1)];
    lineLabel4.backgroundColor = LINE_COLOR;
    [self.contentView addSubview:lineLabel4];
    
    
//    UILabel * sexNumLable = [[UILabel alloc] initWithFrame:CGRectMake(15, lineLabel4.frame.origin.y + lineLabel4.frame.size.height +20, 70, 15)];
    UILabel * sexNumLable = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.peopleNumTextField.frame) + numspace, lineLabel3.frame.origin.y + lineLabel3.frame.size.height +20, 45, 15)];
    sexNumLable.text = @"性别:";
    sexNumLable.font = [FontSize forumtimeFontSize14];
    [self.contentView addSubview:sexNumLable];
    self.sexSelectView =[[SelectTipView alloc] initWithFrame:CGRectMake(sexNumLable.frame.size.width +sexNumLable.frame.origin.x + 5,CGRectGetMinY(self.peopleNumTextField.frame) + 5, WIDTH - numWidth - numspace - 70 - CGRectGetWidth(self.peopleNumTextField.frame), 33)];
    self.sexSelectView.layer.masksToBounds = YES;
    self.sexSelectView.layer.borderColor = LINE_COLOR.CGColor;
    self.sexSelectView.layer.borderWidth = 1;
    self.sexSelectView.layer.cornerRadius = 5;
    self.sexSelectView.tipLab.text = @"不限";
    [self.contentView addSubview:self.sexSelectView];
    
//    UILabel *lineLabel5 = [[UILabel alloc] initWithFrame:CGRectMake(15, 52*5, WIDTH-25, 1)];
//    lineLabel5.backgroundColor = LINE_COLOR;
//    [self.contentView addSubview:lineLabel5];
    
    
    self.classSelectView = [[SelectTipView alloc] initWithFrame:CGRectMake(self.classTextField.frame.size.width+self.classTextField.frame.origin.x +10,lineLabel2.frame.origin.y + lineLabel2.frame.size.height + 10, 100, 33)];
    self.classSelectView.layer.masksToBounds = YES;
    self.classSelectView.layer.borderColor = LINE_COLOR.CGColor;
    self.classSelectView.layer.borderWidth = 1;
    self.classSelectView.layer.cornerRadius = 5;
    self.classSelectView.tipLab.text = @"自定义";
    [self.contentView addSubview:self.classSelectView];
    
    
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
