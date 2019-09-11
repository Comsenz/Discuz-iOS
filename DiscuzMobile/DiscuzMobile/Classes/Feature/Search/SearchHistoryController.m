//
//  SearchHistoryController.m
//  DiscuzMobile
//
//  Created by ZhangJitao on 2018/7/11.
//  Copyright © 2018年 comsenz-service.com.  All rights reserved.
//

#import "SearchHistoryController.h"
#import "UIAlertController+Extension.h"
#import <YYKit/UIColor+YYAdd.h>
#import "UIButton+EnlargeEdge.h"

#define TTSEARCH_SEARCH_HISTORY_CACHE_PATH [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"TTSearchhistories.plist"]

#define SEARCH_REALY_SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SEARCH_MARGIN 15
#define RectangleTagMaxCol 3
#define SEARCH_COLORPolRandomColor self.colorPol[arc4random_uniform((uint32_t)self.colorPol.count)]

@interface SearchHistoryController ()
@property (nonatomic, copy) NSString *searchHistoryCachePath;
@property (nonatomic, strong) NSMutableArray *searchHistories;

@property (nonatomic, strong) NSMutableArray *hotSearches;
@property (nonatomic, strong) UIView *hotSearchView;
@property (nonatomic, strong) NSMutableArray *hotSearchTags;
@property (nonatomic, strong) NSMutableArray<UIColor *> *colorPol;

@end

@implementation SearchHistoryController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.searchHistoryCachePath = TTSEARCH_SEARCH_HISTORY_CACHE_PATH;
    }
    return self;
}

#pragma mark - lifeCyle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.hotSearches = @[@"discuz",@"App",@"微社区",@"小程序",@"定制开发",@"应用中心",@"插件"].mutableCopy;
    self.hotSearchTags = [self addAndLayoutTagsWithTagsContentView:self.hotSearchView tagTexts:self.hotSearches].mutableCopy;
    [self setHotSearchStyle];
    
    UILabel *tipLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 40)];
    tipLab.textAlignment = NSTextAlignmentCenter;
    tipLab.font = [UIFont systemFontOfSize:14];
    tipLab.textColor = MESSAGE_COLOR;
    tipLab.text = @"清空历史";
    tipLab.userInteractionEnabled = YES;
    [tipLab addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clearSearchHistory)]];
    self.tableView.tableFooterView = tipLab;
    if (![DataCheck isValidArray:self.searchHistories]) {
        self.tableView.tableFooterView.hidden = YES;
    }
}

- (NSArray *)addAndLayoutTagsWithTagsContentView:(UIView *)contentView tagTexts:(NSArray<NSString *> *)tagTexts {
    contentView = self.hotSearchView;
    [contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    NSMutableArray *tagsM = [NSMutableArray array];
    for (int i = 0; i < tagTexts.count; i++) {
        UILabel *label = [self labelWithTitle:tagTexts[i]];
        [label addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tagDidCLick:)]];
        [contentView addSubview:label];
        [tagsM addObject:label];
    }
    contentView.width = WIDTH - 30;
    CGFloat currentX = 0;
    CGFloat currentY = 0;
    CGFloat countRow = 0;
    CGFloat countCol = 0;
    
    for (int i = 0; i < contentView.subviews.count; i++) {
        UILabel *subView = contentView.subviews[i];
        // When the number of search words is too large, the width is width of the contentView
        if (subView.width > contentView.width) subView.width = contentView.width;
        if (currentX + subView.width + SEARCH_MARGIN * countRow > contentView.width) {
            subView.x = 0;
            subView.y = (currentY += subView.height) + SEARCH_MARGIN * ++countCol;
            currentX = subView.width;
            countRow = 1;
        } else {
            subView.x = (currentX += subView.width) - subView.width + SEARCH_MARGIN * countRow;
            subView.y = currentY + SEARCH_MARGIN * countCol;
            countRow ++;
        }
    }
    
    contentView.height = CGRectGetMaxY(contentView.subviews.lastObject.frame);
    contentView.x = SEARCH_MARGIN;
    contentView.y = 40;
    
    UIView *headView = [[UIView alloc] init];
    headView.width = WIDTH;
    headView.height = contentView.height + 40;
    
    UILabel *tipLab = [[UILabel alloc] initWithFrame:CGRectMake(SEARCH_MARGIN, 10, WIDTH - 30, 20)];
    tipLab.textColor = MESSAGE_COLOR;
    tipLab.font = [UIFont systemFontOfSize:14];
    tipLab.text = @"热门搜索";
    [headView addSubview:tipLab];
    [headView addSubview:self.hotSearchView];
    
    self.tableView.tableHeaderView.height = headView.height;
    self.tableView.tableHeaderView.hidden = NO;
    [self.tableView setTableHeaderView:headView];
    return [tagsM copy];
}

- (void)tagDidCLick:(UITapGestureRecognizer *)sender {
    UILabel *lab = (UILabel *)sender.view;
    if ([DataCheck isValidString:lab.text]) {
        self.SearchClick?self.SearchClick(lab.text):nil;
    }
}

- (void)setHotSearchStyle {
    for (UILabel *tag in self.hotSearchTags) {
        tag.textColor = [UIColor whiteColor];
        tag.layer.borderColor = nil;
        tag.layer.borderWidth = 0.0;
        tag.backgroundColor = SEARCH_COLORPolRandomColor;
    }
}

- (UILabel *)labelWithTitle:(NSString *)title {
    UILabel *label = [[UILabel alloc] init];
    label.userInteractionEnabled = YES;
    label.font = [UIFont systemFontOfSize:12];
    label.text = title;
    label.textColor = [UIColor grayColor];
    label.backgroundColor = SEARCH_COLORPolRandomColor;
    label.layer.cornerRadius = 3;
    label.clipsToBounds = YES;
    label.textAlignment = NSTextAlignmentCenter;
    [label sizeToFit];
    label.width += 20;
    label.height += 14;
    return label;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.searchHistories.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[UITableViewCell getReuseId]];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[UITableViewCell getReuseId]];
        cell.textLabel.textColor = MESSAGE_COLOR;
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.imageView.image = [UIImage imageNamed:@"search_history"];
    }
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    closeBtn.size = CGSizeMake(12, 12);
    [closeBtn setEnlargeEdge:14];
    [closeBtn setImage:[UIImage imageNamed:@"type_close"] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(deleteSearch:) forControlEvents:UIControlEventTouchUpInside];
    cell.accessoryView = closeBtn;
    cell.textLabel.text = self.searchHistories[indexPath.row];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if ([DataCheck isValidArray:self.searchHistories]) {
        UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 30)];
        UILabel *tipLab = [[UILabel alloc] initWithFrame:CGRectMake(SEARCH_MARGIN, SEARCH_MARGIN, WIDTH - 30, 15)];
        tipLab.font = [UIFont systemFontOfSize:14];
        tipLab.textColor = MESSAGE_COLOR;
        [headView addSubview:tipLab];
        tipLab.text = @"搜索历史";
        return headView;
    } else {
        UIView *v = [UIView new];
        v.backgroundColor = [UIColor whiteColor];
        return v;
    }
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *searchText = self.searchHistories[indexPath.row];
    self.SearchClick?self.SearchClick(searchText):nil;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    self.ScrollWillDrag?self.ScrollWillDrag():nil;
}

#pragma mark - Action
- (void)saveSearchHistory:(NSString *)searchText {
    [self.searchHistories removeObject:searchText];
    [self.searchHistories insertObject:searchText atIndex:0];
    [NSKeyedArchiver archiveRootObject:self.searchHistories toFile:self.searchHistoryCachePath];
    [self.tableView reloadData];
    self.tableView.tableFooterView.hidden = NO;
}

- (void)deleteSearch:(UIButton *)sender {
    UITableViewCell *cell = (UITableViewCell *)sender.superview;
    [self.searchHistories removeObject:cell.textLabel.text];
    [NSKeyedArchiver archiveRootObject:self.searchHistories toFile:self.searchHistoryCachePath];
    [self.tableView reloadData];
    if (![DataCheck isValidArray:self.searchHistories]) {
        self.tableView.tableFooterView.hidden = YES;
    }
}

- (void)clearSearchHistory {
    [UIAlertController alertTitle:@"提示" message:@"确定清空历史记录？" controller:self doneText:@"确定" cancelText:@"取消" doneHandle:^{
        [self.searchHistories removeAllObjects];
        [NSKeyedArchiver archiveRootObject:self.searchHistories toFile:self.searchHistoryCachePath];
        [self.tableView reloadData];
        self.tableView.tableFooterView.hidden = YES;
    } cancelHandle:nil];
}

- (NSMutableArray *)searchHistories {
    if (!_searchHistories) {
        _searchHistories = [NSMutableArray arrayWithArray:[NSKeyedUnarchiver unarchiveObjectWithFile:self.searchHistoryCachePath]];
    }
    return _searchHistories;
}


- (NSMutableArray *)hotSearches {
    if (!_hotSearches) {
        _hotSearches = [NSMutableArray array];
    }
    return _hotSearches;
}

- (NSMutableArray *)hotSearchTags {
    if (!_hotSearchTags) {
        _hotSearchTags = [NSMutableArray array];
    }
    return _hotSearchTags;
}

- (UIView *)hotSearchView {
    if (!_hotSearchView) {
        _hotSearchView = [[UIView alloc] init];
    }
    return _hotSearchView;
}

- (NSMutableArray *)colorPol {
    if (!_colorPol) {
        NSArray *colorStrPol = @[@"009999", @"0099cc", @"0099ff", @"00cc99", @"00cccc", @"336699", @"3366cc", @"3366ff", @"339966", @"666666", @"666699", @"6666cc", @"6666ff", @"996666", @"996699", @"999900", @"999933", @"99cc00", @"99cc33", @"660066", @"669933", @"990066", @"cc9900", @"cc6600" , @"cc3300", @"cc3366", @"cc6666", @"cc6699", @"cc0066", @"cc0033", @"ffcc00", @"ffcc33", @"ff9900", @"ff9933", @"ff6600", @"ff6633", @"ff6666", @"ff6699", @"ff3366", @"ff3333"];
        NSMutableArray *colorPolM = [NSMutableArray array];
        for (NSString *colorStr in colorStrPol) {
            UIColor *color = [UIColor colorWithHexString:colorStr];
            [colorPolM addObject:color];
        }
        _colorPol = colorPolM;
    }
    return _colorPol;
}

@end
