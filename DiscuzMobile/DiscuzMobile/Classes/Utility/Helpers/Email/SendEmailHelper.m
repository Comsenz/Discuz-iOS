//
//  SendEmailHelper.m
//  DiscuzMobile
//
//  Created by ZhangJitao on 2018/4/8.
//  Copyright © 2018年 comsenz-service.com.  All rights reserved.
//

#import "SendEmailHelper.h"
#import <MessageUI/MessageUI.h>
#import "UIDevice+Extension.h"

@interface SendEmailHelper()<MFMailComposeViewControllerDelegate>

@end

@implementation SendEmailHelper

+ (instancetype)shareInstance {
    static SendEmailHelper *sendHelper = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sendHelper = [[SendEmailHelper alloc] init];
    });
    return sendHelper;
}

- (void)prepareSendEmail {
    if (MFMailComposeViewController.canSendMail == YES) {
        NSString *deviceName = [UIDevice currentDevice].name;
        NSString *device = [UIDevice deviceVersion];
        NSString *systemVersion = [UIDevice currentDevice].systemVersion;
        NSString *appVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
        NSString *appName = APPNAME;
        
        MFMailComposeViewController *mailPicker = [[MFMailComposeViewController alloc] init];
        mailPicker.mailComposeDelegate = self;
        //添加收件人
        [mailPicker setToRecipients:@[DeveloperEmail]];
        
        //设置主题
        [mailPicker setSubject:[NSString stringWithFormat:@"%@ %@ - FeedBack Mail  From%@",appName,appVersion,deviceName]];
        NSString *content = [NSString stringWithFormat:@"\n \n \n \n Device：%@ \n System: %@ \n App Version：%@",device,systemVersion,appVersion];
        [mailPicker setMessageBody:content isHTML:NO];
        [_navigationController presentViewController:mailPicker animated:YES completion:nil];
    } else {
        [MBProgressHUD showInfo:@"用户没有设置邮件账户"];
    }
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    [_navigationController dismissViewControllerAnimated:YES completion:nil];
    NSString *msg;
    switch (result) {
        case MFMailComposeResultCancelled:
            msg = @"用户取消编辑邮件";
            break;
        case MFMailComposeResultSaved:
            msg = @"用户成功保存邮件";
            break;
        case MFMailComposeResultSent:
            msg = @"谢谢您的建议，已将邮件发送给开发者";
            break;
        case MFMailComposeResultFailed:
            msg = @"用户试图保存或者发送邮件失败";
            break;
        default:
            msg = @"";
            break;
    }
    [MBProgressHUD showInfo:msg];
}

@end
