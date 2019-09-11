//
//  JTSegmentedCell.h
//  Test_Segment
//
//  Created by HB on 17/1/12.
//  Copyright © 2017年 comsenz-service.com.  All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, LayoutType){
    emptyData = 0,
    onlyText,
    onlyImage,
    textWithImage,
};
@interface JTSegmentedCell : UIView

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, assign) LayoutType layout;
@property (nonatomic, assign) CGFloat iconRelativeScaleFactor;
@property (nonatomic, assign) CGFloat spaceBetweenImageAndLabelRelativeFactor;

@end
