//
//  AboutController.m
//  DiscuzMobile
//
//  Created by HB on 16/12/5.
//  Copyright © 2016年 comsenz-service.com.  All rights reserved.
//

#import "AboutController.h"
#import "AboutView.h"

@interface AboutController ()

@property (nonatomic, strong) AboutView *aboutView;

@end

@implementation AboutController

- (void)loadView {
    [super loadView];
    
    self.aboutView = [[AboutView alloc] initWithFrame:self.view.bounds];
    self.view = self.aboutView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"关于";
}
@end
