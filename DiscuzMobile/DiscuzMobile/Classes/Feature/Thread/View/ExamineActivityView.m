//
//  ExamineActivityView.m
//  DiscuzMobile
//
//  Created by HB on 2017/7/28.
//  Copyright © 2017年 comsenz-service.com.  All rights reserved.
//

#import "ExamineActivityView.h"
#import "ActivityApplyDetailCell.h"
#import "ActivityApplyReplyCell.h"
#import "ApplyInfoListModel.h"

@interface ExamineActivityView() <UITableViewDelegate, UITableViewDataSource, UITextViewDelegate>

@property (nonatomic, strong) UITableView *listTableView;
@property (nonatomic, strong) NSMutableArray *dataSourceArr;

@end

@implementation ExamineActivityView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self commitInit];
    }
    return self;
}

- (void)commitInit {
    
    CGFloat allHeight = 380;
    CGFloat close_width = 16.0;
    
    CGFloat maxNavMaxY = 64;
    
    if (HEIGHT >= 812) {
        maxNavMaxY = 108;
        allHeight = 480;
    }
    self.contentView.frame = CGRectMake(30, maxNavMaxY + 10, WIDTH - 60, allHeight + 90 + 20);
    self.closeBtn.frame = CGRectMake(CGRectGetWidth(self.contentView.frame) - close_width - 16, 16, close_width, close_width);
    
    self.listTableView = [[UITableView alloc] initWithFrame:CGRectMake(8, close_width + 20, CGRectGetWidth(self.contentView.frame) - 20, allHeight) style:UITableViewStylePlain];
    self.listTableView.delegate = self;
    self.listTableView.dataSource = self;
    self.listTableView.tableFooterView = [UIView new];
    [self.contentView addSubview:self.listTableView];
    
    self.allowBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.allowBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.allowBtn.backgroundColor = MAIN_COLLOR;
    
    CGFloat b_width = (CGRectGetWidth(self.listTableView.frame) - 15) / 2;
    self.allowBtn.frame = CGRectMake(CGRectGetMinX(self.listTableView.frame), CGRectGetMaxY(self.listTableView.frame) + 15, b_width, 40);
    [self.allowBtn setTitle:@"批准" forState:UIControlStateNormal];
    self.allowBtn.layer.masksToBounds = YES;
    self.allowBtn.layer.cornerRadius = 5;
    [self.contentView addSubview:self.allowBtn];
    
    
    self.rejectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.rejectBtn setTitleColor:MAIN_COLLOR forState:UIControlStateNormal];
    self.rejectBtn.backgroundColor = [UIColor whiteColor];
     self.rejectBtn.frame = CGRectMake(CGRectGetMaxX(self.allowBtn.frame) + 15, CGRectGetMinY(self.allowBtn.frame), b_width, CGRectGetHeight(self.allowBtn.frame));
    [self.rejectBtn setTitle:@"拒绝" forState:UIControlStateNormal];
    self.rejectBtn.layer.masksToBounds = YES;
    self.rejectBtn.layer.borderWidth = 1;
    self.rejectBtn.layer.borderColor = MAIN_COLLOR.CGColor;
    self.rejectBtn.layer.cornerRadius = 5;
    [self.contentView addSubview:self.rejectBtn];
    
}

- (void)setDataModel:(ApplyActiver *)dataModel {
    CGFloat allHeight = 380;
    if (HEIGHT >= 812) {
        allHeight = 480;
    }
    CGFloat close_width = 16.0;
    
    self.listTableView.contentOffset = CGPointMake(0, 0);
    
    if ([[Environment sharedEnvironment].member_uid isEqualToString:dataModel.uid]) {
        self.rejectBtn.hidden = YES;
        self.allowBtn.hidden = YES;
        self.listTableView.frame = CGRectMake(8, close_width + 20, CGRectGetWidth(self.contentView.frame) - 20, allHeight + 70);
    } else {
         self.listTableView.frame = CGRectMake(8, close_width + 20, CGRectGetWidth(self.contentView.frame) - 20, allHeight);
        self.rejectBtn.hidden = NO;
        self.allowBtn.hidden = NO;
    }
    
    _dataModel = dataModel;
    
    self.dataSourceArr = [NSMutableArray array];
    
    ApplyInfoListModel *m1 = [[ApplyInfoListModel alloc] init];
    m1.title = @"申请者";
    m1.value = dataModel.username;
    [self.dataSourceArr addObject:m1];
    
    ApplyInfoListModel *m2 = [[ApplyInfoListModel alloc] init];
    m2.title = @"状态";
    if ([DataCheck isValidString:dataModel.verified]) {
        if ([self.dataModel.verified isEqualToString:@"1"]) {
            m2.value = @"允许参加";
        } else if ([self.dataModel.verified isEqualToString:@"2"]){
            m2.value = @"等待完善";
        } else {
             m2.value =@"尚未审核";
        }
    }
    [self.dataSourceArr addObject:m2];
    
    if ([DataCheck isValidString:dataModel.message]) {
        ApplyInfoListModel *m3 = [[ApplyInfoListModel alloc] init];
        m3.title = @"留言";
        m3.value = dataModel.message;
        [self.dataSourceArr addObject:m3];
    }
    
    
    
    ApplyInfoListModel *m4 = [[ApplyInfoListModel alloc] init];
    m4.title = @"申请时间";
    m4.value = dataModel.dateline;
    [self.dataSourceArr addObject:m4];
    
    if ([DataCheck isValidArray:dataModel.userfield]) {
        [dataModel.userfield enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([DataCheck isValidDictionary:dataModel.dbufielddata]) {
                
                ApplyInfoListModel *mm = [[ApplyInfoListModel alloc] init];
                NSDictionary *dic = [dataModel.dbufielddata objectForKey:obj];
                [mm setValuesForKeysWithDictionary:dic];
                [self.dataSourceArr addObject:mm];
            }
        }];
    } else if ([DataCheck isValidDictionary:dataModel.dbufielddata]) {
        
        [dataModel.dbufielddata enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            ApplyInfoListModel *mm = [[ApplyInfoListModel alloc] init];
            [mm setValuesForKeysWithDictionary:obj];
            [self.dataSourceArr addObject:mm];
        }];
    }
    
    
    [self.listTableView reloadData];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == self.dataSourceArr.count) {
        return 38 * 3 + 24;
    }
    
    UITableViewCell * cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    return [(ActivityApplyDetailCell *)cell cellHeight];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (![[Environment sharedEnvironment].member_uid isEqualToString:_dataModel.uid]) {
        return self.dataSourceArr.count + 1;
    }
    
    return self.dataSourceArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * CellID = @"ApplyDetailCellID";
    static NSString * CellDID = @"ApplyReplyCellID";
    
    if (indexPath.row != self.dataSourceArr.count) {
        ActivityApplyDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:CellID];
        if (cell == nil) {
            cell = [[ActivityApplyDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellID];
        }
        
        ApplyInfoListModel *model = self.dataSourceArr[indexPath.row];
        
        cell.tipLab.text = model.title;
        NSString *info = model.value;
        if ([model.title isEqualToString:@"性别"]) {
            if ([model.value isEqualToString:@"0"]) {
                info = @"保密";
            } else if ([model.value isEqualToString:@"1"]) {
                info = @"男";
            } else {
                info = @"女";
            }
        }
        cell.infoLab.text = info;
        return cell;
    } else {
        ActivityApplyReplyCell *cell = [tableView dequeueReusableCellWithIdentifier:CellDID];
        if (cell == nil) {
            cell = [[ActivityApplyReplyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellDID];
            cell.detailView.delegate = self;
        }
        cell.tipLab.text = @"附言";
        return cell;
    }
    
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    self.reason = textView.text;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self endEditing:true];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
