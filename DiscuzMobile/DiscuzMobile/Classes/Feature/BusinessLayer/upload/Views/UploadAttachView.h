//
//  UploadAttachView.h
//  DiscuzMobile
//
//  Created by ZhangJitao on 2018/3/26.
//  Copyright © 2018年 comsenz-service.com.  All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UploadAttachModel.h"
#import "WSImagePickerView.h"

@interface UploadAttachView : UIView

@property (nonatomic, strong) UploadAttachModel *uploadModel;

@property (nonatomic, strong) WSImagePickerView *pickerView;

- (void)uploadImageArray:(NSMutableArray *)imageArr getDic:(NSDictionary *)getdic postDic:(NSDictionary *)postdic;

@end
