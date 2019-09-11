//
//  VoteSelectCell.h
//  DiscuzMobile
//
//  Created by HB on 16/11/30.
//  Copyright © 2016年 comsenz-service.com.  All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QRadioButton.h"

@interface VoteSelectCell : UITableViewCell

@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) QRadioButton *singleRadio;
@property (nonatomic, strong) QRadioButton *multiRadio;

@end
