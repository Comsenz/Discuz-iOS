//
//  UploadImageContainView.h
//  DiscuzMobile
//
//  Created by HB on 16/11/22.
//  Copyright © 2016年 comsenz-service.com.  All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^AddPhotoBlock)(void);
typedef void(^SendAidBlock)(NSArray *arr);

@interface UploadImageContainView : UIView

@property (nonatomic, strong) UIButton * imagephoto;
@property (nonatomic, strong, readonly) NSMutableArray * aidArray; // 存放tag
@property (nonatomic, strong) NSMutableArray<UIImageView *> * iamgevViews; // 存放imageview数组
@property (nonatomic, strong) NSMutableArray<UIImage *> *images;
@property (nonatomic, assign) NSInteger maxImage;
@property (nonatomic, copy) AddPhotoBlock addPhotoBlock;
@property (nonatomic, copy) SendAidBlock sendAidBlock;

- (void)resetUploadView;

- (void)setImageView:(UIImageView *)smallimage andStr:(NSString *)str;


@end
