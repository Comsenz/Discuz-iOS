//
//  UploadAttachView.m
//  DiscuzMobile
//
//  Created by ZhangJitao on 2018/3/26.
//  Copyright © 2018年 comsenz-service.com.  All rights reserved.
//

#import "UploadAttachView.h"
#import "UploadTool.h"
#import "WSImageModel.h"

@implementation UploadAttachView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _uploadModel = [[UploadAttachModel alloc] init];
        [self p_setupViews];
    }
    return self;
}

- (void)p_setupViews {
    WSImagePickerConfig *config = [WSImagePickerConfig new];
    config.itemSize = CGSizeMake(60, 60);
    config.photosMaxCount = 10;
    
    WSImagePickerView *pickerView = [[WSImagePickerView alloc] initWithFrame:CGRectMake(0, 8, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame) - 8) config:config];
    pickerView.viewHeightChanged = ^(CGFloat height) {
        //        weakSelf.photoViewHieghtConstraint.constant = height;
        //        [weakSelf.view setNeedsLayout];
        //        [weakSelf.view layoutIfNeeded];
    };
    //    pickerView.navigationController = self.navigationController;
    [self addSubview:pickerView];
    self.pickerView = pickerView;
    
    //refresh superview height
    [pickerView refreshImagePickerViewWithPhotoArray:nil];
    WEAKSELF;
    self.pickerView.deleteBtnBlock = ^(NSInteger sort) {
        if (weakSelf.uploadModel.aidArray.count > sort) {
            [weakSelf.uploadModel.aidArray removeObjectAtIndex:sort];
            [weakSelf.uploadModel.imageModelArray removeObjectAtIndex:sort];
            for (NSInteger i = 0; i < weakSelf.uploadModel.imageModelArray.count; i ++) {
                WSImageModel *model = weakSelf.uploadModel.imageModelArray[i];
                model.sort = i ++;
            }
        }
    };
}

- (void)uploadImageArray:(NSMutableArray *)imageArr getDic:(NSDictionary *)getdic postDic:(NSDictionary *)postdic {
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_group_async(group, globalQueue, ^{
        for (int i = 0; i < imageArr.count; i ++) {
            WSImageModel *imgModel = imageArr[i];
            NSArray * imagear = [NSArray arrayWithObject:imgModel.image];;
            dispatch_group_enter(group);
            [[UploadTool shareInstance] upLoadAttachmentArr:imagear attacheType:JTAttacheImage getDic:getdic postDic:postdic complete:^{
                if (i == imageArr.count - 1) {
                    [self.pickerView.HUD hideAnimated:YES];
                }
                
            } success:^(id response) {
                [self.pickerView.photosArray removeAllObjects];
                [self.uploadModel.aidArray removeAllObjects];
                
                imgModel.aid = [NSString stringWithFormat:@"%@",response];
                
                NSLog(@"aid ===============> %@,=========== sort =========>%ld",[NSString stringWithFormat:@"%@",response],imgModel.sort);
                [self.uploadModel.imageModelArray addObject:imgModel];
                [self.uploadModel.imageModelArray sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                    WSImageModel *ws1 = obj1;
                    WSImageModel *ws2 = obj2;
                    
                    if (ws1.sort > ws2.sort) {
                        return 1;
                    } else if (ws1.sort == ws2.sort) {
                        return 0;
                    }
                    else {
                        return -1;
                    }
                }];
                
                for (WSImageModel *ws in self.uploadModel.imageModelArray) {
                    [self.pickerView.photosArray addObject:ws.image];
                    [self.uploadModel.aidArray addObject:ws.aid];
                }
                
                [self.pickerView refreshCollectionView];
                // 请求成功发送信号量(+1)
                dispatch_semaphore_signal(semaphore);
            } failure:^(NSError *error) {
                if (error != nil) {
                    [MBProgressHUD showInfo:[NSString stringWithFormat:@"第%ld张图片上传失败",imgModel.sort]];
                }
                // 失败也请求成功发送信号量(+1)
                dispatch_semaphore_signal(semaphore);
            }];
            //信号量减1，如果>0，则向下执行，否则等待
            dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        }
    });
}

@end
