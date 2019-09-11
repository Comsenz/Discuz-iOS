//
//  PartInPayCell.h
//  DiscuzMobile
//
//  Created by HB on 2017/8/4.
//  Copyright © 2017年 comsenz-service.com.  All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QRadioButton.h"

@interface PartInPayCell : UITableViewCell

@property (nonatomic, strong) UILabel *tipLab;
@property (nonatomic, strong) UILabel *tipLab2;
@property (nonatomic, strong) QRadioButton *selfRadio;
@property (nonatomic, strong) UILabel *selfpayLab;
@property (nonatomic, strong) QRadioButton *payRadio;
@property (nonatomic, strong) UITextField *payTextField;
@property (nonatomic, strong) UILabel *yuanLab;

@end
