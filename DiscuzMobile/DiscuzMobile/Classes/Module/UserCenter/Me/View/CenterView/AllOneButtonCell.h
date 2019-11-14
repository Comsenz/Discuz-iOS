//
//  AllOneButtonCell.h
//  DiscuzMobile
//
//  Created by HB on 16/12/1.
//  Copyright © 2016年 comsenz-service.com.  All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^BtnActionBlock)(UIButton *sender);

@interface AllOneButtonCell : UITableViewCell

@property (nonatomic, strong) UIButton *ActionBtn;

@property (nonatomic, copy) BtnActionBlock actionBlock;

@end
