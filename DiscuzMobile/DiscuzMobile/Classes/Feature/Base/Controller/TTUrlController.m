//
//  TTUrlController.m
//  DiscuzMobile
//
//  Created by HB on 16/4/29.
//  Copyright © 2016年 Cjk. All rights reserved.
//

#import "TTUrlController.h"
#import "UIAlertController+Extension.h"

@interface TTUrlController ()<UIWebViewDelegate>

@property (nonatomic,strong) UIWebView *webView;
@end

@implementation TTUrlController

- (void)dealloc {
    NSLog(@"urlController销毁了");
    [[NSNotificationCenter defaultCenter] removeObserver:self name:STATUSBARTAP object:nil];
    [self.webView loadRequest:[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:@""]]];
    [self cleanWebChache];
    self.webView.delegate = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.webView];
   
    // 无数据的时候显示
    if ([_urlString isEqualToString:@""] || (![_urlString ifUrlContainDomain])) {
        [UIAlertController alertTitle:nil message:@"请求地址不存在" controller:self doneText:@"返回" cancelText:nil doneHandle:^{
            [self.navigationController popViewControllerAnimated:YES];
        } cancelHandle:nil];
        return;
    }
    NSString *encodeUrlStr = [_urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:encodeUrlStr];
    [_webView loadRequest:[NSURLRequest requestWithURL:url]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(statusBarTappedAction:) name:STATUSBARTAP object:nil];
}
- (void)webViewDidStartLoad:(UIWebView *)webView {
    [self.HUD showLoadingMessag:@"正在加载" toView:self.view];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:webView.request.URL];
    NSEnumerator *enumerator = [cookies objectEnumerator];
    NSHTTPCookie *cookie;
    while (cookie = [enumerator nextObject]) {
        DLog(@"COOKIE{name: %@, value: %@}", [cookie name], [cookie value]);
    }
    [self.HUD hideAnimated:YES];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{

    [self.HUD hideAnimated:YES];
    if (error.code == NSURLErrorCancelled) {
        //忽略这个错误。
        return ;
    }
    [_webView setHidden:YES];
    [UIAlertController alertTitle:nil message:[error localizedDescription] controller:self doneText:@"返回" cancelText:nil doneHandle:^{
        [self.navigationController popViewControllerAnimated:YES];
    } cancelHandle:nil];
}

- (void)cleanWebChache {
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"WebKitCacheModelPreferenceKey"];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"WebKitDiskImageCacheEnabled"];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"WebKitOfflineWebApplicationCacheEnabled"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

// 点击状态栏到顶部
- (void)statusBarTappedAction:(NSNotification*)notification {
    [self.webView.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
}

- (UIWebView *)webView {
    if (_webView == nil) {
        _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT - self.navbarMaxY)];
        _webView.backgroundColor = [UIColor whiteColor];
        _webView.userInteractionEnabled = YES;
        [_webView setOpaque:NO];
        // 自动缩放适应屏幕
        [_webView setScalesPageToFit:YES];
        _webView.delegate = self;
    }
    return _webView;
}

@end
