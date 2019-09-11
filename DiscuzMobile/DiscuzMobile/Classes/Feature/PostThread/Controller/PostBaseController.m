//
//  PostBaseController.m
//  DiscuzMobile
//
//  Created by HB on 2017/6/29.
//  Copyright © 2017年 comsenz-service.com.  All rights reserved.
//

#import "PostBaseController.h"
#import "UIAlertController+Extension.h"
#import "SeccodeverifyView.h"
#import "ZHPickView.h"
#import "ImagePickerView.h"
#import "NewThreadTypeModel.h"

@interface PostBaseController ()

@end

@implementation PostBaseController

- (void)viewWillDisappear:(BOOL)animated {
    if (self.typeArray.count > 0) {
        [self.pickView remove];
    }
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([DataCheck isValidDictionary:[[self.dataForumTherad objectForKey:@"threadtypes"] objectForKey:@"types"]]) {
    
        NSMutableDictionary *typeDic = [NSMutableDictionary dictionaryWithDictionary:[[self.dataForumTherad objectForKey:@"threadtypes"] objectForKey:@"types"]];
        [typeDic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            NewThreadTypeModel *model = [[NewThreadTypeModel alloc] init];
            model.typeId = key;
            model.name = [obj flattenHTMLTrimWhiteSpace:NO];
            [self.typeArray addObject:model];
        }];
        
        // test++++++++++++++++++++++++++++
//        for (NSInteger i = 0; i < 3; i++) {
//            NewThreadTypeModel *model = [[NewThreadTypeModel alloc] init];
//            model.typeId = [NSString stringWithFormat:@"%ld",i];
//            model.name = [NSString stringWithFormat:@"鹅鹅%ld",i];
//            [self.typeArray addObject:model];
//        }
        // test++++++++++++++++++++++++++++
        
        NSMutableArray *arr = [NSMutableArray array];
        for (NewThreadTypeModel *model in self.typeArray) {
            [arr addObject:model.name];
        }
        
        if (self.typeArray.count > 0) {
            self.pickView = [[ZHPickView alloc] initPickviewWithArray:arr isHaveNavControler:NO];
            [self.pickView setToolbarTintColor:TOOLBAR_BACK_COLOR];
        }
        
    }
    
    self.uploadhash = @"";
    if ([DataCheck isValidDictionary:[self.dataForumTherad objectForKey:@"allowperm"]]) {
        self.uploadhash = [[self.dataForumTherad objectForKey:@"allowperm"] objectForKey:@"uploadhash"];
    }
    
    if ([DataCheck isValidString:[[self.dataForumTherad objectForKey:@"forum"] objectForKey:@"fid"]]) {
        self.fid = [[self.dataForumTherad objectForKey:@"forum"] objectForKey:@"fid"];
    }
    
    [self checkPostAuth];
}

// 检查权限 : 发帖 回帖 上传权限
-(void)checkPostAuth {
    
    if (![DataCheck isValidDictionary:[self.dataForumTherad objectForKey:@"allowperm"]] && self.fid) { // 上页数据没有allowperm字段的时候再请求一次
        NSDictionary * dic =@{@"fid":self.fid
                              };
        [DZApiRequest requestWithConfig:^(JTURLRequest *request) {
            [self.HUD showLoadingMessag:@"检查发帖权限" toView:self.view];
            request.urlString = url_CheckPostAuth;
            request.parameters = dic;
        } success:^(id responseObject, JTLoadType type) {
            [self.HUD hide];
            if ([DataCheck isValidDictionary:[responseObject objectForKey:@"Variables"]]) { // 获取验证发帖权限数据
                if ([DataCheck isValidString:self.uploadhash]) {
                    if ([DataCheck isValidDictionary:[[responseObject objectForKey:@"Variables"] objectForKey:@"allowperm"]]) {
                        self.uploadhash = [[[responseObject objectForKey:@"Variables"] objectForKey:@"allowperm"] objectForKey:@"uploadhash"];
                    }
                }
            }
        } failed:^(NSError *error) {
            [self.HUD hide];
        }];
    }
}

- (void)viewEndEditing {
    [self.view endEditing:YES];
    if (self.typeArray.count > 0) {
        [self.pickView remove];
    }
}

- (void)requestPostFailure:(NSError *)error {
    [self.HUD hide];
    [self showServerError:error];
}

- (void)requestPostSucceed:(id)responseObject {
    
    [self.HUD hide];
    NSString *messageval = [responseObject messageval];
    NSString *messagestr = [responseObject messagestr];
    if ([messageval containsString:@"succeed"] || [messageval containsString:@"success"]) {
        if ([DataCheck isValidString:[[responseObject objectForKey:@"Variables"] objectForKey:@"tid"]]) {
            [self.navigationController popViewControllerAnimated:NO];
            if (self.pushDetailBlock) {
                self.pushDetailBlock([[responseObject objectForKey:@"Variables"] objectForKey:@"tid"]);
            }
            return;
        }
    }
    if ([messageval isEqualToString:@"group_nopermission"]) {
        [UIAlertController alertTitle:@"提示" message:messagestr controller:self doneText:@"确定" cancelText:nil doneHandle:^{
            [self.navigationController popViewControllerAnimated:YES];
        } cancelHandle:nil];
        return;
    }
    
    [MBProgressHUD showInfo:messagestr];
    
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text hasEmoji]) {
        return NO;
    }
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([string hasEmoji]) {
        return NO;
    }
    return YES;
}

- (SeccodeverifyView *)verifyView {
    if (!_verifyView) {
        _verifyView = [[SeccodeverifyView alloc] init];
    }
    return _verifyView;
}

- (ImagePickerView *)pickerView {
    if (_pickerView == nil) {
        _pickerView = [[ImagePickerView alloc] init];
        _pickerView.navigationController = self.navigationController;
    }
    return _pickerView;
}

- (NSMutableArray<NewThreadTypeModel *> *)typeArray {
    if (!_typeArray) {
        _typeArray = [NSMutableArray array];
    }
    return _typeArray;
}

@end
