//
//  TTBoundThirdController.m
//  DiscuzMobile
//
//  Created by HB on 16/9/18.
//  Copyright © 2016年 Cjk. All rights reserved.
//

#import "TTJudgeBoundController.h"
#import "JTRegisterController.h"
#import "JudgeBoundView.h"

@interface TTJudgeBoundController ()

@property (nonatomic,strong) JudgeBoundView *judgeView;

@end

@implementation TTJudgeBoundController

- (void)loadView {
    [super loadView];
    _judgeView = [[JudgeBoundView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.view = _judgeView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"关联登录";
    self.view.backgroundColor = mRGBColor(246, 246, 246);
    [self setAction];
}

- (void)setAction {
    
    NSMutableAttributedString *describe = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"亲爱的用户：%@为了给您更好的服务，请关联一个掌上论坛账号",[ShareCenter shareInstance].bloginModel.username]];
    NSRange dearRange = {0,5};
    NSInteger nameLength = [[NSString stringWithFormat:@"%@",[ShareCenter shareInstance].bloginModel.username] length];
    NSRange nameRange = {6,nameLength};
    
    NSRange allRange = {0,[describe length]};
    [describe addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:allRange];
    [describe addAttribute:NSFontAttributeName value:[FontSize forumtimeFontSize14] range:allRange];
    
    [describe addAttribute:NSForegroundColorAttributeName value:LIGHT_TEXT_COLOR range:dearRange];
    [describe addAttribute:NSFontAttributeName value:[FontSize HomecellTimeFontSize16] range:dearRange];
    
    [describe addAttribute:NSForegroundColorAttributeName value:MAIN_TITLE_COLOR range:nameRange];
    [describe addAttribute:NSFontAttributeName value:[FontSize HomecellTimeFontSize16] range:nameRange];
    
    _judgeView.desclabl.attributedText = describe;
    
     [_judgeView.registerBtn addTarget:self action:@selector(registerBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_judgeView.boundBtn addTarget:self action:@selector(boundBtnClick) forControlEvents:UIControlEventTouchUpInside];
}

- (void)registerBtnClick {
    JTRegisterController * rvc =[[JTRegisterController alloc] init];
    [self.navigationController pushViewController:rvc animated:YES];
}

- (void)boundBtnClick {
    [self leftBarBtnClick];
}


@end
