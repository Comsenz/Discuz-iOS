//
//  PostNormalViewController.m
//  DiscuzMobile
//
//  Created by HB on 2017/6/7.
//  Copyright © 2017年 comsenz-service.com.  All rights reserved.
//

#import "PostNormalViewController.h"
#import "AudioModel.h"
#import "AudioTool.h"
#import "UploadTool.h"
#import "PostNormalModel.h"
#import "WSImageModel.h"

#import "LoginController.h"
#import "SeccodeverifyView.h"
#import "NewThreadTypeModel.h"
#import "PostSelectTypeCell.h"
#import "VoteTitleCell.h"
//#import "ActiveDetailCell.h"
#import "NormalDetailCell.h"
#import "NormalThreadToolCell.h"
#import "audioListCell.h"

#import "ZHPickView.h"

@interface PostNormalViewController () <ZHPickViewDelegate, UITextFieldDelegate, UITextViewDelegate,WBStatusComposeEmoticonViewDelegate,YYTextViewDelegate>

@property (nonatomic, strong) PostNormalModel *normalModel;

@property (nonatomic ,strong) NSString * filePath;

@property (nonatomic, strong) NSMutableArray *imageViews;

// 录音时长
@property (nonatomic, assign) NSInteger recordTime;

@property (nonatomic, strong) NSIndexPath *playingIndex;

@end

@implementation PostNormalViewController


- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (void)dealloc {
    [[AudioTool shareInstance] clearAudio];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"发帖";
    
    [self createBarBtn:@"发布" type:NavItemText Direction:NavDirectionRight];
    self.tableView.backgroundColor = [UIColor whiteColor];
    
    if (self.typeArray.count > 0) {
        self.pickView.delegate = self;
    }
}

- (void)rightBarBtnClick {
    
    [self.view endEditing:YES];
    
    if (![self isLogin]) {
        return;
    }
    if (![DataCheck isValidString:self.normalModel.subject]) {
        [MBProgressHUD showInfo:@"请输入标题"];
        return;
    }
    
    self.navigationItem.rightBarButtonItem.enabled = NO;
    [self downlodyan];
    
}

#pragma mark - tableView delegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if ([AudioTool shareInstance].audioArray.count > 0) {
        return 3;
    }
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 0) {
        
        if (self.typeArray.count > 0) {
            return 3;
        } else {
            return 2;
        }
    } else if(section == 1) {
        if ([AudioTool shareInstance].audioArray.count > 0) {
            return [AudioTool shareInstance].audioArray.count;
        }
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat keyboardHeight = 265;
    CGFloat detailH = HEIGHT - self.navbarMaxY - keyboardHeight - 55 - SafeAreaBottomHeight;
    if (self.typeArray.count > 0) {
        detailH -= 55;
    }
    if (indexPath.section == 0) {
        if (self.typeArray.count > 0) {
            if (indexPath.row == 2) {
                return detailH;
            }
        } else if (indexPath.row == 1) {
            return detailH;
        }
        return 55;
    }
    else if (indexPath.section == 1) {
        
        if ([AudioTool shareInstance].audioArray.count > 0) {
            return 50;
        } else {
            return keyboardHeight;
        }
        
    }
     else {
         if ([AudioTool shareInstance].audioArray.count > 0) {
             return keyboardHeight;
         }
        return 0;
    }
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (indexPath.section) {
        case 0: {
            
            if (indexPath.row == 0) {
                
                NSString *titleid = @"titleid";
                VoteTitleCell *titleCell = [tableView dequeueReusableCellWithIdentifier:titleid];
                if (titleCell == nil) {
                    titleCell = [[VoteTitleCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:titleid];
                }
                titleCell.titleTextField.delegate = self;
                titleCell.titleTextField.text = self.normalModel.subject;
                titleCell.titleTextField.tag = 1000 + 1;
                [titleCell.titleTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
                return titleCell;
            } else {
                
                if (self.typeArray.count > 0) {
                    
                    if (indexPath.row == 1) {
                        
                        NSString *typesId = @"selectTypeId";
                        PostSelectTypeCell *typeCell = [tableView dequeueReusableCellWithIdentifier:typesId];
                        if (typeCell == nil) {
                            typeCell = [[PostSelectTypeCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:typesId];
                            typeCell.selectField.inputView = self.pickView;
                            typeCell.selectField.tag = 1003;
                        }
                        typeCell.selectField.delegate = self;
                        return typeCell;
                    } else {
                        return [self detailCell];
                    }
                    
                    
                } else {
                    return [self detailCell];
                }
                
            }
            
        }
            break;
        case 1: {
            
            if ([AudioTool shareInstance].audioArray.count > 0) {
                AudioModel *model = [AudioTool shareInstance].audioArray[indexPath.row];
                NSString *toolId = @"audioId";
                audioListCell *audioCell = [tableView dequeueReusableCellWithIdentifier:toolId];
                if (audioCell == nil) {
                    audioCell = [[audioListCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:toolId];
                    audioCell.selectionStyle = UITableViewCellSelectionStyleNone;
                }
                audioCell.timeLabel.text = [NSString stringWithFormat:@"%ld秒",model.time];
                return audioCell;
                
            } else {
                return [self ToolCell];
            }
        }
            break;
        case 2: {
            
            return [self ToolCell];
            
            
        }
            break;
        
        default: {
            
        }
            break;
    }
    
        NSString *CellIdentifier = [NSString stringWithFormat:@"Cell%ld%ld", (long)[indexPath section],(long)[indexPath row]];
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
    
        return cell;
  
}

- (NormalDetailCell *)detailCell {
    NSString *CellId = @"detailId";
    NormalDetailCell *detailCell = [self.tableView dequeueReusableCellWithIdentifier:CellId];
    if (detailCell == nil) {
        detailCell = [[NormalDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellId];
    }
    detailCell.textView.delegate = self;
    detailCell.textView.text = self.normalModel.message;
    return detailCell;
}

- (NormalThreadToolCell *)ToolCell {
    NSString *toolId = @"toolId";
    NormalThreadToolCell *toolCell = [self.tableView dequeueReusableCellWithIdentifier:toolId];
    if (toolCell == nil) {
        toolCell = [[NormalThreadToolCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:toolId];
        toolCell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        WEAKSELF;
        toolCell.uploadView.pickerView.navigationController = self.navigationController;
        toolCell.uploadView.pickerView.HUD = self.HUD;
        [WBEmoticonInputView sharedView].delegate = self;
        toolCell.uploadView.pickerView.finishPickingBlock = ^(NSArray *WSImageModels) {
            [weakSelf uploadImageArr:WSImageModels];
        };
        
        toolCell.hideKeyboardBlock = ^{
            [weakSelf.view endEditing:YES];
        };
        
        toolCell.recordView.uploadBlock = ^{
            [weakSelf uploadAudio];
        };
        
    }
    return toolCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([AudioTool shareInstance].audioArray.count > 0) {
        AudioModel *model = [AudioTool shareInstance].audioArray[indexPath.row];
        if (indexPath == self.playingIndex) {
            [[AudioTool shareInstance] pausePlayRecord];
            self.playingIndex = nil;
            return;
        }
//        [self playlistAudio:model.mp3Url];
        [[AudioTool shareInstance] playlistAudio:model.mp3Url];
        self.playingIndex = indexPath;
    }
}

#pragma mark ZhpickVIewDelegate
-(void)toobarDonBtnHaveClick:(ZHPickView *)pickView resultString:(NSString *)resultString androw:(NSInteger)row {
    
    self.normalModel.typeId = self.typeArray[row].typeId;
    
    PostSelectTypeCell *cell  = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    cell.selectField.text = resultString;
    
}

#pragma mark @protocol WBStatusComposeEmoticonView
- (void)emoticonInputDidTapText:(NSString *)text {
    if (text.length) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
        if (self.typeArray.count > 0) {
            indexPath = [NSIndexPath indexPathForRow:2 inSection:0];
        }
        NormalDetailCell *detailCell = [self.tableView cellForRowAtIndexPath:indexPath];
        [detailCell.textView replaceRange:detailCell.textView.selectedTextRange withText:text];
        self.normalModel.message = detailCell.textView.text;
    }
}

- (void)emoticonInputDidTapBackspace {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
    if (self.typeArray.count > 0) {
        indexPath = [NSIndexPath indexPathForRow:2 inSection:0];
    }
    NormalDetailCell *detailCell = [self.tableView cellForRowAtIndexPath:indexPath];
    [detailCell.textView deleteBackward];
}


-(void)postData {
    [self.view endEditing:YES];
    
    NSDictionary * getdic = @{@"fid":self.fid};
    NSMutableDictionary * postdic=  [self creatDicdata];
    
    [DZApiRequest requestWithConfig:^(JTURLRequest *request) {
        [self.HUD showLoadingMessag:@"发送中" toView:self.view];
        self.HUD.userInteractionEnabled = YES;
        request.urlString = url_PostCommonThread;
        request.methodType = JTMethodTypePOST;
        request.parameters = postdic;
        request.getParam = getdic;
    } success:^(id responseObject, JTLoadType type) {
        [self requestPostSucceed:responseObject];
        self.navigationItem.rightBarButtonItem.enabled = YES;
    } failed:^(NSError *error) {
        self.navigationItem.rightBarButtonItem.enabled = YES;
        [self requestPostFailure:error];
    }];
}

- (void)requestPostSucceed:(id)responseObject {
    [super requestPostSucceed:responseObject];
    NSString *message = [responseObject messageval];
    if ([message containsString:@"succeed"] || [message containsString:@"success"]) {
        [[AudioTool shareInstance] clearAudio];
    }
    
}

- (NSMutableDictionary *)creatDicdata
{
    NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithObject:[Environment sharedEnvironment].formhash forKey:@"formhash"];
    
    [dic setObject:self.normalModel.subject forKey:@"subject"];
    [dic setObject:self.normalModel.message forKey:@"message"];
    [dic setObject:@"1" forKey:@"allownoticeauthor"];  // 设置回帖的时候提醒作者
    
    // TODO: 正确处理应该要选择主题类型
    if ([DataCheck isValidString:self.normalModel.typeId]) {
        [dic setObject:[NSString stringWithFormat:@"%@",self.normalModel.typeId] forKey:@"typeid"];
    }
    
    if (self.verifyView.isyanzhengma) {
        [dic setObject:self.verifyView.yanTextField.text forKey:@"seccodeverify"];
        [dic setObject:[self.verifyView.secureData objectForKey:@"sechash"] forKey:@"sechash"];
        if ([DataCheck isValidString:[self.verifyView.secureData objectForKey:@"secqaa"]]) {
            [dic setObject:self.verifyView.secTextField.text forKey:@"secanswer"];;
        }
    }
    
    
    if ([AudioTool shareInstance].audioArray.count > 0) {
        for (int i = 0; i < [AudioTool shareInstance].audioArray.count; i ++) {
            AudioModel *audio = [[AudioTool shareInstance].audioArray objectAtIndex:i];
            NSString *description = [NSString stringWithFormat:@"%ld",(long)audio.time];
            [dic setObject:description forKey:[NSString stringWithFormat:@"attachnew[%@][description]",audio.audioUploadId]];
        }
    }
    
    NormalThreadToolCell *cell = [self getToolCell];
    if (cell.uploadView.uploadModel.aidArray.count > 0) {
        for (int i=0; i < cell.uploadView.uploadModel.aidArray.count; i++) {
            NSString *description = @"";
            [dic setObject:description forKey:[NSString stringWithFormat:@"attachnew[%@][description]",[cell.uploadView.uploadModel.aidArray objectAtIndex:i]]];
            
        }
        [dic setObject:@"1" forKey:@"allowphoto"];
    }
    return dic;
}

#pragma mark - 验证码
- (void)downlodyan {
    
    [self.verifyView downSeccode:@"post" success:^{
        if (self.verifyView.isyanzhengma) {
            [self.verifyView show];
        } else {
            [self postData];
        }
    } failure:^(NSError *error) {
        [self showServerError:error];
        self.navigationItem.rightBarButtonItem.enabled = YES;
        
    }];
    
    WEAKSELF;
    self.verifyView.submitBlock = ^{
        [weakSelf postData];
    };
    
}

- (void)uploadImageArr:(NSArray *)imageArr {
    if (![DataCheck isValidString:self.uploadhash]) {
        [MBProgressHUD showInfo:@"无权限上传图片"];
        return;
    }
    NSMutableDictionary *dic=@{@"hash":self.uploadhash,
                        @"uid":[NSString stringWithFormat:@"%@",[Environment sharedEnvironment].member_uid],
                        }.mutableCopy;
    NSMutableDictionary * getdic=@{@"fid":self.fid,
                                   @"type":@"image",
                                   }.mutableCopy;
    
    NormalThreadToolCell *cell = [self getToolCell];
    [self.HUD showLoadingMessag:@"" toView:self.view];
    [cell.uploadView uploadImageArray:imageArr.copy getDic:getdic postDic:dic];
    
}

- (NormalThreadToolCell *)getToolCell {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:1];
    if ([AudioTool shareInstance].audioArray.count > 0) {
        indexPath = [NSIndexPath indexPathForRow:0 inSection:2];
    }
    NormalThreadToolCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    return cell;
}


// 删除录音
- (void)deleteAudio:(NSIndexPath *)indexPath {
    // 删除本地文件
    AudioModel *audio = [AudioTool shareInstance].audioArray[indexPath.row];
    [[FileManager shareInstance] removeFileWithPath:audio.mp3Url.absoluteString];
    // 删除列表数据源
    [[AudioTool shareInstance].audioArray removeObjectAtIndex:indexPath.row];
    
    if ([AudioTool shareInstance].audioArray.count > 0) {
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationNone];
        
    } else {
        [self.tableView reloadData];
    }
}

- (void)uploadSucceed {
    self.recordTime = 0;
    [[AudioTool shareInstance] initAudio];
}

- (void)uploadAudio {
    
    NSDictionary *dic=@{@"hash":self.uploadhash,
                        @"uid":[NSString stringWithFormat:@"%@",[Environment sharedEnvironment].member_uid],
                        };
    NSDictionary * getdic=@{@"fid":self.fid};
    NSArray *arr = @[[AudioTool shareInstance].mp3Url.absoluteString];
    [self.HUD showLoadingMessag:@"正在上传语音..." toView:self.view];
    [[UploadTool shareInstance] upLoadAttachmentArr:arr attacheType:JTAttacheAudio getDic:getdic postDic:dic complete:^{
        [self.HUD hide];
    } success:^(id response) {
        
        AudioModel *audio = [AudioModel audioWithId:response  andMp3Url:[AudioTool shareInstance].mp3Url];
        audio.time = [AudioTool shareInstance].recordTime;
        [[AudioTool shareInstance].audioArray addObject:audio];
        [UIView animateWithDuration:0 animations:^{
            [self.tableView reloadData];
        } completion:^(BOOL finished) {
            NormalThreadToolCell *cell = [self getToolCell];
            [cell.recordView resetAction];
        }];
    } failure:^(NSError *error) {
        [self showServerError:error];
    }];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([AudioTool shareInstance].audioArray.count > 0) {
        if (indexPath.section == 1) {
            return UITableViewCellEditingStyleDelete;
        }
    }
    return UITableViewCellEditingStyleNone;
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    
    if ([AudioTool shareInstance].audioArray.count > 0) {
        
        [self.tableView setEditing:YES animated:animated];
    }
    
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        if ([AudioTool shareInstance].audioArray.count > 0) {
            [self deleteAudio:indexPath];
        }
    }
}

- (void)resetScrollPosition:(YYTextView *)textView {
    CGRect r = [textView caretRectForPosition:textView.selectedTextRange.end];
    CGFloat caretY =  MAX(r.origin.y - textView.frame.size.height + r.size.height + 8, 0);
    if (textView.contentOffset.y < caretY && r.origin.y != INFINITY)
        textView.contentOffset = CGPointMake(0, caretY);
}

-(void)textViewDidEndEditing:(UITextView *)textView {
    self.normalModel.message = textView.text;
}

- (void)textViewDidChange:(YYTextView *)textView {
    [self resetScrollPosition:textView];
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:YES];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField.tag == 1001) {
        self.normalModel.subject = textField.text;
    }
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    if (textField.tag == 1003) {
        [[IQKeyboardManager sharedManager] setEnableAutoToolbar:NO];
    } else {
        [[IQKeyboardManager sharedManager] setEnableAutoToolbar:YES];
    }
    return YES;
}

- (void)textFieldDidChange:(UITextField *)textField{
    UITextRange *selectedRange = textField.markedTextRange;
    UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
    NSString *text = textField.text;
    if (!position) {
        // 2. 截取
        if (text.length >= 80) {
            textField.text = [text substringToIndex:80];
        }
    } else {
        // 有高亮选择的字 不做任何操作
    }
}

- (PostNormalModel *)normalModel {
    if (_normalModel == nil) {
        _normalModel = [[PostNormalModel alloc] init];
        _normalModel.subject = @"";
        _normalModel.message = @"";
    }
    return _normalModel;
}

- (NSMutableArray *)imageViews {
    if (!_imageViews) {
        _imageViews = [NSMutableArray array];
    }
    return _imageViews;
}

@end
