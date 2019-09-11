//
//  NormalThreadToolCell.h
//  DiscuzMobile
//
//  Created by HB on 2017/6/7.
//  Copyright © 2017年 comsenz-service.com.  All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AudioRecordView.h"
#import "WBEmoticonInputView.h"
#import "WSImagePickerView.h"
#import "UploadAttachView.h"

typedef void(^addImageBlock)(void);
typedef void(^HideKeyboardBlock)(void);

@interface NormalThreadToolCell : UITableViewCell<UIScrollViewDelegate>

@property (nonatomic, strong) NSMutableArray *imageViews;

@property (nonatomic, strong) UIScrollView *controlScrollView;
@property (nonatomic, strong) AudioRecordView *recordView;
@property (nonatomic, strong) UIView * postImgViwe;

@property (nonatomic, strong) UploadAttachView *uploadView;

@property (nonatomic, copy) HideKeyboardBlock hideKeyboardBlock;


@end
