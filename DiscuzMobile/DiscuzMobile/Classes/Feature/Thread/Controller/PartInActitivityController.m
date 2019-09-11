//
//  PartInActitivityController.m
//  DiscuzMobile
//
//  Created by HB on 2017/8/4.
//  Copyright © 2017年 comsenz-service.com.  All rights reserved.
//

#import "PartInActitivityController.h"

#import "ParInActiveModel.h"

#import "ZHPickView.h"
#import "AddressSelectView.h"

#import "PartInNormalCell.h"
#import "PartInSexCell.h"
#import "PartInPayCell.h"
#import "PartInSelectCell.h"
#import "ActivityApplyReplyCell.h"
#import "PartInMultiSelectCell.h"


@interface PartInActitivityController () <QRadioButtonDelegate,ZHPickViewDelegate, UITextFieldDelegate, UITextViewDelegate>

@property (nonatomic, strong) UIButton *allowBtn;
@property (nonatomic, strong) UIButton *rejectBtn;
@property (nonatomic, strong) ZHPickView *oneSelectPickView;
@property (nonatomic, strong) ZHPickView *datePickView;
@property (nonatomic, strong) AddressSelectView *cityPickView;

@property (nonatomic, strong) NSIndexPath *currentIndexPath;

@property (nonatomic, strong) NSString *cost;

@end

@implementation PartInActitivityController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"参加活动";
    NSDictionary *special_activity = [[self.threadModel.threadDic objectForKey:@"Variables"]  objectForKey:@"special_activity"];
    self.cost = [special_activity objectForKey:@"cost"];
    NSString *credit = [special_activity objectForKey:@"credit"];
    NSString *creditcost = [special_activity objectForKey:@"creditcost"];
    if ([DataCheck isValidString:self.cost] && [self.cost integerValue] > 0) {
        ParInActiveModel *partModel = [[ParInActiveModel alloc] init];
        partModel.formtype = @"jt_cost";
        partModel.title = @"支付方式";
        [self.dataSourceArr addObject:partModel];
    }
    
    if ([DataCheck isValidString:credit] && [credit integerValue] ) {
        UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 30)];
        header.backgroundColor = [UIColor whiteColor];
        UILabel *tipLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, WIDTH - 30, 20)];
        tipLab.font = [FontSize forumInfoFontSize12];
        tipLab.textColor = [UIColor orangeColor];
        tipLab.text = [NSString stringWithFormat:@"注意：参加此活动将扣除您 %@",creditcost];
        [header addSubview:tipLab];
        self.tableView.tableHeaderView = header;
    }
    
    NSDictionary *joinfieldDic =  [special_activity objectForKey:@"joinfield"];
    NSDictionary *ufieldDic = [special_activity objectForKey:@"ufield"];
    NSDictionary *settings = [special_activity objectForKey:@"settings"];
    
    if ([DataCheck isValidDictionary:ufieldDic]) {
        if ([DataCheck isValidArray:[ufieldDic objectForKey:@"userfield"]]) {
            NSArray *userFieldArr = [ufieldDic objectForKey:@"userfield"];
            [userFieldArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSDictionary *dic = joinfieldDic[obj];
                ParInActiveModel *partModel = [[ParInActiveModel alloc] init];
                [partModel setValuesForKeysWithDictionary:dic];
                if ([partModel.fieldid isEqualToString:@"gender"]) {
                    partModel.fieldValue = @"0";
                    partModel.choicesArray = @[@"保密",@"男",@"女"];
                }
                if ([DataCheck isValidDictionary:settings]) {
                    
                    if ([DataCheck isValidDictionary:[settings objectForKey:partModel.fieldid]]) {
                        [self.dataSourceArr addObject:partModel];
                    }
                    
                } else {
                    [self.dataSourceArr addObject:partModel];
                }
            }];
            
            
            // ************test *******************
//            [self testData];
        }
    }
    
    // 加入留言
    ParInActiveModel *partModel = [[ParInActiveModel alloc] init];
    partModel.formtype = @"textarea";
    partModel.title = @"留言";
    [self.dataSourceArr addObject:partModel];
    
    UIView *footview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 60)];
    self.tableView.tableFooterView = footview;
    
    self.allowBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.allowBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.allowBtn.backgroundColor = MAIN_COLLOR;
    
    CGFloat b_width = (WIDTH - 45) / 2;
    self.allowBtn.frame = CGRectMake(15, 15, b_width, 40);
    [self.allowBtn setTitle:@"提交" forState:UIControlStateNormal];
    [self.allowBtn addTarget:self action:@selector(postAction) forControlEvents:UIControlEventTouchUpInside];
    self.allowBtn.layer.masksToBounds = YES;
    self.allowBtn.layer.cornerRadius = 5;
    [footview addSubview:self.allowBtn];
    
    
    self.rejectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.rejectBtn setTitleColor:MAIN_COLLOR forState:UIControlStateNormal];
    self.rejectBtn.backgroundColor = [UIColor whiteColor];
    self.rejectBtn.frame = CGRectMake(CGRectGetMaxX(self.allowBtn.frame) + 15, CGRectGetMinY(self.allowBtn.frame), b_width, CGRectGetHeight(self.allowBtn.frame));
    [self.rejectBtn setTitle:@"取消" forState:UIControlStateNormal];
    [self.rejectBtn addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
    self.rejectBtn.layer.masksToBounds = YES;
    self.rejectBtn.layer.borderWidth = 1;
    self.rejectBtn.layer.borderColor = MAIN_COLLOR.CGColor;
    self.rejectBtn.layer.cornerRadius = 5;
    [footview addSubview:self.rejectBtn];
    
}

- (void)testData {
    /*
     for (NSInteger i = 0; i < 10; i ++) {
     
     ParInActiveModel *partModel = [[ParInActiveModel alloc] init];
     partModel.fieldid = @"def";
     partModel.title = [NSString stringWithFormat:@"测试%ld",i];
     if (i == 2 || i ==5  || i== 6 || i == 8) {
     if (i == 2) {
     partModel.formtype = @"select";
     partModel.fieldid = @"residecity";
     } else if (i == 5) {
     partModel.formtype = @"select";
     partModel.fieldid = @"birthday";
     } else if (i == 6) {
     partModel.formtype = @"radio";
     partModel.fieldid = @"birthcity";
     } else if (i == 8) {
     partModel.formtype = @"select";
     partModel.fieldid = @"gender";
     if ([partModel.fieldid isEqualToString:@"gender"]) {
     partModel.fieldValue = @"0";
     partModel.choicesArray = @[@"保密",@"男",@"女"];
     }
     }
     } else if (i == 4) {
     partModel.formtype = @"textarea";
     }
     
     [self.dataSourceArr addObject:partModel];
     }*/
}

- (void)cancelAction {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)postAction {
    [self.view endEditing:YES];
    [self pickViewRemove];
    
    NSDictionary * getdic = @{@"fid":self.threadModel.fid,
                              @"tid":self.threadModel.tid,
                              @"pid":self.threadModel.pid
                              };
    
    
    NSMutableDictionary * dic =[NSMutableDictionary dictionaryWithObject:[Environment sharedEnvironment].formhash forKey:@"formhash"];
    [dic setObject:self.threadModel.tid forKey:@"tid"];
    [dic setObject:self.threadModel.pid forKey:@"pid"];
    [dic setObject:@"true" forKey:@"activitysubmit"];
    
    
    for (ParInActiveModel *model in self.dataSourceArr) {
        
        if ([model.title isEqualToString:@"留言"]) {
            if ([DataCheck isValidString:model.fieldValue]) {
                
                [dic setObject:model.fieldValue forKey: @"message"];
            }
        }
        else if ([model.formtype isEqualToString:@"jt_cost"]) {
            
            [dic setObject:model.payment forKey: @"payment"];
            if ([model.payment isEqualToString:@"1"]) {
                if ([DataCheck isValidString:model.fieldValue]) {
                    [dic setObject:model.fieldValue forKey: @"payvalue"];
                } else {
                    [MBProgressHUD showInfo:@"请输入支付金额"];
                    return;
                }
                
            }
            
        }
        else {
            if (![DataCheck isValidString:model.fieldValue]) {
                [MBProgressHUD showInfo:[NSString stringWithFormat:@"请输入%@",model.title]];
                return;
            } else {
                [dic setObject:model.fieldValue forKey:model.fieldid];
            }
            
        }
    }
    
    [DZApiRequest requestWithConfig:^(JTURLRequest *request) {
        [self.HUD showLoadingMessag:@"正在请求。。" toView:self.view];
        request.urlString = url_ActivityApplies;
        request.methodType = JTMethodTypePOST;
        request.parameters = dic;
        request.getParam = getdic;
    } success:^(id responseObject, JTLoadType type) {
        [self.HUD hide];
        if ([[responseObject messageval] isEqualToString:@"activity_completion"]) {
            [MBProgressHUD showInfo:@"报名成功"];
            [[NSNotificationCenter defaultCenter] postNotificationName:REFRESHWEB object:nil];
            
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            [MBProgressHUD showInfo:[responseObject messagestr]];
        }
        
    } failed:^(NSError *error) {
        [self.HUD hide];
        [self showServerError:error];
    }];
}


- (ZHPickView *)datePickView {
    if (_datePickView == nil) {
        _datePickView = [[ZHPickView alloc] initDatePickWithMaxDate:[NSDate date] datePickerMode:UIDatePickerModeDate isHaveNavControler:NO];
        _datePickView.isIntextfield = NO;
        _datePickView.delegate = self;
        [_datePickView setToolbarTintColor:TOOLBAR_BACK_COLOR];
    }
    return _datePickView;
}

- (ZHPickView *)oneSelectPickView {
    if (_oneSelectPickView == nil) {
        NSArray *arr = @[@"保密",@"男",@"女"];
        _oneSelectPickView = [[ZHPickView alloc] initPickviewWithArray:arr isHaveNavControler:NO];
        _oneSelectPickView.isIntextfield = NO;
        _oneSelectPickView.delegate = self;
        [_oneSelectPickView setToolbarTintColor:TOOLBAR_BACK_COLOR];
    }
    return _oneSelectPickView;
}

- (AddressSelectView *)cityPickView {
    if (_cityPickView == nil) {
        _cityPickView = [[AddressSelectView alloc] initWithFrame:CGRectMake(0, HEIGHT - 260, WIDTH, 260)];
        WEAKSELF;
        _cityPickView.addressBlock = ^(NSString *address) {
            [weakSelf selectAddress:address];
            [weakSelf.cityPickView remove];
        };
    }
    return _cityPickView;
}

- (void)selectAddress:(NSString *)address {
   
    ParInActiveModel *model = self.dataSourceArr[self.currentIndexPath.row];
    model.fieldValue = address;
    PartInSelectCell *cell = [self.tableView cellForRowAtIndexPath:self.currentIndexPath];
    
    cell.detailTextLabel.text = address;
}

#pragma mark - QRadioButtonDelegate
- (void)didSelectedRadioButton:(QRadioButton *)radio groupId:(NSString *)groupId {
    DLog(@"did selected radio:%@ groupId:%@", radio.titleLabel.text, groupId);
    if ([groupId isEqualToString:@"selfId1"]) {
        if ([radio.titleLabel.text isEqualToString:@"支付"]) {
            ParInActiveModel *model = self.dataSourceArr[0];
            model.payment = @"1";
        } else {
             ParInActiveModel *model = self.dataSourceArr[0];
            model.payment = @"0";
        }
    }
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [self pickViewRemove];
    [super viewWillDisappear:animated];
}

- (void)sexClick {
    [self pickViewRemove];
    [self.view endEditing:YES];
    [self.oneSelectPickView show];
}

-(void)BarBtnClick{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self pickViewRemove];
    [self.view endEditing:YES];
}

- (void)pickViewRemove {
    
    if (_oneSelectPickView != nil) {
        [self.oneSelectPickView remove];
    }
    if (_datePickView != nil) {
         [self.datePickView remove];
    }
    if (_cityPickView != nil) {
        
        [self.cityPickView remove];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([DataCheck isValidString:self.cost] && [self.cost integerValue] > 0) {
        if (indexPath.row == 0) {
            return 80;
        }
    }
    
    if ([DataCheck isValidArray:self.dataSourceArr]) {
        ParInActiveModel *partModel = self.dataSourceArr[indexPath.row];
        if ([partModel.formtype isEqualToString:@"textarea"]) {
            return 38 * 3 + 24;
        }
        if ([partModel.formtype isEqualToString:@"list"] || [partModel.formtype isEqualToString:@"checkbox"]) {
            UITableViewCell *cell = [self tableView:self.tableView cellForRowAtIndexPath:indexPath];
            return [(PartInMultiSelectCell *)cell cellHeight];
        }
    }
    
    return 50;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataSourceArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *payID = @"partPayID";
    NSString *normalID = [NSString stringWithFormat:@"partInNormalID%ld",(long)indexPath.row];
//    static NSString *sexID = @"partInSexID";
    NSString *selectID = [NSString stringWithFormat:@"partSelectID%ld",indexPath.row];
    NSString *multiSelectID = [NSString stringWithFormat:@"partMultiSelect%ld",(long)indexPath.row];
    NSString *detailID = [NSString stringWithFormat:@"partDetailID%ld",indexPath.row];
    
    ParInActiveModel *partModel = self.dataSourceArr[indexPath.row];
    
    if ([partModel.formtype isEqualToString:@"jt_cost"]) {
        PartInPayCell *cell = [tableView dequeueReusableCellWithIdentifier:payID];
        if (cell == nil) {
            cell = [[PartInPayCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:payID];
            cell.selfRadio.delegate = self;
            cell.payRadio.delegate  = self;
            cell.selfRadio.checked = YES;
        }
        cell.payTextField.delegate = self;
        cell.payTextField.tag = 100 + indexPath.row;
//        cell.tipLab.text = [NSString stringWithFormat:@"注意：参加此活动将扣除您 %@ 金钱",self.cost];
        return cell;
    }
    else if ([partModel.formtype isEqualToString:@"select"] ||  [partModel.formtype isEqualToString:@"radio"]
             
//             && ![partModel.fieldid isEqualToString:@"birthcommunity"]
//             && ([partModel.fieldid isEqualToString:@"gender"] || [partModel.fieldid isEqualToString:@"birthday"] || [partModel.fieldid isEqualToString:@"residecity"] || [partModel.fieldid isEqualToString:@"birthcity"] || [partModel.fieldid isEqualToString:@"birthdist"] || [partModel.fieldid isEqualToString:@"education"])
             ) {
        
        PartInSelectCell *cell = [tableView dequeueReusableCellWithIdentifier:selectID];
        if (cell == nil) {
            cell = [[PartInSelectCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:selectID];
            cell.detailTextLabel.font = [FontSize HomecellTimeFontSize14];
            cell.detailTextLabel.text = @"请选择";
            if ([partModel.fieldid isEqualToString:@"gender"]) {
                cell.detailTextLabel.text = @"保密";
            }
        }
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.titleLab.attributedText = [[NSString stringWithFormat:@"%@:",partModel.title] getAttributeStr];
        return cell;
        
//        if ([partModel.fieldid isEqualToString:@"gender"]) {
//            PartInSexCell *cell = [tableView dequeueReusableCellWithIdentifier:sexID];
//            if (cell == nil) {
//                cell = [[PartInSexCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:sexID];
//            }
//            UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sexClick)];
//            [cell.sexSelectView addGestureRecognizer:tap2];
//            cell.titleLab.attributedText = [Utils getAttributeStr:[NSString stringWithFormat:@"%@:",partModel.title]];
//            return cell;
//        }
        
//        else {
//            PartInSelectCell *cell = [tableView dequeueReusableCellWithIdentifier:selectID];
//            if (cell == nil) {
//                cell = [[PartInSelectCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:selectID];
//                cell.detailTextLabel.font = [FontSize HomecellTimeFontSize14];
//                cell.detailTextLabel.text = @"请选择";
//            }
//            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//            cell.titleLab.attributedText = [Utils getAttributeStr:[NSString stringWithFormat:@"%@:",partModel.title]];
//            return cell;
//        }
        
    }
    
    else if ([partModel.formtype isEqualToString:@"checkbox"] || [partModel.formtype isEqualToString:@"list"]) {
        PartInMultiSelectCell *cell = [tableView dequeueReusableCellWithIdentifier:multiSelectID];
        if (cell == nil) {
            cell = [[PartInMultiSelectCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:multiSelectID];
            cell.multiSelectArray = partModel.choicesArray.mutableCopy;
            cell.titleLab.attributedText = [[NSString stringWithFormat:@"%@:",partModel.title] getAttributeStr];
            
            cell.senduserBlock = ^(NSArray *userArray) {
                NSString *select = @"";
                for (NSString *value in userArray) {
                    if ([DataCheck isValidString:select]) {
                        select = [NSString stringWithFormat:@"%@,%@",select,value];
                    } else {
                        select = value;
                    }
                }
                partModel.fieldValue = select;
            };
        }
        
        
        return cell;
    }
    
    else if ([partModel.formtype isEqualToString:@"textarea"]) {
        ActivityApplyReplyCell *cell = [tableView dequeueReusableCellWithIdentifier:detailID];
        if (cell == nil) {
            cell = [[ActivityApplyReplyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:detailID];
        }
//        cell.tipLab.text = partModel.title;
        if (indexPath.row != self.dataSourceArr.count - 1) {
            cell.tipLab.attributedText = [[NSString stringWithFormat:@"%@:",partModel.title] getAttributeStr];
            
        } else {
            cell.tipLab.attributedText = [[NSMutableAttributedString alloc] initWithString:partModel.title];
        }
        
        cell.detailView.delegate = self;
        cell.detailView.tag = 100 + indexPath.row;
        return cell;
    }
    else  {
        PartInNormalCell *cell = [tableView dequeueReusableCellWithIdentifier:normalID];
        if (cell == nil) {
            cell = [[PartInNormalCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:normalID];
        }
        cell.titleLab.text = partModel.title;
        cell.titleLab.attributedText = [[NSString stringWithFormat:@"%@:",partModel.title] getAttributeStr];
        cell.textField.placeholder = [NSString stringWithFormat:@"请输入%@",partModel.title];
        cell.textField.delegate = self;
        cell.textField.tag = 100 + indexPath.row;
        
        if ([partModel.formtype isEqualToString:@"file"]) {
            cell.textField.placeholder = @"请输入图片地址";
        }
        
        return cell;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.view endEditing:YES];
    [self pickViewRemove];
    
    self.currentIndexPath = indexPath;
    ParInActiveModel *model = self.dataSourceArr[indexPath.row];
    
    if ([model.formtype isEqualToString:@"select"] || [model.formtype isEqualToString:@"radio"]) {
        if ([model.fieldid isEqualToString:@"birthday"]) {
            [self.datePickView show];
        } else  if ([model.fieldid isEqualToString:@"residecity"] || [model.fieldid isEqualToString:@"birthcity"] || [model.fieldid isEqualToString:@"birthdist"]) {
            [self.cityPickView show];
        } else {
            if ([DataCheck isValidArray:model.choicesArray]) {
                [self.oneSelectPickView setArrayClass:model.choicesArray];
                [self.oneSelectPickView show];
            }
            
        }
    }
    
}

-(void)toobarDonBtnHaveClick:(ZHPickView *)pickView resultString:(NSString *)resultString androw:(NSInteger)row {
    
    ParInActiveModel *model = self.dataSourceArr[self.currentIndexPath.row];
    
    if (pickView == _oneSelectPickView) {
        
        if ([model.fieldid isEqualToString:@"gender"]) {
            if ([resultString isEqualToString:@"男"]) {
                model.fieldValue = @"1";
            } else if ([resultString isEqualToString:@"女"]) {
                model.fieldValue = @"2";
            } else {
                model.fieldValue = @"0";
            }
            
        } else {
            model.fieldValue = resultString;
        }
        
    } else if (pickView == _datePickView){
        
        model.fieldValue = resultString;
    }
    
    PartInSelectCell *cell = [self.tableView cellForRowAtIndexPath:self.currentIndexPath];
    cell.detailTextLabel.text = resultString;
    
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [self pickViewRemove];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    NSInteger tag = textField.tag - 100;
    ParInActiveModel *model = self.dataSourceArr[tag];
    model.fieldValue = textField.text;
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    [self pickViewRemove];
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    NSInteger tag = textView.tag - 100;
    ParInActiveModel *model = self.dataSourceArr[tag];
    model.fieldValue = textView.text;
}

@end
