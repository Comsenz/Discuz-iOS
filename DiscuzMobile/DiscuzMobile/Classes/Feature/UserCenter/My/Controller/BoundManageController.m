//
//  BoundManageController.m
//  DiscuzMobile
//
//  Created by HB on 2017/7/12.
//  Copyright © 2017年 comsenz-service.com.  All rights reserved.
//

#import "BoundManageController.h"
#import "CenterUserInfoView.h"
#import "BoundManageCell.h"
#import "TextIconModel.h"
#import "BoundInfoModel.h"

#import "ShareCenter.h"
#import "UIAlertController+Extension.h"

@interface BoundManageController ()

@property (nonatomic, strong) CenterUserInfoView *userInfoView;

@end

@implementation BoundManageController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"绑定管理";
    self.userInfoView = [[CenterUserInfoView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 120)];
    [self.userInfoView.identityLab setHidden:YES];
    self.tableView.tableHeaderView = self.userInfoView;
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 80)];
    
    [self requestData];
}

- (void)requestData {
    [self.HUD showLoadingMessag:@"" toView:nil];
    [DZApiRequest requestWithConfig:^(JTURLRequest *request) {
        request.urlString = url_oauths;
    } success:^(id responseObject, JTLoadType type) {
        [self.HUD hide];
        NSDictionary * info = [responseObject objectForKey:@"Variables"];
        self.userInfoView.nameLab.text = [info objectForKey:@"member_username"];
        [self.userInfoView.headView sd_setImageWithURL:[NSURL URLWithString:[info objectForKey:@"member_avatar"]]];
        NSArray *users = [info objectForKey:@"users"];
        if ([DataCheck isValidArray:users]) {
            self.dataSourceArr = [BoundInfoModel mj_objectArrayWithKeyValuesArray:users];
        }
        [self.tableView reloadData];
    } failed:^(NSError *error) {
        [self.HUD hide];
    }];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50.0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSourceArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellID = @"BoundManageID";
    BoundManageCell *cell = [tableView dequeueReusableCellWithIdentifier:CellID];
    if (cell == nil) {
        cell = [[BoundManageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellID];
        cell.detailBtn.tag = indexPath.row;
        [cell.detailBtn addTarget:self action:@selector(boundTapAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    BoundInfoModel *model = self.dataSourceArr[indexPath.row];
    [cell setData:model];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 5;
}

- (void)boundTapAction:(UIButton *)sender {
    NSInteger index = sender.tag;
    BoundInfoModel *model = self.dataSourceArr[index];
    if ([model.status isEqualToString:@"1"]) {
        NSString *title = @"解除绑定？";
        NSString *message = @"解绑后，将不能使用三方登录，登录此账号";
        if ([model.type isEqualToString:@"minapp"]) {
            title = @"解除小程序绑定？";
            message = @"解绑后，打开小程序需要重新登录";
        }
        [UIAlertController alertTitle:title
                              message:message
                           controller:self
                             doneText:@"确定"
                           cancelText:@"取消"
                           doneHandle:^{
                               [self unbound:model];
                           } cancelHandle:nil];
    } else {
        if ([model.type isEqualToString:@"minapp"]) {
            [UIAlertController alertTitle:@"提示"
                                  message:@"请前往小程序登录将自动完成绑定"
                               controller:self
                                 doneText:@"确定"
                               cancelText:nil
                               doneHandle:nil
                             cancelHandle:nil];
            return;
        }
        
        [self.HUD showLoadingMessag:@"" toView:self.view];
        if ([model.type isEqualToString:@"weixin"]) {
            
            [[ShareCenter shareInstance] loginWithWeiXinSuccess:^(id  _Nullable postData, id  _Nullable getData) {
                [self thirdConnectWithService:postData getData:getData];
            } finish:^{
                [self.HUD hide];
            }];
        }
        else if ([model.type isEqualToString:@"qq"]) {
            [[ShareCenter shareInstance] loginWithQQSuccess:^(id  _Nullable postData, id  _Nullable getData) {
                [self thirdConnectWithService:postData getData:getData];
            } finish:^{
                [self.HUD hide];
            }];
        }
    }
}

- (void)unbound:(BoundInfoModel *)model {
    NSDictionary *postData = @{
                               @"unbind":@"yes",
                               @"type":model.type,
                               @"formhash":[Environment sharedEnvironment].formhash
                               };
    
    [self.HUD showLoadingMessag:@"解除绑定" toView:self.view];
    [DZApiRequest requestWithConfig:^(JTURLRequest *request) {
        request.methodType = JTMethodTypePOST;
        request.urlString = url_unBindThird;
        request.parameters = postData;
    } success:^(id responseObject, JTLoadType type) {
        [self.HUD hide];
        NSDictionary *msgDic = [responseObject objectForKey:@"Message"];
        if ([DataCheck isValidDictionary:msgDic]) {
            NSString *messageStatus = [msgDic objectForKey:@"messageval"];
            if ([DataCheck isValidString:messageStatus]) {
                if ([messageStatus containsString:@"succeed"]) {
                    [MBProgressHUD showInfo:@"解绑成功"];
                    //                        [LoginModule cleanLogType];
                    [self requestData];
                    return;
                }
            }
        }
        
        [MBProgressHUD showInfo:@"对不起，解绑失败"];
        
    } failed:^(NSError *error) {
        [self.HUD hide];
    }];
}

- (void)thirdConnectWithService:(NSDictionary *)dic getData:(NSDictionary *)getData {
    [dic setValue:[Environment sharedEnvironment].formhash forKey:@"formhash"];
    [dic setValue:@"yes" forKey:@"loginsubmit"];
    [self.HUD showLoadingMessag:@"" toView:self.view];
    [DZApiRequest requestWithConfig:^(JTURLRequest *request) {
        request.urlString = url_Login;
        request.methodType = JTMethodTypePOST;
        request.parameters = dic;
        request.getParam = getData;
    } success:^(id responseObject, JTLoadType type) {
        [self.HUD hide];
        NSDictionary *messageDic = [responseObject objectForKey:@"Message"];
        if ([DataCheck isValidDictionary:messageDic]) {
            NSString *messageval = [messageDic objectForKey:@"messageval"];
            if ([messageval containsString:@"succeed"]) {
                [MBProgressHUD showInfo:@"绑定成功"];
                [self requestData];
            }
        }
        
    } failed:^(NSError *error) {
        [self.HUD hide];
        [self showServerError:error];
    }];
}

@end
