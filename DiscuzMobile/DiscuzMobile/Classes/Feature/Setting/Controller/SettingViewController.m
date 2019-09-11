//
//  SettingViewController.m
//  DiscuzMobile
//
//  Created by gensinimac1 on 15/5/5.
//  Copyright (c) 2015年 Cjk. All rights reserved.
//

#import "SettingViewController.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>
#import <ShareSDKExtension/ShareSDK+Extension.h>

#import "AboutController.h"
#import "XinGeCenter.h"
#import "UsertermsController.h"
#import "DomainListController.h"
#import "SendEmailHelper.h"

#import "ShareCenter.h"
#import "JudgeImageModel.h"
#import "DZDevice.h"

@interface SettingViewController ()
@property (nonatomic,strong) NSString * strcache;
@end

@implementation SettingViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.hidesBottomBarWhenPushed  = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"通用设置";
    
    [self.tableView removeFromSuperview];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT) style:UITableViewStyleGrouped];
    if (@available(iOS 11.0, *)) {
        self.tableView.estimatedRowHeight = 0;
        self.tableView.estimatedSectionFooterHeight = 0;
        self.tableView.estimatedSectionHeaderHeight = 0;
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    NSMutableArray *setArr = @[@"无图浏览模式",
                     // @"通知中心设置",
                        @"清除程序缓存",
                        @"切换网站",
                        ].mutableCopy;
    
    NSArray *appArr = @[
//                        @"反馈问题",
                        @"评价应用",
                        @"分享应用"];
    
    NSArray *aboutArr = @[[NSString stringWithFormat:@"关于“%@”",APPNAME],
                          @"服务条款"];
    self.dataSourceArr = @[setArr,appArr,aboutArr].mutableCopy;
}

#pragma mark - UITableViewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataSourceArr.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *arr = self.dataSourceArr[section];
    return arr.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    static NSString *CellId = @"SettingCellId";
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:CellId];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellId];
        cell.textLabel.font = [FontSize messageFontSize14];
        cell.detailTextLabel.font = [FontSize ActiveListFontSize11];
        if (indexPath.section == 0 && indexPath.row == 0) {
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
    }
    
    NSArray *settingArr = self.dataSourceArr[indexPath.section];
    cell.textLabel.text = [settingArr objectAtIndex:indexPath.row];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            
            UISwitch * sw = [[UISwitch alloc] init];
            [sw addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
            [sw setOn:[JudgeImageModel graphFreeModel]];
            cell.accessoryView = sw;
        } else if (indexPath.row == 1) {
            
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%.2fM",[[FileManager shareInstance] filePathSize]];
        }
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50.0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.5;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.section) {
        case 0: {
            if (indexPath.row == 1) {
                [self  clearAPP];
            }
            if (indexPath.row == 2) {
                [self setDomain];
                return;
            }
            NSArray *settingArr = self.dataSourceArr[indexPath.section];
            if (settingArr.count > 1 && indexPath.row == settingArr.count - 1) {
                
            }
        }
            break;
        case 1: {
//            if (indexPath.row == 0) {
//                [self sendEmail];
//            }
            if (indexPath.row == 0) {
                [self evaluateAPP];
            }
            if (indexPath.row == 1) {
                [self shareAPP];
            }
        }
            break;
        case 2: {
            if (indexPath.row == 0) {
                [self aboutAPP];
            }
            if (indexPath.row == 1) {
                [self userTerms];
            }
        }
            break;
        default:
            break;
    }
}

- (void)sendEmail {
    [SendEmailHelper shareInstance].navigationController = self.navigationController;
    [[SendEmailHelper shareInstance] prepareSendEmail];
}

- (void)setDomain {
    DomainListController *domainVC = [[DomainListController alloc] init];
    [self.navigationController pushViewController:domainVC animated:YES];
}

- (void)evaluateAPP {
    NSString *urlStr = AppStorePath;
    if (@available(iOS 10.0, *)) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr] options:@{} completionHandler:nil];
    } else {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr]];
    }
}

- (void)shareAPP {
    NSString *urlStr = AppStorePath;
    NSString *appName = APPNAME;
    [[ShareCenter shareInstance] createShare:@"Discuz客户端产品，提供方便简洁的发帖与阅读体验" andImages:@[[DZDevice getIconName]] andUrlstr:urlStr andTitle:appName andView:self.view andHUD:nil];
}

- (void)aboutAPP {
    AboutController *abVC = [[AboutController alloc] init];
    [self.navigationController pushViewController:abVC animated:YES];
}

- (void)userTerms {
    UsertermsController *termVC = [[UsertermsController alloc] init];
    [self.navigationController pushViewController:termVC animated:YES];
}

#pragma mark - 无图浏览设置
-(void)switchAction:(id)btn{
    UISwitch * switchButton = (UISwitch*)btn;
    BOOL usbuttonon = [switchButton isOn];
    [[NSUserDefaults standardUserDefaults] setBool:usbuttonon forKey:boolNoImage];
    [[NSNotificationCenter defaultCenter] postNotificationName:IMAGEORNOT object:nil];
}

#pragma mark - 推送开启关闭设置
-(void)switchAction1:(id)btn{
    
    UISwitch * switchButton = (UISwitch *)btn;
    
    BOOL usbuttonon = [switchButton isOn];
    if (usbuttonon) {
        //开启
        [[XinGeCenter shareInstance] Reregistration];
        
        if (![LoginModule isLogged]) {
            return;
        } else {
            [[XinGeCenter shareInstance] setXG];
        }
        if ([XGPush isUnRegisterStatus]) {
            [MBProgressHUD showInfo:@"开启推送"];
        } else {
            [MBProgressHUD showInfo:@"开启推送失败"];
        }
    } else {
        // 注销
        [self logoutDevice];
    }
}

- (void)logoutDevice{
    
    [XGPush unRegisterDevice];
    [XGPush setAccount:@"**"];
    if ([XGPush isUnRegisterStatus]) {
        
        [MBProgressHUD showInfo:@"注销设备"];
    }
    else {
        [MBProgressHUD showInfo:@"注销设备失败"];
    }
    
}
#pragma mark - 清除缓存
-(void)clearAPP {
    [self.HUD showLoadingMessag:@"正在清理" toView:self.view];
    BACK(^{
        
        NSString *cachPath = [JTCacheManager sharedInstance].JTKitPath;
        NSArray *files = [[NSFileManager defaultManager] subpathsAtPath:cachPath];
        
        for (NSString *p in files) {
            NSError * error;
            NSString * path = [cachPath stringByAppendingPathComponent:p];
            if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
                [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
            }
        }
        [self cleanSaveImages];
        
        // 清除完，重新创建文件夹、重新创建数据库
        [[JTCacheManager sharedInstance] createDirectoryAtPath:[JTCacheManager sharedInstance].JTAppCachePath];
        [[DatabaseHandle defaultDataHelper] openDB];
        
        MAIN(^{
            UIImage *image = [[UIImage imageNamed:@"Checkmark"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
            self.HUD.customView = imageView;
            self.HUD.mode = MBProgressHUDModeCustomView;
            self.HUD.label.text = @"清理成功！";
        });
        
        sleep(2);
        [self performSelectorOnMainThread:@selector(clearCacheSuccess) withObject:nil waitUntilDone:YES];
    });

}
// 清除缓存(清除sdWebImage的缓存)
- (void)cleanSaveImages {
    SDWebImageManager *manger = [SDWebImageManager sharedManager];
    [manger cancelAll];
    [manger.imageCache clearDiskOnCompletion:nil];
    [manger.imageCache clearMemory];
}

-(void)clearCacheSuccess {
    
    [self.HUD hide];
    NSIndexPath *indexpath = [NSIndexPath indexPathForRow:1 inSection:0];
    [self.tableView reloadRowsAtIndexPaths:@[indexpath] withRowAnimation:UITableViewRowAnimationNone];
}


@end
