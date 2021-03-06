//
//  UsertermsController.m
//  DiscuzMobile
//
//  Created by HB on 17/3/8.
//  Copyright © 2017年 comsenz-service.com. All rights reserved.
//

#import "UsertermsController.h"

@interface UsertermsController ()

@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UIScrollView *scrollview;

@end

@implementation UsertermsController

- (void)loadView {
    [super loadView];
    self.scrollview = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.view = self.scrollview;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = [NSString stringWithFormat:@"%@ 服务条款",DZ_APPNAME];
    
    self.contentLabel = [[UILabel alloc] init];
    self.contentLabel.numberOfLines = 0;
    self.contentLabel.font = [DZFontSize HomecellNameFontSize16];
    [self.view addSubview:self.contentLabel];
    
    NSString *fileName = DZ_BBSRULE;
    NSString *filePath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"txt"];
    NSString *strp = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    
    if ([DataCheck isValidString:self.bbrulestxt]) {
        self.contentLabel.text = self.bbrulestxt;
    } else {
        self.contentLabel.text = strp;
    }
    
    CGSize messageSize = [self.contentLabel.text sizeWithFont:[DZFontSize HomecellNameFontSize16] maxSize:CGSizeMake(KScreenWidth - 40, CGFLOAT_MAX)];
    self.contentLabel.frame = CGRectMake(20, 15, messageSize.width, messageSize.height);
    self.scrollview.contentSize = CGSizeMake(KScreenWidth, CGRectGetMaxY(self.contentLabel.frame) + 40);
}


@end
