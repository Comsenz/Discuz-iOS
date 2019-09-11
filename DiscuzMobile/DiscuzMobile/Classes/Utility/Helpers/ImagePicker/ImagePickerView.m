//
//  ImagePickerView.m
//  DiscuzMobile
//
//  Created by HB on 2017/6/9.
//  Copyright © 2017年 comsenz-service.com.  All rights reserved.
//

#import "ImagePickerView.h"
#import "UIAlertController+Extension.h"

@interface ImagePickerView() <UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic, strong) UIImagePickerController *pickerCT;

@end

@implementation ImagePickerView


-(void)openSheet {
    [UIAlertController alertSheetTitle:nil
                               message:nil
                            controller:self.navigationController
                           doneTextArr:@[@"拍照", @"从手机相册获取"]
                            cancelText:@"取消"
                            doneHandle:^(NSInteger index) {
                                if (index == 0) {
                                    [self takePhoto];
                                } else if (index == 1) {
                                    [self LocalPhoto];
                                }
                            } cancelHandle:^{
                                
                            }];
}

//开始拍照
-(void)takePhoto {
    
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        self.pickerCT.sourceType = sourceType;
        [self present];
    } else {
        DLog(@"模拟其中无法打开照相机，请在真机中使用");
    }
}

- (void)present {
    [self.navigationController presentViewController:self.pickerCT animated:YES completion:nil];
}

//当选择一张图片后进入这里
- (void)imagePickerController:(UIImagePickerController * )picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    
    //当选择的类型是图片
    if ([type isEqualToString:@"public.image"]) {
        //关闭相册界面
        [picker dismissViewControllerAnimated:YES completion:^{
            
            UIImage * image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
            if (self.finishPickingBlock) {
                self.finishPickingBlock(image);
            }
        }];
    }
}

//打开本地相册
-(void)LocalPhoto {
    
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) return;
    
    self.pickerCT.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self present];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 懒加载
- (UIImagePickerController *)pickerCT {
    if (_pickerCT == nil) {
        _pickerCT = [[UIImagePickerController alloc]init];
        _pickerCT.delegate = self;
        _pickerCT.allowsEditing = YES;
    }
    return _pickerCT;
}
@end
