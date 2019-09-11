//
//  OtherUserController.m
//  DiscuzMobile
//
//  Created by HB on 17/1/20.
//  Copyright © 2017年 comsenz-service.com.  All rights reserved.
//

#import "OtherUserController.h"
#import "UIAlertController+Extension.h"

#import "CenterToolView.h"
#import "VerticalImageTextView.h"
#import "MyFriendViewController.h"
#import "MySubjectViewController.h"
#import "LoginController.h"
#import "SettingViewController.h"
#import "OtherUserThreadViewController.h"
#import "OtherUserPostReplyViewController.h"

#import "TextIconModel.h"
#import "CenterManageModel.h"

#import "CenterCell.h"
#import "CenterUserInfoView.h"
#import "AllOneButtonCell.h"


@interface OtherUserController ()

@property (nonatomic, strong) CenterUserInfoView *userInfoView;

@property (nonatomic, strong) CenterManageModel *centerModel;

@property (nonatomic, strong) NSString *isfriend;

@end

@implementation OtherUserController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"详细资料";
    
    if (![DataCheck isValidString:self.authorid]) {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    
    self.userInfoView = [[CenterUserInfoView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 140)];
    self.tableView.tableHeaderView = self.userInfoView;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 40)];
    
    [self initData];
    
    [self downLoadData];
    WEAKSELF;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf initData];
        [weakSelf downLoadData];
    }];
}

- (void)rightBarBtnClick {
    SettingViewController * svc = [[SettingViewController alloc]init];
    [self.navigationController pushViewController:svc animated:YES];
}

- (void)notiReloadData {
    [self downLoadData];
    [self.tableView setContentOffset:CGPointMake(0, 0) animated:YES];
}

- (void)initData {
    self.centerModel = [[CenterManageModel alloc] initWithType:JTCenterTypeOther];
}

-(void)downLoadData{
    [self initData];
    
    [DZApiRequest requestWithConfig:^(JTURLRequest *request) {
        [self.HUD showLoadingMessag:@"获取信息" toView:self.view];
        NSDictionary *dic= @{@"uid":self.authorid};
        request.urlString = url_UserInfo;
        request.parameters = dic;
    } success:^(id responseObject, JTLoadType type) {
        [self.HUD hide];
        [self.tableView.mj_header endRefreshing];
        
        [self.centerModel dealOtherData:responseObject];
        NSString *avatar = [[self.centerModel.myInfoDic valueForKey:@"space"] valueForKey:@"avatar"];
        [self.userInfoView.headView sd_setImageWithURL:[NSURL URLWithString:avatar] placeholderImage:[UIImage imageNamed:@"noavatar_small"] options:SDWebImageRetryFailed];
        self.userInfoView.nameLab.text = [[self.centerModel.myInfoDic objectForKey:@"space"] objectForKey:@"username"];
        [self.userInfoView setIdentityText:[[[self.centerModel.myInfoDic objectForKey:@"space"] objectForKey:@"group"] objectForKey:@"grouptitle"]];
        self.isfriend = [[self.centerModel.myInfoDic objectForKey:@"space"] objectForKey:@"isfriend"];
        
        [self.tableView reloadData];
        
    } failed:^(NSError *error) {
        [self.HUD hide];
        [self.tableView.mj_header endRefreshing];
        [self showServerError:error];
    }];
}

#pragma mark - tableView delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 3) {
        return 60;
    }
    return 50.0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 5.0;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return self.centerModel.useArr.count;
    } else if (section == 1){
        return self.centerModel.manageArr.count;
    } else if (section == 2) {
        return self.centerModel.infoArr.count;
    } else if (self.centerModel.myInfoDic.count > 0) {
        if (![self.authorid isEqualToString:[LoginModule getLoggedUid]] && [self.isfriend isEqualToString:@"0"]) {
            return 1;
        }
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellID = @"CenterID";
    static NSString *OneID = @"AddFriend";
    
    if (indexPath.section != 3) {
        CenterCell *cell = [tableView dequeueReusableCellWithIdentifier:CellID];
        if (cell == nil) {
            cell = [[CenterCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellID];
           
        }
        if (indexPath.section == 0) {
            cell.selectionStyle = UITableViewCellSelectionStyleDefault;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        } else {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        TextIconModel *model;
        if (indexPath.section == 0) {
            model = self.centerModel.useArr[indexPath.row];
        }
        if (indexPath.section == 1) {
            model = self.centerModel.manageArr[indexPath.row];
            
        } else if (indexPath.section == 2) {
            model = self.centerModel.infoArr[indexPath.row];
        }
        [cell setData:model];
        return cell;
    } else {
        AllOneButtonCell *cell = [tableView dequeueReusableCellWithIdentifier:OneID];
        if (cell == nil) {
            WEAKSELF;
            cell = [[AllOneButtonCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:OneID];
            cell.actionBlock = ^(UIButton *sender) {
                [weakSelf isSure:sender];
            };
            cell.backgroundColor = [UIColor groupTableViewBackgroundColor];
            [cell.ActionBtn setTitle:@"加好友" forState:UIControlStateNormal];
        }
        return cell;
    }
}

- (void)isSure:(UIButton *)sender {
    
    [UIAlertController alertTitle:@"提示" message:@"您确认添加他为好友？" controller:self doneText:@"确定" cancelText:@"取消" doneHandle:^{
        [self addFriend];
    } cancelHandle:nil];
}

- (void)addFriend {
    if ([[self.centerModel.myInfoDic objectForKey:@"space"] objectForKey:@"uid"] != nil) {
        
        [DZApiRequest requestWithConfig:^(JTURLRequest *request) {
            [self.HUD showLoadingMessag:@"正在请求" toView:self.view];
            NSDictionary *dic = @{@"uid":[[self.centerModel.myInfoDic objectForKey:@"space"] objectForKey:@"uid"],@"type":@"1"};
            request.urlString = url_AddFriend;
            request.parameters = dic;
        } success:^(id responseObject, JTLoadType type) {
            [self.HUD hide];
            if ([[[responseObject objectForKey:@"Variables"] objectForKey:@"code"] isEqualToString:@"1"]) {
                [MBProgressHUD showInfo:@"操作成功，等待好友确认"];
            } else {
                NSString *message = [[responseObject objectForKey:@"Variables"] objectForKey:@"message"];
                [MBProgressHUD showInfo:message];
            }
            
        } failed:^(NSError *error) {
            [self.HUD hide];
        }];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.section) {
        case 0:
        {
            switch (indexPath.row) {
                case 0:           //他的话题
                {
                    OtherUserThreadViewController *otherUTVC=[[OtherUserThreadViewController alloc]init];
                    otherUTVC.uidstr= _authorid;
                    [self.navigationController pushViewController:otherUTVC animated:YES];
                }
                    break;
                case 1:          //他的回复
                {
                    OtherUserPostReplyViewController *otherUPRVC=[[OtherUserPostReplyViewController alloc]init];
                    otherUPRVC.uidstr=_authorid;
                    [self.navigationController pushViewController:otherUPRVC animated:YES];
                }
                    break;
                    
                default:
                    break;
            }
            
        }
            break;
        case 1:
            
            break;
        case 2:
            
            break;
            
        default:
            break;
    }
}

@end
