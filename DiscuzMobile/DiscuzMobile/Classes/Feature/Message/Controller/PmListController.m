//
//  PmListController.m
//  DiscuzMobile
//
//  Created by HB on 2017/7/17.
//  Copyright © 2017年 comsenz-service.com.  All rights reserved.
//

#import "PmListController.h"
#import "PmTopTabController.h"
#import "PmSublistController.h"
#import "PmSublistController.h"

#import "PmlistCell.h"

#import "PmTypeModel.h"
#import "MessageNoticeCenter.h"

@interface PmListController ()

@end

@implementation PmListController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"我的消息";
    
//    self.dataSourceArr = @[@"我的消息",@"我的帖子",@"坛友互动",@"系统提醒",@"管理工作"].mutableCopy;
    self.dataSourceArr = @[@"我的消息",@"我的帖子"].mutableCopy;
    // Do any additional setup after loading the view.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSourceArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellID = @"CenterID";
    PmlistCell *cell = [tableView dequeueReusableCellWithIdentifier:CellID];
    if (cell == nil) {
        cell = [[PmlistCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellID];
    }
    
    NSString *title = self.dataSourceArr[indexPath.row];
    if (indexPath.row == 0) {
        cell.titleLab.attributedText = [self cellGetAttributeStr:title andNew:[[MessageNoticeCenter shareInstance].noticeDic objectForKey:@"newpm"]];
    } else {
        
        cell.titleLab.attributedText = [self cellGetAttributeStr:title andNew:[[MessageNoticeCenter shareInstance].noticeDic objectForKey:@"newmypost"]];
        
    }
    
    cell.iconV.image = [UIImage imageTintColorWithName:[NSString stringWithFormat:@"pm_%ld",indexPath.row] andImageSuperView:cell.iconV];
    
    return cell;
}

- (NSMutableAttributedString *)cellGetAttributeStr:(NSString *)title andNew:(NSString *)new {
    
    NSMutableAttributedString *describe = [[NSMutableAttributedString alloc] initWithString:title];
    if ([DataCheck isValidString:new]) {
        if ([new integerValue] > 0) {
            describe = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@(%@)",title,new]];
            NSRange todayRange = NSMakeRange(describe.length - new.length - 2, new.length + 2);
            [describe addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:todayRange];
        }
    }
    
    return describe;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    PmTypeModel *m;
    if (indexPath.row < 3) {
        PmTopTabController *topBabVc = [[PmTopTabController alloc] init];
        switch (indexPath.row) {
            case 0: {
                m = [[PmTypeModel alloc] initWithTitle:@"我的消息" andModule:@"mypm" anFilter:@"privatepm" andView:nil andType:nil];
                PmSublistController *psVc = [[PmSublistController alloc] init];
                psVc.typeModel = m;
                psVc.title = self.dataSourceArr[indexPath.row];
                [self showViewController:psVc sender:nil];
                return;
            }
                break;
            case 1:
                topBabVc.pmType = pm_mythread;
                break;
            case 2:
                topBabVc.pmType = pm_interactive;
                break;
            default:
                break;
        }
        topBabVc.title = self.dataSourceArr[indexPath.row];
        [self showViewController:topBabVc sender:nil];
    } else {
        
        if (indexPath.row == 3) {
            m = [[PmTypeModel alloc] initWithTitle:@"系统提醒" andModule:@"mynotelist" anFilter:@"" andView:@"system" andType:@""];
        } else {
             m = [[PmTypeModel alloc] initWithTitle:@"管理工作" andModule:@"mynotelist" anFilter:@"" andView:@"manage" andType:@""];
        }
        
        PmSublistController *psVc = [[PmSublistController alloc] init];
        psVc.typeModel = m;
        psVc.title = self.dataSourceArr[indexPath.row];
        [self showViewController:psVc sender:nil];
    }
}

@end
