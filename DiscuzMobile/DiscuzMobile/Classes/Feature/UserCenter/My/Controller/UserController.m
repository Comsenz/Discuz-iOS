//
//  UserController.m
//  DiscuzMobile
//
//  Created by HB on 17/1/19.
//  Copyright © 2017年 comsenz-service.com.  All rights reserved.
//

#import "UserController.h"
#import "UIAlertController+Extension.h"
#import "CenterToolView.h"
#import "VerticalImageTextView.h"
#import "MYCenterHeader.h"
#import "LogoutCell.h"
#import "CenterCell.h"

#import "MyFriendViewController.h"
#import "CollectionRootController.h"
#import "ThreadRootController.h"
#import "LoginController.h"
#import "BoundManageController.h"
#import "PmListController.h"
#import "SettingViewController.h"
#import "FootRootController.h"
#import "ResetPwdController.h"

#import "TextIconModel.h"
#import "CenterUserInfoView.h"
#import "CenterManageModel.h"

#import "ImagePickerView.h"
#import "MessageNoticeCenter.h"
#import "UIImage+Limit.h"

@interface UserController ()

@property (nonatomic, strong) MYCenterHeader *myHeader;
@property (nonatomic, strong) CenterManageModel *centerModel;
@property (nonatomic, strong) ImagePickerView *pickerView;    // 相机相册

@end

@implementation UserController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavc];
    
    // 135 + 85
    self.myHeader = [[MYCenterHeader alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 220)];
    self.tableView.tableHeaderView = self.myHeader;
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(modifyAvatar)];
    [self.myHeader.userInfoView.headView addGestureRecognizer:tapGes];
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 40)];
    
    [self tooBarAction];
    
    [self.HUD showLoadingMessag:@"拉取信息" toView:self.view];
    [self downLoadData];
    
    WEAKSELF;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf downLoadData];
    }];
    
    [self addNotify];
}

- (void)addNotify {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notiReloadData) name:REFRESHCENTER object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(signout) name:SIGNOUTNOTIFY object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notiReloadData) name:DOMAINCHANGE object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - 设置导航栏
-(void)setNavc{
    [self createBarBtn:@"" type:NavItemText Direction:NavDirectionLeft];
    [self createBarBtn:@"setting" type:NavItemImage Direction:NavDirectionRight];
    
    self.navigationItem.title = @"我的";
}

- (void)rightBarBtnClick {
    
    SettingViewController * svc = [[SettingViewController alloc] init];
    [self.navigationController pushViewController:svc animated:YES];
}

- (void)notiReloadData {
    [self.tableView setContentOffset:CGPointMake(0, 0) animated:YES];
    [self downLoadData];
}

- (void)initData {
    self.centerModel = [[CenterManageModel alloc] initWithType:JTCenterTypeMy];
}

// toobar 点击事件
- (void)tooBarAction {
    WEAKSELF;
    self.myHeader.tooView.toolItemClickBlock = ^(VerticalImageTextView *sender, NSInteger index, NSString *name) {
        
        if (![weakSelf isLogin]) {
            return;
        }
        switch (index) {
            case 0:          //我的好友
            {
                MyFriendViewController *mfvc = [[MyFriendViewController alloc] init];
                [weakSelf.navigationController pushViewController:mfvc animated:YES];
            }
                break;
            case 1:          //我的收藏
            {
                CollectionRootController *mfvc = [[CollectionRootController alloc] init];
                [weakSelf.navigationController pushViewController:mfvc animated:YES];
            }
                break;
            case 2:          //我的提醒
            {

                PmListController *pmVC = [[PmListController alloc] init];
                [weakSelf.navigationController pushViewController:pmVC animated:YES];
            }
                break;
            case 3:          //我的主题
            {
                ThreadRootController *trVc = [[ThreadRootController alloc] init];
                trVc.hidesBottomBarWhenPushed = YES;
                [weakSelf.navigationController pushViewController:trVc animated:YES];
            }
                break;
                
            default:
                break;
        }
        
    };
}

-(void)downLoadData {
    
    [self initData];
    static NSInteger requestCount = 0;
    [DZApiRequest requestWithConfig:^(JTURLRequest *request) {
        request.methodType = JTMethodTypePOST;
        request.urlString = url_UserInfo;
    } success:^(id responseObject, JTLoadType type) {
        requestCount = 0;
        [self.HUD hide];
        [self.tableView.mj_header endRefreshing];
        
        if ([[[responseObject objectForKey:@"Message"] objectForKey:@"messagestr"] isEqualToString:@"请先登录后才能继续浏览"]) {
            [self signout];
            [self initLogin];
            return ;
        } else if ([DataCheck isValidString:[responseObject objectForKey:@"error"]]){
            if ([[responseObject objectForKey:@"error"] isEqualToString:@"user_banned"]) {
                [MBProgressHUD showInfo:@"用户被禁止"];
            }
            [self signout];
            [self initLogin];
            return;
        }
        [self.centerModel dealData:responseObject];
        [Environment sharedEnvironment].member_avatar = [self.centerModel.myInfoDic objectForKey:@"member_avatar"];
        self.myHeader.userInfoView.nameLab.text = [[self.centerModel.myInfoDic objectForKey:@"space"] objectForKey:@"username"];
        [self.myHeader.userInfoView setIdentityText:[[[self.centerModel.myInfoDic objectForKey:@"space"] objectForKey:@"group"] objectForKey:@"grouptitle"]];
        [self.myHeader.userInfoView.headView sd_setImageWithURL:[NSURL URLWithString:[Environment sharedEnvironment].member_avatar] placeholderImage:[UIImage imageNamed:@"noavatar_small"] options:SDWebImageRefreshCached];
        
        [self.tableView reloadData];
        
    } failed:^(NSError *error) {
        requestCount ++;
        if (requestCount == 5) {
            [self signout];
            [self initLogin];
        }
        [self.HUD hide];
        [self.tableView.mj_header endRefreshing];
        [self showServerError:error];
        [self.tableView reloadData];
        
    }];
}

#pragma mark - tableView delegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 2) {
        return 60;
    }
    return 50.0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 5.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 0){
        
        return self.centerModel.manageArr.count;
        
    } else if (section == 1) {
        
        return self.centerModel.infoArr.count;
        
    } else if (self.centerModel.myInfoDic.count > 0) {
        
        return 1;
        
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellID = @"CenterID";
    static NSString *LogoutID = @"LogoutID";
    
    if (indexPath.section == 0 || indexPath.section == 1) {
        CenterCell *cell = [tableView dequeueReusableCellWithIdentifier:CellID];
        if (cell == nil) {
            cell = [[CenterCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellID];
        }
        TextIconModel *model;
        cell.accessoryType = UITableViewCellAccessoryNone;
        if (indexPath.section == 0) {
            if (indexPath.row == 0) {
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
            model = self.centerModel.manageArr[indexPath.row];
        } else if (indexPath.section == 1) {
            if (self.centerModel.infoArr.count > indexPath.row) {
                model = self.centerModel.infoArr[indexPath.row];
            }
        }
        [cell setData:model];
        return cell;
        
    } else {
        LogoutCell *cell = [tableView dequeueReusableCellWithIdentifier:LogoutID];
        if (cell == nil) {
            cell = [[LogoutCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:LogoutID];
        }
        cell.lab.text = @"退出";
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            BoundManageController *boundVc = [[BoundManageController alloc] init];
            boundVc.hidesBottomBarWhenPushed = YES;
            [self showViewController:boundVc sender:nil];
        }
        
        if (indexPath.row == 1) {
            return;
            ResetPwdController *restVc = [[ResetPwdController alloc] init];
            restVc.hidesBottomBarWhenPushed = YES;
            [self showViewController:restVc sender:nil];
        }
        
        if (indexPath.row == 2) {
            FootRootController *footRvc = [[FootRootController alloc] init];
            footRvc.hidesBottomBarWhenPushed = YES;
            [self showViewController:footRvc sender:nil];
        }
    }
    
    if (indexPath.section == 2) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
        NSString *message = @"您确定退出？退出将不能体验全部功能。";
        NSString *donetip = @"退出";

        [UIAlertController alertTitle:@"提示" message:message controller:self doneText:donetip cancelText:@"取消" doneHandle:^{
            [self signout];
        } cancelHandle:nil];
    }
}

- (void)signoutAction {
    NSString *message = @"您确定退出？退出将不能体验全部功能。";
    NSString *donetip = @"确定";
    [UIAlertController alertTitle:@"提示" message:message controller:self doneText:donetip cancelText:@"取消" doneHandle:^{
        [self signout];
    } cancelHandle:nil];
}

- (void)modifyAvatar {
    WEAKSELF;
    self.pickerView.finishPickingBlock = ^(UIImage *image) {
        [weakSelf uploadImage:image];
    };
    [self.pickerView openSheet];
}

- (void)uploadImage:(UIImage *)image {
    
    [self.HUD showLoadingMessag:@"上传中" toView:self.view];
    [DZApiRequest requestWithConfig:^(JTURLRequest *request) {
        
        NSData *data = [image limitImageSize];
        NSString *nowTime = [[NSDate date] stringFromDateFormat:@"yyyyMMddHHmmss"];
        NSString *fileName = [NSString stringWithFormat:@"%@.png", nowTime];
        [request addFormDataWithName:@"Filedata" fileName:fileName mimeType:@"image/png" fileData:data];
        
        request.urlString = url_UploadHead;
        request.methodType = JTMethodTypeUpload;
    } progress:^(NSProgress *progress) {
        if (100.f * progress.completedUnitCount/progress.totalUnitCount == 100) {
            //            complete?complete():nil;
        }
    } success:^(id responseObject, JTLoadType type) {
        [self.HUD hide];
        id resDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        if ([DataCheck isValidDictionary:resDic] && [[[resDic objectForKey:@"Variables"] objectForKey:@"uploadavatar"] containsString:@"success"] ) {
            [MBProgressHUD showInfo:@"上传成功"];
            self.myHeader.userInfoView.headView.image = image;
        }
        
    } failed:^(NSError *error) {
        [self.HUD hide];
        [MBProgressHUD showInfo:@"上传失败"];
    }];
}

- (void)signout {
    [LoginModule signout];
    [self initData];
    [self.tableView reloadData];
    [self initLogin];
    [[NSNotificationCenter defaultCenter] postNotificationName:COLLECTIONFORUMREFRESH object:nil];
}

- (void)initLogin {
    
    LoginController *login = [[LoginController alloc] init];
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:login];
    [self presentViewController:nc animated:YES completion:nil];
}

- (ImagePickerView *)pickerView {
    if (_pickerView == nil) {
        _pickerView = [[ImagePickerView alloc] init];
        _pickerView.navigationController = self.navigationController;
    }
    return _pickerView;
}

@end
