//
//  PostBaseController.h
//  DiscuzMobile
//
//  Created by HB on 2017/6/29.
//  Copyright © 2017年 comsenz-service.com.  All rights reserved.
//

#import "BaseTableViewController.h"
#import "UITextView+EmojiCheck.h"
#import "UITextField+EmojiCheck.h"

@class SeccodeverifyView,ZHPickView,ImagePickerView,NewThreadTypeModel;

typedef void(^PushDetailBlock)(NSString *tid);

@interface PostBaseController : BaseTableViewController

@property (nonatomic, strong) NSDictionary *dataForumTherad;
@property (nonatomic, copy) PushDetailBlock pushDetailBlock;

@property (nonatomic ,strong) NSMutableArray<NewThreadTypeModel *> * typeArray;
@property (nonatomic, copy) NSString *uploadhash;
@property (nonatomic, copy) NSString *fid;

@property (nonatomic, strong) ZHPickView *pickView;
// 验证码
@property (nonatomic, strong) SeccodeverifyView *verifyView;
// 相机相册
@property (nonatomic, strong) ImagePickerView *pickerView;

- (void)viewEndEditing;

// 发帖请求失败
- (void)requestPostFailure:(NSError *)error;
// 发帖成功
- (void)requestPostSucceed:(id)responseObject;

@end
