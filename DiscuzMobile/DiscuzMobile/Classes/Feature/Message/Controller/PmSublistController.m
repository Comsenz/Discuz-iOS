//
//  PmSublistController.m
//  DiscuzMobile
//
//  Created by HB on 2017/7/17.
//  Copyright © 2017年 comsenz-service.com.  All rights reserved.
//

#import "PmSublistController.h"
#import "PmTypeModel.h"
#import "MessageListModel.h"
#import "MessageCell.h"
#import "systemNoteCell.h"
#import "MsglistCell.h"
#import "ThreadViewController.h"

#import "ChatDetailController.h"
#import "SendMessageViewController.h"
#import "MessageNoticeCenter.h"

@interface PmSublistController ()
@end

@implementation PmSublistController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([self.typeModel.module isEqualToString:@"mypm"]) {
        [self createBarBtn:@"发消息" type:NavItemText Direction:NavDirectionRight];
    }
    
    [self loadData];
    WEAKSELF;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.page = 1;
        [weakSelf loadData];
    }];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        weakSelf.page ++;
        [weakSelf loadData];
    }];
    self.tableView.mj_footer.hidden = YES;
    [self.HUD showLoadingMessag:@"正在加载" toView:self.view];
}

-(void)rightBarBtnClick{
    SendMessageViewController *sendVC = [[SendMessageViewController alloc] init];
    [self.navigationController pushViewController:sendVC animated:YES];
}

- (void)loadData {
    NSMutableArray *parameter = [NSMutableArray array];
    NSString *urlString = @"";
    if ([self.typeModel.module isEqualToString:@"mypm"]) { // 我的消息
        
        parameter = @{@"page":[NSString stringWithFormat:@"%ld",self.page],
                      @"filter":self.typeModel.filter}.mutableCopy;
        urlString = url_MsgList;
    } else if ([self.typeModel.view isEqualToString:@"mypost"]) {// 我的帖子
        parameter = @{@"page":[NSString stringWithFormat:@"%ld",self.page],
                      @"type":self.typeModel.type}.mutableCopy;
        urlString = url_ThreadMsgList;
        
    } else if ([self.typeModel.view isEqualToString:@"interactive"]) {// 坛友互动
        parameter = @{@"page":[NSString stringWithFormat:@"%ld",self.page],
                      @"type":self.typeModel.type}.mutableCopy;
        urlString = url_InteractiveMsgList;
        
    } else if ([self.typeModel.view isEqualToString:@"system"] || [self.typeModel.view isEqualToString:@"manage"]) {// 系统提醒 | 管理工作
        
        parameter = @{@"page":[NSString stringWithFormat:@"%ld",self.page],
                      @"view":self.typeModel.view}.mutableCopy;
        urlString = url_SystemMsgList;
    }
    
    [DZApiRequest requestWithConfig:^(JTURLRequest *request) {
        request.urlString = urlString;
        request.methodType = JTMethodTypePOST;
        request.parameters = parameter;
    } success:^(id responseObject, JTLoadType type) {
        [self anylyeData:responseObject];
    } failed:^(NSError *error) {
        [self errorDo:error];
    }];
}

- (void)anylyeData:(id)responseObject {
    [self.HUD hideAnimated:YES];
    [self mj_endRefreshing];
    
    NSArray *arr = [[responseObject objectForKey:@"Variables"] objectForKey:@"list"];
    if ([DataCheck isValidArray:arr]) {
        
        if (self.page == 1) {
            self.dataSourceArr = [NSMutableArray array];
        }
        
        for (NSDictionary *dic in arr) {
            MessageListModel *model = [[MessageListModel alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            [self.dataSourceArr addObject:model];
        }
    }
    
    if ([DataCheck isValidString:[[responseObject objectForKey:@"Variables"] objectForKey:@"count"]]) {
        NSInteger count = [[[responseObject objectForKey:@"Variables"] objectForKey:@"count"] integerValue];
        if (self.dataSourceArr.count >= count) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
    }
    
    [self emptyShow];
    [self.tableView reloadData];
}

- (void)mj_endRefreshing {
    if (self.page == 1) {
        [self.tableView.mj_header endRefreshing];
    } else {
        [self.tableView.mj_footer endRefreshing];
    }
}

- (void)errorDo:(NSError *)error {
    [self.HUD hideAnimated:YES];
    [self emptyShow];
    [self showServerError:error];
    [self mj_endRefreshing];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.typeModel.module isEqualToString:@"mypm"]) {
        UITableViewCell * cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
        return [(MessageCell *)cell cellHeight];
//        return 70.0;
    }
    else {
        UITableViewCell * cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
        return [(MsglistCell *)cell cellHeight];
    }
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSourceArr.count;
}


-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * CellId = @"CellId";
    static NSString *alertId = @"alertId";
    
    MessageListModel *model = self.dataSourceArr[indexPath.row];
    
    if ([self.typeModel.module isEqualToString:@"mypm"]) {
        
        
        MessageCell *cell = [tableView dequeueReusableCellWithIdentifier:CellId];
        if (cell == nil) {
            cell = [[MessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellId];
        }
        
        [cell setData:model];
        return cell;
    }
    else {
        
        MsglistCell *cell = [tableView dequeueReusableCellWithIdentifier:alertId];
        if (cell == nil) {
            cell = [[MsglistCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:alertId];
        }
        
        [cell setData:model];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    MessageListModel *model = self.dataSourceArr[indexPath.row];
    
    if ([DataCheck isValidString:self.typeModel.filter] && [self.typeModel.filter isEqualToString:@"privatepm"]) {
        
        ChatDetailController *mvc = [[ChatDetailController alloc] init];
        mvc.touid = model.touid;
        mvc.nametitle = model.tousername;
        mvc.username = model.tousername;
        
        [self.navigationController pushViewController:mvc animated:YES];
    }
    
    if ([DataCheck isValidString:self.typeModel.view] && [self.typeModel.view isEqualToString:@"mypost"]) {
        if ([DataCheck isValidDictionary:model.notevar]) {
            if ([DataCheck isValidString:[model.notevar objectForKey:@"tid"]]) {
                ThreadViewController *threadVC = [[ThreadViewController alloc] init];
                threadVC.tid = [model.notevar objectForKey:@"tid"];
                [self showViewController:threadVC sender:nil];
            }
            
        } else {
            //                model.note
            NSArray *arr = [model.note componentsSeparatedByString:@"tid="];
            if (arr.count >= 2) {
                ThreadViewController *threadVC = [[ThreadViewController alloc] init];
                NSString *containTid = arr[1];
                
                NSString *tid = [containTid componentsSeparatedByString:@"\" "][0];
                
                if ([tid isNum:tid]) {
                    threadVC.tid = tid;
                    [self showViewController:threadVC sender:nil];
                }
               
            }
        }
    }
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([self.typeModel.module isEqualToString:@"mypm"]) {
        
        return UITableViewCellEditingStyleDelete;
    }
    
    return UITableViewCellEditingStyleNone;
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    
    if ([self.typeModel.module isEqualToString:@"mypm"]) {
        
        [self.tableView setEditing:YES animated:animated];
    }
    
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        [self deletePmessage:indexPath];
    }
}


- (void)deletePmessage:(NSIndexPath *)indexPath {
    
    [DZApiRequest requestWithConfig:^(JTURLRequest *request) {
        MessageListModel *model = self.dataSourceArr[indexPath.row];
        NSDictionary *parameters = @{@"id":model.touid,@"formhash":[Environment sharedEnvironment].formhash};
        request.urlString = url_DeleteMessage;
        request.methodType = JTMethodTypePOST;
        request.parameters = parameters;
    } success:^(id responseObject, JTLoadType type) {
        NSString *messageval = [responseObject messageval];
        
        if ([messageval containsString:@"succeed"] || [messageval containsString:@"success"]){
            [self.dataSourceArr removeObjectAtIndex:indexPath.row];
            [self.tableView beginUpdates];
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
            [self.tableView endUpdates];
        } else {
            [MBProgressHUD showInfo:@"删除失败"];
        }
    } failed:^(NSError *error) {
        [self showServerError:error];
    }];
}

@end
