//
//  ManageActivityController.m
//  DiscuzMobile
//
//  Created by HB on 2017/7/28.
//  Copyright © 2017年 comsenz-service.com.  All rights reserved.
//

#import "ManageActivityController.h"
#import "ActivityApplyCell.h"
#import "ApplyActiver.h"
#import "ExamineActivityView.h"

@interface ManageActivityController ()

@property (nonatomic, strong) ExamineActivityView *examineView;

@end

@implementation ManageActivityController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"报名管理";
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = mRGBColor(249, 251, 253);
    
    self.examineView = [[ExamineActivityView alloc] init];
    [self.examineView.allowBtn addTarget:self action:@selector(allowAction) forControlEvents:UIControlEventTouchUpInside];
    [self.examineView.rejectBtn addTarget:self action:@selector(rejectAction) forControlEvents:UIControlEventTouchUpInside];
    [self loadData];
    // Do any additional setup after loading the view.
}

- (void)allowAction {
    
    [self oprationApply:0];
}

- (void)rejectAction {
    [self oprationApply:1];
}

//operation 空批准  replenish 需完善 notification 发通知. delete拒绝
- (void)oprationApply:(NSInteger)type {
    
    NSString *operation = @"";
    if (type == 1) {
        operation = @"delete";
    }
    
    NSString *reason = @"";
    if ([DataCheck isValidString:self.examineView.reason]) {
        reason = self.examineView.reason;
    }
    
    NSDictionary *postDic = @{@"formhash":[Environment sharedEnvironment].formhash,
                              @"handlekey":@"activity",
                              @"applyidarray[]":self.examineView.dataModel.applyid,
                              @"reason":reason,
                              @"operation":operation};
    NSDictionary *getDic = @{@"tid":self.threadModel.tid,
                             @"applylistsubmit":@"yes"};
    [DZApiRequest requestWithConfig:^(JTURLRequest *request) {
        [self.HUD showLoadingMessag:@"处理中，请稍候" toView:self.view];
        request.urlString = url_ManageActivity;
        request.parameters = postDic;
        request.getParam = getDic;
        request.methodType = JTMethodTypePOST;
    } success:^(id responseObject, JTLoadType type) {
        [self.HUD hide];
        if ([[responseObject messageval] containsString:@"_completion"]) {
            [MBProgressHUD showInfo:[responseObject messagestr]];
            [self.examineView close];
            
            [self loadData];
        }
        
    } failed:^(NSError *error) {
        [self.HUD hide];
        [self showServerError:error];
    }];
}

- (void)loadData {
    
    NSDictionary *getDic = @{@"tid":self.threadModel.tid,
                             @"pid":self.threadModel.pid};
    
    if (self.dataSourceArr.count > 0) {
        [self.dataSourceArr removeAllObjects];
    }
    
    [DZApiRequest requestWithConfig:^(JTURLRequest *request) {
        [self.HUD showLoadingMessag:@"加载中" toView:self.view];
        request.urlString = url_ManageActivity;
        request.parameters = getDic;
    } success:^(id responseObject, JTLoadType type) {
        [self.HUD hide];
        if ([DataCheck isValidArray:[[[responseObject objectForKey:@"Variables"] objectForKey:@"activityapplylist"] objectForKey:@"applylist"]]) {
            NSArray *arr = [[[responseObject objectForKey:@"Variables"] objectForKey:@"activityapplylist"] objectForKey:@"applylist"];
            for (NSDictionary *dic in arr) {
                ApplyActiver *apply = [[ApplyActiver alloc] init];
                [apply setValuesForKeysWithDictionary:dic];
                NSDictionary *ufieldDic = [[[self.threadModel.threadDic objectForKey:@"Variables"] objectForKey:@"special_activity"] objectForKey:@"ufield"];
                if ([DataCheck isValidDictionary:ufieldDic]) {
                    if ([DataCheck isValidArray:[ufieldDic objectForKey:@"userfield"]]){
                        apply.userfield = [ufieldDic objectForKey:@"userfield"];
                    }
                }
                
                [self.dataSourceArr addObject:apply];
            }
            
            [self.tableView reloadData];
        }
        
    } failed:^(NSError *error) {
        [self.HUD hide];
        [self showServerError:error];
    }];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSourceArr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"applyCell";
    ActivityApplyCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[ActivityApplyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    ApplyActiver *apply = self.dataSourceArr[indexPath.row];
    [cell setInfo:apply];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.dataSourceArr.count > indexPath.row) {
        ApplyActiver *apply = self.dataSourceArr[indexPath.row];
        [self.examineView show];
        self.examineView.dataModel = apply;
    }
}

@end
