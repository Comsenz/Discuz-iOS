//
//  LiveDetailViewController.m
//  DiscuzMobile
//
//  Created by HB on 2017/5/10.
//  Copyright © 2017年 comsenz-service.com.  All rights reserved.
//

#import "LiveDetailViewController.h"
#import "LiveHostCell.h"
#import "UIAlertController+Extension.h"

#import "LiveDetailModel.h"
#import "LiveTipCell.h"
#import "HotLivelistModel.h"
#import "ResponseMessage.h"


NSString * const AttributedTextCellReuseIdentifier = @"AttributedTextCellReuseIdentifier";

@interface LiveDetailViewController()

@property (nonatomic, strong) LiveDetailModel *firstLive;

@end

@implementation LiveDetailViewController
{
	BOOL _useStaticRowHeight;
}

#pragma mark UIViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self loadData];
    
    WEAKSELF;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf refreshData];
    }];
    
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        [weakSelf addData];
    }];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTable) name:@"reloadDTable" object:nil];
	
	//_useStaticRowHeight = YES;
	
	/*
	 if you enable static row height in this demo then the cell height is determined from the tableView.rowHeight. Cells can be reused in this mode.
	 If you disable this then cells are prepared and cached to reused their internal layouter and layoutFrame. Reuse is not recommended since the cells are cached anyway.
	 */
	
	if (_useStaticRowHeight)
	{
		// use a static row height
		self.tableView.rowHeight = 60;
	}
	else
	{
		// establish a cache for prepared cells because heightForRow... and cellForRow... both need the same cell for an index path
		cellCache = [[NSCache alloc] init];
	}
	
	// on iOS 6 we can register the attributed cells for the identifier
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= 60000
	[self.tableView registerClass:[LiveHostCell class] forCellReuseIdentifier:AttributedTextCellReuseIdentifier];
#endif
	
//	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"About" style:UIBarButtonItemStylePlain target:self action:@selector(showAbout:)];
}
- (void)refreshData {
    self.page = 1;
    [self.tableView.mj_footer resetNoMoreData];
    [self loadData];
}

- (void)addData {
    
    self.page ++;
    [self loadData];
    
}

- (void)mj_endRefresh {
    if (self.page == 1) {
        [self.tableView.mj_header endRefreshing];
    } else {
        [self.tableView.mj_footer endRefreshing];
    }
}

- (void)loadData {
    
    if (self.listModel.tid == nil) {
        return;
    }
    if (self.page == 1) {
        
        [self.HUD showLoadingMessag:@"正在加载" toView:self.view];
    }
    
    [DZApiRequest requestWithConfig:^(JTURLRequest *request) {
//        request.urlString = url_LiveDetail;
        request.parameters = @{@"tid":self.listModel.tid,
                               @"page":[NSString stringWithFormat:@"%ld",(long)self.page],
                               @"authorid":self.listModel.authorid};
    } success:^(id responseObject, JTLoadType type) {
        [self mj_endRefresh];
        DLog(@"%@",responseObject);
        
        BOOL haveAuther = [ResponseMessage autherityJudgeResponseObject:responseObject refuseBlock:^(NSString *message) {
            [UIAlertController alertTitle:nil message:message controller:self doneText:@"确定" cancelText:nil doneHandle:^{
                [self.navigationController popViewControllerAnimated:YES];
            } cancelHandle:nil];
            [self.HUD hideAnimated:YES];
        }];
        if (!haveAuther) {
            return;
        }
        
        if ([DataCheck isValidArray:[[responseObject objectForKey:@"Variables"] objectForKey:@"postlist"]]) {
            
            if (self.page == 1) {
                [self.detaiArr removeAllObjects];
            }
            
            if (self.sendParameterBlock) {
                self.sendParameterBlock(responseObject);
            }
            
            //            NSInteger ppp = [[[responseObject objectForKey:@"Variables"] objectForKey:@"ppp"] intValue];
            NSArray *newList = [[responseObject objectForKey:@"Variables"] objectForKey:@"postlist"];
            
            NSInteger *sort = 0;
            for (NSDictionary *listItem in newList) {
                LiveDetailModel *liveModel = [[LiveDetailModel alloc] init];
                [liveModel setValuesForKeysWithDictionary:listItem];
                
                if (sort == 0) {
                    self.listModel.pid = [listItem objectForKey:@"pid"];
                }
                
                
                // 获取附件
                if ([DataCheck isValidDictionary:[listItem objectForKey:@"attachments"]]) {
                    NSDictionary *attachmentsDic = [NSDictionary dictionaryWithDictionary:[listItem objectForKey:@"attachments"]];
                     NSArray *sortArray = [attachmentsDic sortedValueByKeyInDesc:NO];
                    for (NSDictionary *dic in sortArray) {
                        NSString *description = [dic objectForKey:@"description"];
                        if (![[dic objectForKey:@"ext"] isEqualToString:@"mp3"] && ![description containsString:@"recorder|"]) {
                            if ([DataCheck isValidString:dic[@"url"] ] && [DataCheck isValidString:dic[@"attachment"]]) {
                                
                                NSString *picUrl = [NSString stringWithFormat:@"%@%@",dic[@"url"],dic[@"attachment"]];
                                picUrl = [picUrl makeDomain];
                                
                                NSString *thumUrl = [dic[@"thumburl"] makeDomain];
                                [liveModel.imglist addObject:picUrl];
                                [liveModel.thumlist addObject:thumUrl];
                            }
                        }
                    }
                    
                }
                
                if (sort > 0 || newList.count == 1) {
                    // 加入数组
                    if ([liveModel.authorid isEqualToString:self.listModel.authorid]) {
                        [self.detaiArr addObject:liveModel];
                    }
                } else {
                    if (self.page == 1) {
                        if (sort == 0) {
                            self.firstLive = liveModel;
                        }
                    }
                }
                sort ++;
            }
            
        }
        
        [self judgeDataEnd:responseObject];
        [self setDatelineOnDic];
        [self reloadLiveDetail];
        [self emptyShow];
        
    } failed:^(NSError *error) {
        {
            [self showServerError:error];
            [self.HUD hideAnimated:YES];
            [self mj_endRefresh];
        }
    }];
}

// 按时间分组放入字典中
- (void)setDatelineOnDic {
    // 按时间分组放入字典中
    self.dateTimeDic = [NSMutableDictionary dictionary];
    for (LiveDetailModel *model in self.detaiArr) {
        NSString *keyTime = [NSDate timeStringFromTimestamp:model.dbdateline format:@"yyyy年MM月dd日"]; // 年月日相同的做key 放在一个数组
        
        if ([DataCheck isValidArray:[self.dateTimeDic objectForKey:keyTime]]) {
            NSMutableArray *arr = [self.dateTimeDic objectForKey:keyTime];
            [arr addObject:model];
        } else {
            NSMutableArray *arr = [NSMutableArray array];
            [arr addObject:model];
            [self.dateTimeDic setValue:arr forKey:keyTime];
        }
    }
}

- (void)judgeDataEnd:(id)responseObject {
    NSInteger ppp = [[[responseObject objectForKey:@"Variables"] objectForKey:@"ppp"] intValue];
    NSInteger replies = [[[[responseObject objectForKey:@"Variables"] objectForKey:@"thread"] objectForKey:@"replies"] integerValue];
    if(replies  < ppp * (self.page)) {
        if (replies >= 1 && self.firstLive != nil) {
            [self.detaiArr addObject:self.firstLive];
        }
        
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    }
}

// 刷新直播
- (void)reloadLiveDetail {
    if (![DataCheck arrayA:self.detaiArr isEqualArrayB:self.oldArray]) {// 直播
        if (self.detaiArr.count > 0) {
            self.oldArray = [NSMutableArray arrayWithArray:self.detaiArr];
            [self sortLiveDetail];
        }
    } else {
        [self.HUD hideAnimated:YES];
    }
}

- (void)sortLiveDetail {
    
    [self.dataSourceArr removeAllObjects];
    [self.cellHeights removeAllObjects];
    
    [self.dateTimeDic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [self.dataSourceArr addObject:obj];
    }];
    
    // 时间排序
    [self.dataSourceArr sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        
        LiveDetailModel *sort1 = obj1[0];
        LiveDetailModel *sort2 = obj2[0];
        
        if ([sort1.dbdateline integerValue] > [sort2.dbdateline integerValue]) {
            return -1;
        } else if ([sort1.dbdateline integerValue] == [sort2.dbdateline integerValue]) {
            return 0;
        }
        else {
            return 1;
        }
    }];
    
//    if (self.dataSourceArr.count >0) {
//        LiveDetailModel *model = self.dataSourceArr[0][0];
//        model.message = [model.message stringByAppendingString:@"<video src=\"http://images.infzm.com/medias/2016/0115/99657.mp4\" width=\"600\" height=\"400\" controls=\"controls\"> 您的浏览器不支持 video 标签。 </video>"];
//    }
    
//    if (self.dataSourceArr.count >0) {
//        LiveDetailModel *model = self.dataSourceArr[0][0];
//        model.message = [model.message stringByAppendingString:@"<h2>YouTube in IFRAME</h2><iframe title=\"YouTube video player\" class=\"youtube-player\" type=\"text/html\" width=\"640\" height=\"480\" src=\"http://www.youtube.com/embed/4L2IE2YD1wg?color1=d6d6d6&amp;color2=f0f0f0&amp;border=0&amp;fs=1&amp;hl=en&amp;loop=0&amp;showinfo=0&amp;iv_load_policy=3&amp;showsearch=0&amp;rel=1&amp;hd=1\" frameborder=\"0\" allowfullscreen></iframe>"];
//    }
    
    [UIView animateWithDuration:0 animations:^{
        [self.tableView reloadData];
    } completion:^(BOOL finished) {
        [self.HUD hideAnimated:YES];
    }];
}

- (void)reloadTable {
    [self.tableView reloadData];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return YES;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (self.dataSourceArr.count > 0) {
        LiveDetailModel *model = self.dataSourceArr[section][0];
        
        if ([NSDate isToday:model.dbdateline]) {
            return 1;
        }
    }
    
    return 35;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    NSString * headerSection = [NSString stringWithFormat:@"LiveHeader%ld",(long)section];
    LiveTipCell *cell = [tableView dequeueReusableCellWithIdentifier:headerSection];
    if (cell == nil) {
        cell = [[LiveTipCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:headerSection];
    }
    NSString *time = @"";
    
    if (self.dataSourceArr.count > section) {
        LiveDetailModel *model = self.dataSourceArr[section][0];
        
        time = [NSDate isToday:model.dbdateline] ? @"" : [NSDate timeStringFromTimestamp:model.dbdateline format:@"yyyy年MM月dd日"];
    }
    
    [cell setText:time];
    
    return cell;
}

#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSourceArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSArray *arr = self.dataSourceArr[section];
    return arr.count;
}

- (void)configureCell:(LiveHostCell *)cell forIndexPath:(NSIndexPath *)indexPath {
    if (self.dataSourceArr.count > 0) {
        LiveDetailModel *model = self.dataSourceArr[indexPath.section][indexPath.row];
        [cell setInfo:model];
    }
//    cell.attributedTextContextView.shouldDrawImages = YES;
}

- (BOOL)_canReuseCells {
	// reuse does not work for variable height
	if ([self respondsToSelector:@selector(tableView:heightForRowAtIndexPath:)]) {
		return NO;
	}
	// only reuse cells with fixed height
	return YES;
}

- (LiveHostCell *)tableView:(UITableView *)tableView preparedCellForIndexPath:(NSIndexPath *)indexPath {
	// workaround for iOS 5 bug
	NSString *key = [NSString stringWithFormat:@"%ld-%ld", (long)indexPath.section, (long)indexPath.row];
	LiveHostCell *cell = [cellCache objectForKey:key];

	if (!cell) {
		if ([self _canReuseCells]) {
			cell = (LiveHostCell *)[tableView dequeueReusableCellWithIdentifier:AttributedTextCellReuseIdentifier];
		}
	
		if (!cell) {
			cell = [[LiveHostCell alloc] initWithReuseIdentifier:AttributedTextCellReuseIdentifier];
		}
		
		cell.accessoryType = UITableViewCellAccessoryNone;
		cell.hasFixedRowHeight = _useStaticRowHeight;
		
		// cache it, if there is a cache
		[cellCache setObject:cell forKey:key];
	}
	
	[self configureCell:cell forIndexPath:indexPath];
	
	return cell;
}

// disable this method to get static height = better performance
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (_useStaticRowHeight) {
		return tableView.rowHeight;
	}
	
	LiveHostCell *cell = (LiveHostCell *)[self tableView:tableView preparedCellForIndexPath:indexPath];

	return [cell requiredRowHeightInTableView:tableView];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath  {
	LiveHostCell *cell = (LiveHostCell *)[self tableView:tableView preparedCellForIndexPath:indexPath];
	return cell;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (self.hideKeyboard) {
        self.hideKeyboard();
    }
}

#pragma  mark - setter getter
- (NSMutableArray *)oldArray {
    if (!_oldArray) {
        _oldArray = [NSMutableArray array];
    }
    return _oldArray;
}

- (NSMutableArray *)detaiArr {
    if (!_detaiArr) {
        _detaiArr = [NSMutableArray array];
    }
    return _detaiArr;
}

- (NSMutableDictionary *)dateTimeDic {
    if (!_dateTimeDic) {
        _dateTimeDic = [NSMutableDictionary dictionary];
    }
    return _dateTimeDic;
}

@end
