//
//  PostActivityViewController.m
//  DiscuzMobile
//
//  Created by HB on 2017/7/27.
//  Copyright © 2017年 comsenz-service.com.  All rights reserved.
//

#import "PostActivityViewController.h"

#import "UploadTool.h"

#import "DropDownView.h"
#import "ZHPickView.h"
#import "NewThreadTypeModel.h"
#import "ImagePickerView.h"

#import "VoteTitleCell.h"
#import "ActiveTimeCell.h"
#import "ActiveContentCell.h"
#import "ActiveDetailCell.h"
#import "AllOneButtonCell.h"
#import "PostSelectTypeCell.h"
#import "SeccodeverifyView.h"
#import "ActiveUserFieldCell.h"
#import "ActiveExtendCell.h"

#import "PostActivityModel.h"


@class JTPlaceholderTextView;

//启动活动MVC
@interface PostActivityViewController ()<UITextFieldDelegate,UITextViewDelegate,DropDownViewDelegate,ZHPickViewDelegate>
{
    DropDownView *_dropDownView;
    
}

// 发帖要发的model
@property (nonatomic, strong) PostActivityModel *activityModel;

@property (nonatomic ,strong) NSString  * filePath;      // 图片路径
@property (nonatomic ,assign) BOOL dropSelect;


@property (nonatomic, strong) ZHPickView *sexPickView;

@property (nonatomic, strong) NSMutableArray *activitytypeArr;

@property (nonatomic, strong) NSMutableDictionary *userFieldDic;

@end

@implementation PostActivityViewController

- (NSMutableDictionary *)userFieldDic {
    if (!_userFieldDic) {
        _userFieldDic = [NSMutableDictionary dictionary];
    }
    return _userFieldDic;
}

- (NSMutableArray *)activitytypeArr {
    if (!_activitytypeArr) {
        _activitytypeArr = [NSMutableArray array];
    }
    return _activitytypeArr;
}

- (void)viewWillDisappear:(BOOL)animated {
    [self sexPickViewRemove];
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"发起活动";
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 40)];
    
    _dropSelect = NO;
    
    if ([DataCheck isValidArray:[[self.dataForumTherad objectForKey:@"activity_setting"] objectForKey:@"activitytype"]]) {
        self.activitytypeArr = [NSMutableArray arrayWithArray:[[self.dataForumTherad objectForKey:@"activity_setting"] objectForKey:@"activitytype"]];
        [self.activitytypeArr addObject:@"自定义"];
    }
    
    
    _dropDownView = [[DropDownView alloc] initWithFrame:CGRectMake(WIDTH-120, 0, 96, 31 * self.activitytypeArr.count)  activityType:self.activitytypeArr];

    _dropDownView.layer.borderColor = [MAIN_COLLOR CGColor];
    _dropDownView.layer.borderWidth = 0.5f;
    _dropDownView.backgroundColor = [UIColor whiteColor];
    _dropDownView.delegate = self;
    [self.tableView addSubview:_dropDownView];
    [self.tableView bringSubviewToFront:_dropDownView];
    
    _dropDownView.hidden = YES;
    
    if ([DataCheck isValidDictionary:[[self.dataForumTherad objectForKey:@"activity_setting"] objectForKey:@"activityfield"]]) {
        self.userFieldDic = [NSMutableDictionary dictionaryWithDictionary:[[self.dataForumTherad objectForKey:@"activity_setting"] objectForKey:@"activityfield"]];
    }
    
    if (self.typeArray.count > 0) {
        self.pickView.delegate = self;
    }
    
    NSArray *arr = @[@"不限",@"男",@"女"];
    self.sexPickView = [[ZHPickView alloc] initPickviewWithArray:arr isHaveNavControler:NO];
    self.sexPickView.isIntextfield = NO;
    self.sexPickView.delegate = self;
    [self.sexPickView setToolbarTintColor:TOOLBAR_BACK_COLOR];
}

#pragma mark ZhpickVIewDelegate
- (void)toobarDonBtnHaveClick:(ZHPickView *)pickView resultString:(NSString *)resultString androw:(NSInteger)row {
    
    if (pickView == self.sexPickView) {
        ActiveContentCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:2]];
        cell.sexSelectView.tipLab.text = resultString;
        if ([resultString isEqualToString:@"不限"]) {
            self.activityModel.gender = @"0";
        } else if ([resultString isEqualToString:@"男"]) {
            self.activityModel.gender = @"1";
        } else {
            self.activityModel.gender = @"2";
        }
        
    } else {
        self.activityModel.typeId = self.typeArray[row].typeId;
        
        PostSelectTypeCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
        cell.selectField.text = resultString;
    }
    
}

- (void)dropdownclick {
    [self.view endEditing:YES];
    [self sexPickViewRemove];
    if (!_dropSelect)
    {
        _dropDownView.hidden = NO;
        _dropSelect = YES;
        
    } else
    {
        _dropDownView.hidden = YES;
        _dropSelect = NO;
    }
}

-(void)postBtnClick:(UIButton *)btn {
    ActiveContentCell *contentCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:2]];
    NSInteger a = btn.tag-1000;
    
    if (self.activitytypeArr.count > a) {
        if ([self.activitytypeArr[a] isEqualToString:@"自定义"]) {
            [contentCell.classTextField becomeFirstResponder];
            
        } else {
            contentCell.classTextField.text = self.activitytypeArr[a];
        }
        contentCell.classSelectView.tipLab.text = self.activitytypeArr[a];
        
    }
    self.activityModel.activityClass = contentCell.classTextField.text;
    _dropDownView.hidden = YES;
    _dropSelect = NO;
    
}

- (void)photoTapped{
    [self.view endEditing:YES];
    WEAKSELF;
    self.pickerView.finishPickingBlock = ^(UIImage *image) {
        [weakSelf uploadImage:image];
    };
    [self.pickerView openSheet];
}

- (void)uploadImage:(UIImage *)image {
    NSArray * imagear=[NSArray arrayWithObject:image];
    
    NSString *uploadhash = self.uploadhash;
    
    NSDictionary *dic = @{@"hash":uploadhash,
                          @"uid":[Environment sharedEnvironment].member_uid
                          };
    
    NSDictionary * getdic = @{@"fid":self.fid};
    [self.HUD showLoadingMessag:@"上传中" toView:self.view];
    [[UploadTool shareInstance] upLoadAttachmentArr:imagear attacheType:JTAttacheImage getDic:getdic postDic:dic complete:^{
        [self.HUD hide];
    } success:^(id response) {
        NSString *aidStr = [NSString stringWithFormat:@"%@",response];
        if (self.activityModel.aidArray.count > 0) {
            self.activityModel.aidArray = [NSMutableArray array];
        }
        [self.activityModel.aidArray addObject:aidStr];
        ActiveTimeCell *timeCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
        //加在视图中
        timeCell.postImageView.image = image;
    } failure:^(NSError *error) {
        [self showServerError:error];
    }];
}

#pragma mark - 发起活动
- (void)onACtion:(UIButton *)btn {
    [self.view endEditing:YES];
    [self postdata];
}

- (void)postdata {
    if (![DataCheck isValidString:self.activityModel.subject]) {
        [MBProgressHUD showInfo:@"请填写标题"];
        return;
    }
    
    if (![DataCheck isValidString:self.activityModel.place]) {
        [MBProgressHUD showInfo:@"活动地点不能为空"];
        return;
    }
    if (![DataCheck isValidString:self.activityModel.activityClass]) {
        [MBProgressHUD showInfo:@"类别错误重新填写"];
        return;
    }
    
    if (![DataCheck isValidString:self.activityModel.startTime]) {
        [MBProgressHUD showInfo:@"起始时间错误重新填写"];
        return;
    }
    if (![DataCheck isValidString:self.activityModel.endTime]) {
        [MBProgressHUD showInfo:@"结束时间错误重新填写"];
        return;
    }
    
    if (![self.activityModel.startTime checkStarttimeAndEndtime:self.activityModel.endTime]) {
        [MBProgressHUD showInfo:@"结束时间必须晚于起始时间"];
        return;
    }
    
    [self downlodyan];
}

- (void)postActiviti {
    
    NSMutableDictionary  * dic = [NSMutableDictionary dictionaryWithDictionary:[self createPostDic]];;
    NSDictionary * getDic= @{@"fid":self.fid};
    [DZApiRequest requestWithConfig:^(JTURLRequest *request) {
        [self.HUD showLoadingMessag:@"活动发起中" toView:self.view];
        self.HUD.userInteractionEnabled = YES;
        request.urlString = url_PostCommonThread;
        request.parameters = dic;
        request.getParam = getDic;
        request.methodType = JTMethodTypePOST;
    } success:^(id responseObject, JTLoadType type) {
        [self requestPostSucceed:responseObject];
    } failed:^(NSError *error) {
        [self requestPostFailure:error];
    }];
}

- (NSMutableDictionary *)createPostDic {
    
    NSMutableDictionary  * dic =[NSMutableDictionary dictionary];
    
    [dic setValue:[Environment sharedEnvironment].formhash forKey:@"formhash"];
    [dic setValue:self.activityModel.subject forKey:@"subject"];
    [dic setValue:@"活动" forKey:@"typeid"];
    [dic setValue:self.activityModel.message forKey:@"message"];
    [dic setValue:@"1" forKey:@"activitytime"];
    [dic setValue:self.activityModel.activityClass forKey:@"activityclass"];
    [dic setValue:self.activityModel.startTime forKey:@"starttimefrom[1]"];
    [dic setValue:@"4" forKey:@"special"];
    [dic setValue:self.activityModel.endTime forKey:@"starttimeto"];
    [dic setValue:self.activityModel.userArray forKey:@"userfield"];
    [dic setValue:self.activityModel.place forKey:@"activityplace"];
    [dic setValue:self.activityModel.peopleNum forKey:@"activitynumber"];
    [dic setValue:@"IOS" forKey:@"mobiletype" ];
    [dic setValue:self.activityModel.activitycity forKey:@"activitycity"];
    [dic setValue:self.activityModel.gender forKey:@"gender"];
    [dic setValue:self.activityModel.activitycredit forKey:@"activitycredit"];
    [dic setValue:self.activityModel.cost forKey:@"cost"];
    [dic setValue:self.activityModel.activityexpiration forKey:@"activityexpiration"];
    
    
    // 设置回帖的时候提醒作者 集成推送才生效
    [dic setValue:@"1" forKey:@"allownoticeauthor"];
    
    if ([DataCheck isValidArray:self.activityModel.aidArray]) {
        
        if (self.activityModel.aidArray.count > 0) {
            [dic setValue:[NSString stringWithFormat:@"%@",[self.activityModel.aidArray objectAtIndex:0]] forKey:[NSString stringWithFormat:@"attachnew[%@][description]",[self.activityModel.aidArray objectAtIndex:0]]];
        }
    }
    
    if (self.verifyView.isyanzhengma) {
        [dic setObject:self.verifyView.yanTextField.text forKey:@"seccodeverify"];
        [dic setObject:[self.verifyView.secureData objectForKey:@"sechash"] forKey:@"sechash"];
    }
    
    if ([DataCheck isValidString:self.activityModel.typeId]) {
        [dic setValue:self.activityModel.typeId forKey:@"typeid"];
    }
    return dic;
}

#pragma mark - 验证码
- (void)downlodyan {
    
    [self.verifyView downSeccode:@"post" success:^{
        if (self.verifyView.isyanzhengma) {
            [self.verifyView show];
        } else {
            [self postActiviti];
        }
    } failure:^(NSError *error) {
        [self showServerError:error];
    }];
    
    WEAKSELF;
    self.verifyView.submitBlock = ^{
        [weakSelf postActiviti];
    };
    
}

#pragma mark - tableView delegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (indexPath.section) {
        case 0:
            if (self.typeArray.count > 0) {
                
                if (indexPath.row == 2) {
                    
                    return 90;
                    
                }
            } else if (indexPath.row == 1) {
                
                return 90;
            }
            //
            return 55.0;
            break;
        case 1:
            return 102.0;
            break;
        case 2:
            if (indexPath.row == 0) {
                return 52*4;
            } else if (indexPath.row == 1) {
                
                UITableViewCell *userCell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
                return [(ActiveUserFieldCell *)userCell cellHeight];
            } else {
                return 52*3;
            }
            
            break;
        case 3:
            return 55.0;
            break;
        default:
            return 55.0;
            break;
    }
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    switch (section) {
        case 0:
        {
            if (self.typeArray.count > 0) {
                return 3;
            } else {
                return 2;
            }
        }
            break;
        case 1:
        {
            return 1;
        }
            break;
        case 2:
        {
            return 3;
        }
            break;
        case 3:
        {
            return 1;
        }
            break;
            
        default:
            break;
    }
    return 1;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 10.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString * CellId = [NSString stringWithFormat:@"CellId%ld%ld", (long)[indexPath section],(long)[indexPath row]];
    NSString *contentID = [NSString stringWithFormat:@"contentCellId%ld%ld", (long)[indexPath section],(long)[indexPath row]];
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:CellId];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    switch (indexPath.section) {
        case 0: {
            
            if (indexPath.row == 0) {
                NSString *titleid = @"titleid";
                VoteTitleCell *titleCell = [tableView dequeueReusableCellWithIdentifier:titleid];
                if (titleCell == nil) {
                    titleCell = [[VoteTitleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:titleid];
                    titleCell.selectionStyle = UITableViewCellSelectionStyleNone;
                }
                titleCell.titleTextField.tag = 799;
                titleCell.titleTextField.delegate = self;
                
                return titleCell;
            }
            
            if (self.typeArray.count > 0) {
                
                if (indexPath.row == 1) {
                    
                    NSString *typesId = @"acSelectTypeId";
                    PostSelectTypeCell *typeCell = [tableView dequeueReusableCellWithIdentifier:typesId];
                    if (typeCell == nil) {
                        typeCell = [[PostSelectTypeCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:typesId];
                    }
                    
                    typeCell.selectField.delegate = self;
                    typeCell.selectField.inputView = self.pickView;
                    return typeCell;
                } else {
                    NSString *detailId = @"detailId";
                    ActiveDetailCell *detailCell = [tableView dequeueReusableCellWithIdentifier:detailId];
                    if (detailCell == nil) {
                        detailCell = [[ActiveDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:detailId];
                    }
                    detailCell.detailTextView.delegate = self;
                    
                    return detailCell;
                }
                
                
            } else {
                NSString *detailId = @"detailId";
                ActiveDetailCell *detailCell = [tableView dequeueReusableCellWithIdentifier:detailId];
                if (detailCell == nil) {
                    detailCell = [[ActiveDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:detailId];
                }
                detailCell.detailTextView.delegate = self;
                
                return detailCell;
            }
            
        }
            break;
        case 1: {
            ActiveTimeCell *timeCell = [tableView dequeueReusableCellWithIdentifier:CellId];
            if (timeCell == nil) {
                timeCell = [[ActiveTimeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellId];
            }
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(photoTapped)];
            [timeCell.postImageView addGestureRecognizer:tap];
            timeCell.beginTimeField.text = self.activityModel.startTime;
            timeCell.endTimeField.text = self.activityModel.endTime;
            
            // 设置代理
            timeCell.beginTimeField.delegate = self;
            timeCell.endTimeField.delegate = self;
            
            // 设置tag
            timeCell.beginTimeField.tag = 800;
            timeCell.endTimeField.tag = 801;
            return timeCell;
        }
            break;
            
        case 2: {
            if (indexPath.row == 0) {
                ActiveContentCell *contentCell = [tableView dequeueReusableCellWithIdentifier:contentID];
                if (contentCell == nil) {
                    contentCell = [[ActiveContentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:contentID];
                    
                    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dropdownclick)];
                    [contentCell.classSelectView addGestureRecognizer:tap];
                    
                    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sexClick)];
                    [contentCell.sexSelectView addGestureRecognizer:tap2];
                }
                // 设置代理
                contentCell.placeTextField.delegate = self;
                contentCell.peopleNumTextField.delegate = self;
                contentCell.classTextField.delegate = self;
                contentCell.cityTextField.delegate = self;
                
                // 设置tag
                contentCell.placeTextField.tag = 802;
                contentCell.peopleNumTextField.tag = 803;
                contentCell.classTextField.tag = 804;
                contentCell.cityTextField.tag = 901;
                
                return contentCell;
            } else {
                if (indexPath.row == 1) {
                    NSString *userCellID = @"userField";
                    ActiveUserFieldCell *userFieldCell = [tableView dequeueReusableCellWithIdentifier:userCellID];
                    if (userFieldCell == nil) {
                        userFieldCell = [[ActiveUserFieldCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:userCellID];
                        userFieldCell.activityfield = self.userFieldDic;
                        
                        WEAKSELF;
                        userFieldCell.senduserBlock = ^(NSArray *userArray) {
                            weakSelf.activityModel.userArray = [NSMutableArray arrayWithArray:userArray];
                        };
                        
                    }
                    
                    return userFieldCell; 
                } else {
                    NSString *extendCellID = @"extendCell";
                    ActiveExtendCell *userFieldCell = [tableView dequeueReusableCellWithIdentifier:extendCellID];
                    if (userFieldCell == nil) {
                        userFieldCell = [[ActiveExtendCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:extendCellID];
                        userFieldCell.integralTextfield.tag = 805;
                        userFieldCell.costTextfield.tag = 806;
                        userFieldCell.signupEndTextfield.tag = 807;
                        userFieldCell.integralTextfield.delegate = self;
                        userFieldCell.costTextfield.delegate = self;
                        userFieldCell.signupEndTextfield.delegate = self;
                    }
                    
                    return userFieldCell;
                }
            }
            
        }
            break;
            
        case 3: {
            NSString *btnid = @"buttonid";
            __weak typeof(self) weakself = self;
            AllOneButtonCell *btnCell = [tableView dequeueReusableCellWithIdentifier:btnid];
            if (btnCell == nil) {
                btnCell = [[AllOneButtonCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:btnid];
                [btnCell.ActionBtn setTitle:@"发布" forState:UIControlStateNormal];
                btnCell.actionBlock = ^(UIButton *sender) {
                    [weakself onACtion:sender];
                };
            }
            
            return btnCell;
        }
        default:
            break;
    }
    
    return cell;
    
}

- (void)sexClick {
    [self.view endEditing:YES];
    [self.sexPickView show];
}


#pragma mark - textfield delegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    // 限制 输入等测试 时候 再打开 修改
    
    /*
     NSUInteger lengthOfString = string.length;
     for (NSInteger loopIndex = 0; loopIndex < lengthOfString; loopIndex++) {//只允许数字输入
     unichar character = [string characterAtIndex:loopIndex];
     if (character < 48) return NO; // 48 unichar for 0
     if (character > 57) return NO; // 57 unichar for 9
     }
     */
    // Check for total length
    NSUInteger proposedNewLength = textField.text.length - range.length + string.length;
    if (proposedNewLength > 20) return NO;//限制长度
    
    return YES;
}

//当用户按下return键或者按回车键，keyboard消失
-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

//开始编辑输入框的时候，软键盘出现，执行此事件
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    _dropDownView.hidden = YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    [self sexPickViewRemove];
    if (textField.tag == 103) {
        [[IQKeyboardManager sharedManager] setEnableAutoToolbar:NO];
    } else {
        [[IQKeyboardManager sharedManager] setEnableAutoToolbar:YES];
    }
    return YES;
}

- (void)sexPickViewRemove {
    if (self.sexPickView) {
        [self.sexPickView remove];
    }
}

#pragma mark - UItextViewdelegate
- (void)textViewDidEndEditing:(UITextView *)textView {
    self.activityModel.message = textView.text;
}

-(void)textViewDidBeginEditing:(UITextView *)textView {
    [self sexPickViewRemove];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:YES];
    _dropDownView.hidden = YES;
}


//输入框编辑完成以后，将视图恢复到原始状态
-(void)textFieldDidEndEditing:(UITextField *)textField {
    switch (textField.tag) {
        case 799:
        {
            self.activityModel.subject = textField.text;
        }
            break;
        case 800:
        {
            self.activityModel.startTime = textField.text;
        }
            break;
        case 801:
        {
            self.activityModel.endTime = textField.text;
        }
            break;
        case 802:
        {
            self.activityModel.place = textField.text;
        }
            break;
        case 803:
        {
            self.activityModel.peopleNum = textField.text;
        }
            break;
        case 804:
        {
            self.activityModel.activityClass = textField.text;
        }
            break;
        case 805: {
            self.activityModel.activitycredit = textField.text;
        }
            break;
        case 806: {
            self.activityModel.cost = textField.text;
        }
            break;
        case 807: {
            self.activityModel.activityexpiration = textField.text;
        } break;
        case 901: {
            self.activityModel.activitycity = textField.text;
        } break;
        default:
            break;
    }
}


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (scrollView == self.tableView) {
        [self sexPickViewRemove];
        [self.view endEditing:YES];
        _dropDownView.hidden = YES;
        _dropSelect = NO;
    }
}

- (PostActivityModel *)activityModel {
    if (_activityModel == nil) {
        _activityModel = [[PostActivityModel alloc] init];
    }
    return _activityModel;
}

@end
