//
//  DomainListController.m
//  DiscuzMobile
//
//  Created by ZhangJitao on 2018/3/30.
//  Copyright © 2018年 comsenz-service.com.  All rights reserved.
//

#import "DomainListController.h"
#import "UIAlertController+Extension.h"

NSString * const domainList = @"domainList";

NSString * const domain = @"domain";
NSString * const domainName = @"name";

@interface DomainListController ()

@end

@implementation DomainListController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createBarBtn:@"添加" type:NavItemText Direction:NavDirectionRight];
    
    NSDictionary *dic = [[FileManager shareInstance] readDocumentPlist:domainList];
    if ([DataCheck isValidDictionary:dic] && [DataCheck isValidArray:dic[domain]]) {
        self.dataSourceArr = [NSMutableArray arrayWithArray:dic[domain]];
    } else {
        
        NSDictionary *disDz = @{domain:@"https://bbs.comsenz-service.com/",
                                domainName:@"掌上论坛",
                                };
        NSDictionary *devDz = @{domain:@"https://guanjia.comsenz-service.com/",
                                domainName:@"管家测试",
                                };
        NSDictionary *rednet = @{domain:@"https://bbs.rednet.cn/",
                                 domainName:@"红网",
                                 };
        NSDictionary *bird = @{domain:@"https://www.birdnet.cn/",
                               domainName:@"鸟网",
                               };
        NSDictionary *taifeng = @{domain:@"https://bbs.typhoon.org.cn/",
                                 domainName:@"台风",
                                 };
        NSDictionary *leshan = @{domain:@"https://mobile.leshan.cn/",
                               domainName:@"乐山",
                               };
        NSDictionary *jinbifun = @{domain:@"http://www.jinbifun.com/",
                                   domainName:@"金碧坊",
                                   };
        NSDictionary *penjing = @{domain:@"http://bbs.cnpenjing.com/",
                                   domainName:@"盆景艺术在线",
                                  };
        
        
        NSArray *domainArray = @[disDz,devDz,rednet,bird,taifeng,leshan,jinbifun,penjing,];
        [[FileManager shareInstance] writeDocumentPlist:@{domain:domainArray} fileName:@"domainList"];
        self.dataSourceArr = domainArray.mutableCopy;
    }
}

- (void)rightBarBtnClick {

    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"注意" message:@"请输入域名’http‘开头‘/’结尾" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"名称";
    }];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"域名";
    }];
    UIAlertAction *doneAction = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDestructive) handler:^(UIAlertAction * _Nonnull action) {
        UITextField *nameTextField = alertController.textFields.firstObject;
        UITextField *domainTextField = alertController.textFields.lastObject;
        if (![DataCheck isValidString:nameTextField.text]) {
            [MBProgressHUD showInfo:@"请输入名称"];
            [self presentViewController:alertController animated:YES completion:nil];
            return;
        }
        if (![DataCheck isValidString:domainTextField.text]) {
            [MBProgressHUD showInfo:@"请输入域名"];
            [self presentViewController:alertController animated:YES completion:nil];
            return;
        }
        NSString *domainString = domainTextField.text;
        if (![domainString hasSuffix:@"/"]) {
            domainString = [domainString stringByAppendingString:@"/"];
        }
        
        NSDictionary *dic = @{domainName:nameTextField.text,
                              domain:domainString
                              };
        [self.dataSourceArr addObject:dic];
        [[FileManager shareInstance] writeDocumentPlist:@{domain:self.dataSourceArr} fileName:@"domainList"];
        [LoginModule signout];
        [[NSNotificationCenter defaultCenter] postNotificationName:DOMAINCHANGE object:nil];
        [self.tableView reloadData];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:doneAction];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSourceArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([self class])];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:NSStringFromClass([self class])];
        cell.detailTextLabel.font = [FontSize ActiveListFontSize11];
        cell.textLabel.font = [FontSize messageFontSize14];
    }
    NSDictionary *domainDic = self.dataSourceArr[indexPath.row];
    
    NSString *detail = domainDic[domain];
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *nowDomain = [userDefault objectForKey:domain];
    if ([detail isEqualToString:nowDomain]) {
        detail = [detail stringByAppendingString:@"(当前)"];
    } else if (nowDomain == nil && [detail isEqualToString:BASEURL]) {
        detail = [detail stringByAppendingString:@"(当前)"];
    }
    cell.textLabel.text = domainDic[domainName];
    cell.detailTextLabel.text = detail;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary *domainDic = self.dataSourceArr[indexPath.row];
    NSString *detail = domainDic[domain];
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *nowDomain = [userDefault objectForKey:domain];
    
    if (![detail isEqualToString:BASEURL] || !([DataCheck isValidString:nowDomain] && [nowDomain isEqualToString:detail])) {
        [userDefault setObject:detail forKey:domain];
        [userDefault synchronize];
        [LoginModule signout];
        [[NSNotificationCenter defaultCenter] postNotificationName:DOMAINCHANGE object:Nil];
        [tableView reloadData];
    }
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return UITableViewCellEditingStyleDelete;
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [self.tableView setEditing:YES animated:animated];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        [self deleteDomain:indexPath];
    }
}

- (void)deleteDomain:(NSIndexPath *)indexPath {
    
    NSDictionary *domainDic = self.dataSourceArr[indexPath.row];
    NSString *detail = domainDic[domain];
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *nowDomain = [userDefault objectForKey:domain];
    if ([detail isEqualToString:nowDomain]) {
        [userDefault setObject:nil forKey:domain];
        [userDefault synchronize];
    }
    [self.dataSourceArr removeObjectAtIndex:indexPath.row];
    [[FileManager shareInstance] writeDocumentPlist:@{domain:self.dataSourceArr} fileName:@"domainList"];
    
    [self.tableView beginUpdates];
    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
    [self.tableView endUpdates];
}

@end
