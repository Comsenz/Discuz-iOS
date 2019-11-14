//
//  DZAboutController.m
//  DiscuzMobile
//
//  Created by HB on 16/12/5.
//  Copyright © 2016年 comsenz-service.com.  All rights reserved.
//

#import "DZAboutController.h"
#import "DZAboutView.h"

@interface DZAboutController ()

@property (nonatomic, strong) DZAboutView *aboutView;

@end

@implementation DZAboutController

- (void)loadView {
    [super loadView];
    
    self.aboutView = [[DZAboutView alloc] initWithFrame:self.view.bounds];
    self.view = self.aboutView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"关于";
}
@end
