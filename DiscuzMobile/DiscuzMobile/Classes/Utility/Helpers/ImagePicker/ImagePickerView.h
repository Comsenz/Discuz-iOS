//
//  ImagePickerView.h
//  DiscuzMobile
//
//  Created by HB on 2017/6/9.
//  Copyright © 2017年 comsenz-service.com.  All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^FinishPickingBlock)(UIImage *image);

@interface ImagePickerView : UIView

@property (nonatomic, weak) UINavigationController *navigationController;
@property (nonatomic, copy) FinishPickingBlock finishPickingBlock;

-(void)openSheet;

@end
