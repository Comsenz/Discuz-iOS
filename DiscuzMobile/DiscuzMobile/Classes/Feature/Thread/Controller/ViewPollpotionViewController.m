//
//  ViewPollpotionViewController.m
//  DiscuzMobile
//
//  Created by gensinimac1 on 15/8/24.
//  Copyright (c) 2015年 Cjk. All rights reserved.
//

#import "ViewPollpotionViewController.h"
#import "ViewPollpotionCell.h"
#import "LoginController.h"
#import "SendMessageViewController.h"
#import "ResponseMessage.h"
#import "UIAlertController+Extension.h"

@interface ViewPollpotionViewController()<ViewPollpotionCellDelegate>

@property (strong,nonatomic)UITableView *tableview;
@property (strong,nonatomic)NSArray *array;
@property (strong,nonatomic)NSArray *arrayImage;

@end

@implementation ViewPollpotionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self downLoadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSourceArr.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString * CellID= @"viewReplyCellID";
    ViewPollpotionCell * cell = [tableView dequeueReusableCellWithIdentifier:CellID];
    if (cell == nil) {
        cell = [[ViewPollpotionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.delegate=self;
    NSDictionary * dic = [self.dataSourceArr objectAtIndex:indexPath.row];
    CGRect rect = cell.frame;
    [cell setdata:dic];
    rect.size.height = [cell cellheigh];
    cell.frame = rect;
    return cell;
}

- (void)ViewPollpotionCellClick:(ViewPollpotionCell *)cell {
    
    if (![self isLogin]) {
        return;
    }
    SendMessageViewController * senVC=[[SendMessageViewController alloc]init];
    if ([DataCheck isValidString:cell.nameLabel.text]) {
         senVC.uid = cell.nameLabel.text;
    }
    [self.navigationController pushViewController:senVC animated:YES];
}

- (void)downLoadData {
    
    [DZApiRequest requestWithConfig:^(JTURLRequest *request) {
        NSDictionary *postDic = @{@"tid":self.tid,
                                  @"polloptionid":self.pollid
                                  };
        request.urlString = url_VoteOptionDetail;
        request.parameters = postDic;
        [self.HUD showLoadingMessag:@"正在加载" toView:self.view];
    } success:^(id responseObject, JTLoadType type) {
        [self.HUD hide];
        BOOL haveAuther = [ResponseMessage autherityJudgeResponseObject:responseObject refuseBlock:^(NSString *message) {
            [UIAlertController alertTitle:nil message:message controller:self doneText:@"知道了" cancelText:nil doneHandle:^{
                [self.navigationController popViewControllerAnimated:YES];
            } cancelHandle:nil];
        }];
        if (!haveAuther) {
            return;
        }
        if ([DataCheck isValidArray:[[[responseObject objectForKey:@"Variables"] objectForKey:@"viewvote"] objectForKey:@"voterlist"]]) {
            self.dataSourceArr = [[[responseObject objectForKey:@"Variables"] objectForKey:@"viewvote"] objectForKey:@"voterlist"];
        }
        
        [self.tableView reloadData];
        [self emptyShow];
    } failed:^(NSError *error) {
        [self.HUD hide];
        [self showServerError:error];
        [self emptyShow];
    }];
}

@end
