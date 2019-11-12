//
//  DZAboutView.m
//  DiscuzMobile
//
//  Created by HB on 16/12/5.
//  Copyright © 2016年 comsenz-service.com.  All rights reserved.
//

#import "DZAboutView.h"
#import "DZDevice.h"

@interface DZAboutView()

@property (nonatomic, strong) UIImageView *bgImageView;

@end

@implementation DZAboutView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self p_setupViews];
    }
    
    return self;
}

- (void)p_setupViews {
    
    if (@available(iOS 11.0, *)) {
        self.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    
    self.contentSize = CGSizeMake(KScreenWidth, KScreenHeight - 63);
    self.showsVerticalScrollIndicator = NO;
    self.bgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"aboutbg"]];
    [self addSubview:self.bgImageView];
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(self);
    }];
    
    NSString *logoName = [DZDevice getIconName];
    
    self.logoView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:logoName]];
    [self.bgImageView addSubview:self.logoView];
    [self.logoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.bgImageView.mas_centerX);
        make.top.equalTo(self.bgImageView).offset(50);
        make.size.mas_equalTo(CGSizeMake(100, 100));
    }];
    self.logoView.layer.masksToBounds = YES;
    self.logoView.layer.cornerRadius = 10;
    
    self.appNameLabel = [[UILabel alloc] init];
    self.appNameLabel.font = [UIFont boldSystemFontOfSize:31.0];
    [self.bgImageView addSubview:self.appNameLabel];
    self.appNameLabel.text = DZ_APPNAME;
    self.appNameLabel.textColor = [UIColor blackColor];
    self.appNameLabel.textAlignment = NSTextAlignmentCenter;
    [self.appNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.logoView.mas_bottom).offset(30);
        make.centerX.equalTo(self.bgImageView.mas_centerX);
        make.width.equalTo(self.bgImageView);
        make.height.mas_equalTo(40);
    }];
    
    self.versiontypeLabel = [[UILabel alloc] init];
    [self.bgImageView addSubview:self.versiontypeLabel];
    self.versiontypeLabel.font = [UIFont systemFontOfSize:14.0];
    self.versiontypeLabel.textColor = [UIColor lightGrayColor];
    self.versiontypeLabel.textAlignment = NSTextAlignmentCenter;
    [self.versiontypeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.appNameLabel);
        make.top.equalTo(self.appNameLabel.mas_bottom).offset(10);
        make.height.mas_equalTo(10);
        make.centerX.equalTo(self.bgImageView.mas_centerX);
    }];
    
    NSString *currentversion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    self.versiontypeLabel.text = [NSString stringWithFormat:@"iOS v%@",currentversion];
    
    self.incLabel = [[UILabel alloc] init];
    [self.bgImageView addSubview:self.incLabel];
    self.incLabel.font = [UIFont systemFontOfSize:12.0];
    self.incLabel.textColor = [UIColor lightGrayColor];
    self.incLabel.textAlignment = NSTextAlignmentCenter;
    [self.incLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(self.appNameLabel);
        make.centerX.equalTo(self.bgImageView.mas_centerX);
        make.bottom.equalTo(self.bgImageView.mas_bottom).offset(-20 - self.appNameLabel.frame.size.height);
    }];
    
    self.incLabel.text = DZ_INCINFO;
    
    self.companyLabel = [[UILabel alloc] init];
    [self.bgImageView addSubview:self.companyLabel];
    self.companyLabel.font = [UIFont systemFontOfSize:16.0];
    self.companyLabel.textColor = [UIColor darkGrayColor];
    self.companyLabel.textAlignment = NSTextAlignmentCenter;
    [self.companyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(self.appNameLabel);
        make.centerX.equalTo(self.bgImageView.mas_centerX);
        make.bottom.equalTo(self.incLabel.mas_top).offset(10);
    }];
    self.companyLabel.text = DZ_COMPANYNAME;
    
}




@end
