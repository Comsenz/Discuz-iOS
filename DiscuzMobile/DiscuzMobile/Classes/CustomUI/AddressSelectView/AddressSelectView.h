//
//  AddressSelectView.h
//  DiscuzMobile
//
//  Created by HB on 2017/8/4.
//  Copyright © 2017年 comsenz-service.com.  All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^AddressBlock)(NSString *address);

@interface AddressSelectView : UIView

@property (nonatomic, strong) UIButton *doneBtn;
@property (nonatomic, strong) UIButton *cancelBtn;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, copy) AddressBlock addressBlock;

- (void)remove;

- (void)show;

@end
