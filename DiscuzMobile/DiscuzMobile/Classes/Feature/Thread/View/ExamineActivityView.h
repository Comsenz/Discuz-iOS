//
//  ExamineActivityView.h
//  DiscuzMobile
//
//  Created by HB on 2017/7/28.
//  Copyright © 2017年 comsenz-service.com.  All rights reserved.
//

#import "BaseFloatingView.h"
#import "ApplyActiver.h"

@interface ExamineActivityView : BaseFloatingView

@property (nonatomic, strong) ApplyActiver *dataModel;
@property (nonatomic, strong) UIButton *allowBtn;
@property (nonatomic, strong) UIButton *rejectBtn;

@property (nonatomic, strong) NSString *reason;

@end
