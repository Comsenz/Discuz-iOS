//
//  ActiveContentCell.h
//  DiscuzMobile
//
//  Created by HB on 16/11/30.
//  Copyright © 2016年 comsenz-service.com.  All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SelectTipView.h"

@interface ActiveContentCell : UITableViewCell

@property (nonatomic, strong) UITextField *placeTextField;
@property (nonatomic, strong) UITextField *cityTextField;
@property (nonatomic, strong) UITextField *peopleNumTextField;
@property (nonatomic, strong) UITextField *classTextField;
@property (nonatomic, strong) SelectTipView *sexSelectView;
@property (nonatomic, strong) UIButton * Dropdownbtn;
@property (nonatomic, strong) SelectTipView *classSelectView;

@property (nonatomic, strong) UIButton *nameBtn;
@property (nonatomic, strong) UIButton *phoneBtn;
@property (nonatomic, strong) UIButton *qqBtn;

@end
