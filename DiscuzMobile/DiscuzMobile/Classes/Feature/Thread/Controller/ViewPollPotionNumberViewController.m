//
//  ViewPollPotionNumberViewController.m
//  DiscuzMobile
//
//  Created by gensinimac1 on 15/8/24.
//  Copyright (c) 2015年 Cjk. All rights reserved.
//

#import "ViewPollPotionNumberViewController.h"
#import "ViewPollpotionViewController.h"

@interface ViewPollPotionNumberViewController()

@end

@implementation ViewPollPotionNumberViewController


- (void)viewDidLoad{
    [super viewDidLoad];
    self.navigationItem.title = @"查看投票参与人";
    
    [self downLoadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSourceArr.count;
}


- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * CellID= @"PostReplyCellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    NSDictionary *dic = self.dataSourceArr[indexPath.row];

    cell.textLabel.text=[NSString stringWithFormat:@"选择第%ld项的人",indexPath.row+1];
    cell.textLabel.font=[FontSize HomecellTitleFontSize15];
    cell.detailTextLabel.text = [dic objectForKey:@"votes"];
    cell.detailTextLabel.font = [FontSize messageFontSize14];
    cell.detailTextLabel.textColor = MAIN_COLLOR;
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *pollidNumber= [[self.dataSourceArr objectAtIndex:indexPath.row] objectForKey:@"polloptionid"];
    NSString * tid =[[self.dataSourceArr objectAtIndex:indexPath.row] objectForKey:@"tid"];
    ViewPollpotionViewController *vc=[[ViewPollpotionViewController alloc]init];
    vc.pollid=pollidNumber;
    vc.tid=tid;
    vc.title = [NSString stringWithFormat:@"选择第%ld项目的人",indexPath.row + 1];
    [self.navigationController pushViewController:vc animated:YES];

}

- (void)downLoadData {
    [DZApiRequest requestWithConfig:^(JTURLRequest *request) {
        NSDictionary *getDic = @{@"tid":self.tid};
        request.parameters = getDic;
        request.urlString = url_VoteOptionDetail;
        [self.HUD showLoadingMessag:@"正在加载" toView:self.view];
    } success:^(id responseObject, JTLoadType type) {
        [self.HUD hide];
        self.dataSourceArr= [[[responseObject objectForKey:@"Variables"] objectForKey:@"viewvote"] objectForKey:@"polloptions"];
        [self.tableView reloadData];
    } failed:^(NSError *error) {
        [self.HUD hide];
    }];
}

@end
